import 'package:dissau_automatic/src/bloc/login_bloc.dart';
import 'package:dissau_automatic/src/bloc/provider.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_background/flutter_background.dart';

class SmsPage extends StatefulWidget {
  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  final _pref = new PreferenciasUsuario();
  String smsToSend = "";
  bool isConnected = true;
  bool isEditing = false;
  String botToken = '6664921519:AAESkD025zmDyB9Z8fh87n1sSRDYyX1pmGo';

  // Controladores de texto para editar campos
  late TextEditingController botIdController;

  Future<void> sendMessageToTelegram(String message) async {
    final String apiUrl = 'https://api.telegram.org/bot$botToken/sendMessage';

    final Map<String, dynamic> messageData = {
      'chat_id': _pref.chatIdUser,
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

  final _plugin = Readsms();
  void initformStae() {
    super.initState();
    botIdController = TextEditingController(text: botToken);
  }

  @override
  void initState() {
    super.initState();
    initformStae();
    initializeBackground();
    getPermission().then((value) {
      if (value) {
        _plugin.read();
        _plugin.smsStream.listen((event) {
          // Enviar el SMS recibido al bot de Telegram
          onSmsReceived(event);
        });
      }
    });
  }

  Future<void> initializeBackground() async {
    // Configurar el modo en segundo plano

    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Servicio en segundo plano",
      notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
    );

    await FlutterBackground.initialize(androidConfig: androidConfig);
    await FlutterBackground.enableBackgroundExecution();
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
    botIdController.dispose();
    _plugin.dispose();
  }

  // Modal para editar los campos de la tarjeta
  void _editCardFields(LoginBloc bloc) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Campos"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _chatNameField(bloc),
              TextField(
                controller: botIdController,
                decoration: InputDecoration(labelText: "Bot ID"),
              ),
              _chatIdField(bloc)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  // Actualizar los valores

                  botToken = botIdController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void onSmsReceived(SMS sms) {
    // Formatear la fecha
    // Suponiendo que sms.timeReceived es de tipo DateTime
    final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
    String formattedDate = formatter.format(sms.timeReceived);

    setState(() {
      smsToSend =
          "${sms.sender}:\n${sms.body}\n\n$formattedDate"; // Usa formattedDate aquí
    });
    // Lógica para manejar el SMS recibido

    // Enviar el contenido del SMS al bot de Telegram
    if (!_pref.chatIdUser.isEmpty && isConnected) {
      sendMessageToTelegram(smsToSend);
      print(
          "=========================== ${smsToSend}  ================ ${_pref.chatIdUser}====");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () => _logOut(context),
                ),
              ],
              title: Center(
                child: Text(
                  'Dissau Automatic',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          body: _placeholder()),
    );
  }

  Widget _placeholder() {
    final bloc = Provider.of(context);
    return (Stack(
      children: [
        // Imagen de fondo
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                // Color(Colors.deepPurple)
                Color.fromARGB(255, 103, 58, 183),

                Color.fromARGB(255, 169, 114, 232),
                Color.fromARGB(255, 183, 160, 210),
                Color.fromARGB(255, 255, 255, 255),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Center(
          child: _chatForm(bloc),
        )
      ],
    ));
  }

  Widget _chatForm(LoginBloc bloc) {
    return SingleChildScrollView(
      child: Center(
        child: Expanded(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              padding: EdgeInsets.all(24.0),
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isConnected && _pref.chatIdUser.isNotEmpty
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            isConnected && _pref.chatIdUser.isNotEmpty
                                ? 'Connected'
                                : 'Disconnected',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: isEditing
                            ? Icon(Icons.keyboard_arrow_right)
                            : Icon(Icons.keyboard_arrow_down),
                        onPressed: () {
                          _pref.chatName.isEmpty
                              ? null
                              : setState(() {
                                  isEditing = !isEditing;
                                });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    _pref.chatName.isEmpty
                        ? "Default Chat"
                        : ("${_pref.chatName} (${_pref.chatIdUser.isEmpty ? null : _pref.chatIdUser})"),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  if (isEditing || _pref.chatName.isEmpty) ...[
                    SizedBox(height: 16),
                    _chatNameField(bloc),
                    SizedBox(height: 16),
                    _chatIdField(bloc),
                    SizedBox(height: 16),
                    _BtnSave(bloc)
                  ],
                  SizedBox(
                    height: 30.0,
                  ),
                  _btnConect(bloc)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _chatNameField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.chatNameStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.deepPurple,
                  ),
                  hintText: ("chat name"),
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  labelText: "chat name"),
              // counterText : snapshot.data,
              onChanged: bloc.changeChatName,
            ),
          );
        });
  }

  Widget _btnConect(LoginBloc bloc) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 0.001),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: isConnected && _pref.chatIdUser.isNotEmpty
            ? Colors.red
            : Colors.blue,
      ),
      child: TextButton(
        onPressed: () {
          _pref.chatName.isEmpty
              ? null
              : setState(() {
                  isConnected = !isConnected;
                });
        },
        child: Text(
          isConnected && _pref.chatIdUser.isNotEmpty
              ? 'Disconnect'
              : 'Connect Bot',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _chatIdField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.chatIdStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: TextField(
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.telegram_outlined,
                    color: Colors.deepPurple,
                  ),
                  hintText: ("e: -111111111"),
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  labelText: "chat Id"),
              // counterText : snapshot.data,
              onChanged: bloc.changeChatId,
            ),
          );
        });
  }

  _logOut(BuildContext context) async {
    final _prefs = new PreferenciasUsuario();
    _prefs.token = "";
    Navigator.pushReplacementNamed(context, 'login');
  }

  Widget _BtnSave(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formChatStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextButton(
            onPressed: () {
              snapshot.hasError
                  ? null
                  : print("${bloc.chatName},  ${bloc.chatId}");
              final _prefs = new PreferenciasUsuario();
              if (bloc.chatName.isNotEmpty) {
                _prefs.chatName = bloc.chatName;
              }
              if (bloc.chatId.isNotEmpty) {
                _prefs.chatIdUser = bloc.chatId;
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.green,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
