import 'dart:io';
import 'dart:ui';
import 'package:dissau_automatic/src/bloc/login_bloc.dart';
import 'package:dissau_automatic/src/bloc/provider.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:dissau_automatic/src/widgets/animations/radar_effect.dart';
import 'package:dissau_automatic/src/widgets/app_bart.dart';
import 'package:dissau_automatic/src/widgets/baner.dart';

import 'package:dissau_automatic/src/widgets/btn.dart';
import 'package:dissau_automatic/src/widgets/form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> requestPermissions() async {
  await [
    Permission.notification,
    Permission.accessNotificationPolicy,
    Permission.sms,
  ].request();
}

Future<void> initializeService() async {
  final _pref = PreferenciasUsuario();
  await _pref
      .ensureInitialized(); // Asegura que las preferencias se inicialicen correctamente

  final service = FlutterBackgroundService();
  await requestPermissions();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: "Sms service",
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();

  return true;
}

Timer? _notificationTimer; // Declara un temporizador global

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final _pref = PreferenciasUsuario();
  await _pref.ensureInitialized();
  final _plugin = Readsms();
  _plugin.read();
  _plugin.smsStream.listen((e) async {
    print("========  ${_pref.isConnected}");
    onSmsReceived(e);
  });

  // Leer el estado de conexión directamente de SharedPreferences

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  _notificationTimer =
      Timer.periodic(const Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance && _pref.isConnected) {
      flutterLocalNotificationsPlugin.show(
        888,
        "Dissau automatic",
        'Sms service',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
        ),
      );

      service.setForegroundNotificationInfo(
        title: "My App Service",
        content: "Dissau sms service",
      );
    } else {
      timer.cancel();
      await _disableNotifications();
      service.stopSelf();
    }
  });
}

Future<void> startService() async {
  final _pref = PreferenciasUsuario();
  await _pref.ensureInitialized();
  final service = FlutterBackgroundService();
  // Aquí puedes implementar el inicio del servicio en segundo plano.
  // Si estás usando una librería, asegúrate de configurarla aquí.

  await service.startService();
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _disableNotifications() async {
  // Detener el servicio de notificaciones si está corriendo
  // Remueve todas las notificaciones activas
  await flutterLocalNotificationsPlugin.cancel(888);
}

void disconnectService() async {
  final _pref = new PreferenciasUsuario();
  _pref.resetIsConnected();

  if (_notificationTimer != null) {
    _notificationTimer!.cancel();
    _notificationTimer = null;
  }

  final service = FlutterBackgroundService();
  if (await service.isRunning()) {
    service.invoke("stopService");
  }

  await _disableNotifications();
}

String textSms = "";

void onSmsReceived(SMS sms) async {
  final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
  String formattedDate = formatter.format(sms.timeReceived);

  String smsToSend = "${sms.sender}:\n${sms.body}\n\n$formattedDate";
  textSms = smsToSend;

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Guardar el SMS en SharedPreferences (opcional)
  List<String> log = prefs.getStringList('sms_log') ?? [];
  log.add(smsToSend);
  await prefs.setStringList('sms_log', log);

  // Enviar a Telegram si las condiciones se cumplen
  final _pref = PreferenciasUsuario();
  await _pref.ensureInitialized(); // Espera a la inicialización completa

  if (_pref.chatIdUser.isNotEmpty) {
    sendMessageToTelegram(smsToSend, _pref.botToken, _pref.chatIdUser);
  }
}

Future<void> sendMessageToTelegram(
    String message, String botToken, String chatId) async {
  final String apiUrl = 'https://api.telegram.org/bot$botToken/sendMessage';

  final Map<String, dynamic> messageData = {
    'chat_id': chatId,
    'text': message,
  };

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode(messageData),
  );

  if (response.statusCode == 200) {
    print('Mensaje enviado a Telegram: $message');
  } else {
    print('Error al enviar el mensaje: ${response.statusCode}');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _SmsPageState();
}

class _SmsPageState extends State<HomePage> {
  //String botToken = '6664921519:AAESkD025zmDyB9Z8fh87n1sSRDYyX1pmGo';
  String botToken = "";
  // final String chatId = '-4179106964'; // Asegúrate de que este ID sea correcto
  final _pref = new PreferenciasUsuario();
  String smsToSend = "";
  // Inicializado desde preferencias
  bool isEditing = false;
  bool isSaving = false;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _loadConnectionStatus();
  }

  Future<void> _loadConnectionStatus() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      await service.startService();
    }
  }

  Future<bool> getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTest() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
    String formattedDate = formatter.format(DateTime.now());
    setState(() {
      smsToSend =
          "${"Test"}:\n${"service is alive"}\n\n$formattedDate"; // Usa formattedDate aquí
    });
    if (_pref.chatIdUser.isNotEmpty && isConnected) {
      sendMessageToTelegram(smsToSend, _pref.botToken, _pref.chatIdUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: CustomAppBar(), body: SafeArea(child: _placeholder())),
    );
  }

  Widget _placeholder() {
    final bloc = Provider.of(context);
    return Stack(
      children: [
        // Imagen de fondo
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF372781), // Color principal (centro)
                Color(0xFF25253A), // Color de fondo (extremos)
              ],
              radius: 0.6, // Ajusta el radio para el efecto deseado
              center: Alignment(0.0, 0.7), // Centrado un poco hacia arriba
              stops: [0.3, 1.0], // Controla la transición entre colores
            ),
          ),
        ),
        SingleChildScrollView(
            child: Column(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Centra verticalmente al fina
          children: [
            const Baner(),
            if (!isEditing)
              SizedBox(height: MediaQuery.of(context).size.height * 0.32),
            Align(
              alignment: Alignment.bottomCenter,
              child: _chatForm(bloc), // Siempre al final de la pantalla
            ),
          ],
        )),
      ],
    );
  }

  Widget _chatForm(LoginBloc bloc) {
    return SingleChildScrollView(
      child: Center(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: isEditing
                  ? Color.fromARGB(0, 255, 255, 255)
                  : Color(0xFF3088EE),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
              border: const Border(
                top: BorderSide(color: Color(0xff56567f), width: 1.5),
                left: BorderSide(color: Color(0xff56567f), width: 1.5),
                right: BorderSide(color: Color(0xff56567f), width: 1.5),
              ),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            padding: EdgeInsets.all(20.0),
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: isEditing ? 20.0 : 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        RadarEffect(
                            isConnected: isConnected, isEditing: isEditing)
                      ],
                    ),
                    Expanded(
                        child: Text(
                      "${_pref.chatName}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: isEditing ? 14 : 16,
                          color: isEditing ? Colors.white : Colors.black),
                    )),
                    Row(
                      children: [
                        if (isEditing) _BtnSave(bloc),
                        IconButton(
                          icon: isEditing
                              ? const Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.white,
                                  size: 28.0,
                                )
                              : const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                  size: 28.0,
                                ),
                          onPressed: () {
                            _pref.chatName.isEmpty
                                ? null
                                : setState(() {
                                    isEditing = !isEditing;
                                  });
                          },
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                if (isEditing || _pref.chatName.isEmpty) ...[
                  SizedBox(height: 16),
                  chatFormField(
                      bloc,
                      bloc.changeChatName,
                      "${_pref.chatName}",
                      "Chat name",
                      "Chat name",
                      bloc.chatNameStream,
                      Icons.chat_bubble_outline),
                  SizedBox(height: 16),
                  chatFormField(
                      bloc,
                      bloc.changeChatId,
                      "${_pref.chatIdUser}",
                      "e: -111111111",
                      "Chat Id",
                      bloc.chatIdStream,
                      Icons.telegram_outlined),
                  SizedBox(height: 16),
                  chatFormField(
                      bloc,
                      bloc.changeBotToken,
                      "${_pref.botToken}",
                      ("e: 6664921519:AAESkD025zmDyB9Z8fh87n1sSRDYyX1pmGo"),
                      "Bot token",
                      bloc.botTokenStream,
                      Icons.code_outlined),
                  SizedBox(height: 16),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 0,
                        ),
                        btnTest(isConnected, onTest),
                      ]),
                  const SizedBox(
                    height: 4.0,
                  ),
                ],
                _btnConect(bloc),
                const SizedBox(
                  height: 4.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _logOut(BuildContext context) async {
    final prefs = new PreferenciasUsuario();
    prefs.token = "";
    Navigator.pushReplacementNamed(context, 'login');
  }

  Widget _BtnSave(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formChatStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return IconButton(
            icon: Icon(
              Icons.save_outlined,
              color: isSaving ? Colors.grey : Colors.white,
              size: 28,
            ),
            onPressed: () {
              final prefs = new PreferenciasUsuario();
              if (bloc.chatName.isNotEmpty) {
                prefs.chatName = bloc.chatName;
              }
              if (bloc.chatId.isNotEmpty) {
                prefs.chatIdUser = bloc.chatId;
              }
              if (bloc.botToken.isNotEmpty) {
                prefs.botToken = bloc.botToken;
              }

              if (bloc.chatName.isNotEmpty &&
                  bloc.chatId.isNotEmpty &&
                  bloc.botToken.isNotEmpty) {
                setState(() {
                  isSaving = true;
                });
                Future.delayed(Duration(seconds: 1), () {
                  setState(() {
                    isSaving = false;
                  });
                  Fluttertoast.showToast(
                    msg: "Changes done",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xFF1D88E6),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                });
              }
              // Esperar 2 segundos y mostrar el toast
            },
          );
        });
  }

  Widget _btnConect(LoginBloc bloc) {
    return Container(
      width: isEditing ? 300.0 : 320.0,
      height: 42.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
            color: Colors.white, // Color del borde
            width: isEditing && isConnected ? 0 : 1 // Grosor del borde
            ),
        color: isConnected && _pref.chatIdUser.isNotEmpty
            ? Color(0xFF1D88E6)
            : Color.fromARGB(5, 255, 255, 255),
      ),
      child: TextButton(
        onPressed: () async {
          final service = FlutterBackgroundService();

          if (_pref.chatName.isEmpty) {
            Fluttertoast.showToast(
              msg: "Please configure the chat settings first.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return;
          }

          if (isConnected) {
            _pref.isConnected = false;
            service.invoke("stopService");
            await flutterLocalNotificationsPlugin.cancel(888);

            setState(() {
              isConnected = false;
            });
          } else {
            _pref.isConnected = true;
            setState(() {
              isConnected = true;
            });

            await service.startService();
          }
        },
        child: Text(
          isConnected && _pref.chatIdUser.isNotEmpty ? 'Disconnect' : "Connect",
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
