import 'dart:async';

import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:readsms/readsms.dart';
import 'package:intl/intl.dart';

class SmsService {
  final _pref = PreferenciasUsuario();
  final _plugin = Readsms();

  Future<void> initializeBackground() async {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "Servicio en segundo plano",
      notificationIcon: AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
    );

    await FlutterBackground.initialize(androidConfig: androidConfig);
    await FlutterBackground.enableBackgroundExecution();
  }

  Future<bool> getPermission(PermissionStatus status) async {
    if (status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void listenForSms(StreamController<SMS> onSmsReceived) {
    _plugin.read();
    _plugin.smsStream.listen((event) => onSmsReceived.add(event));
  }

  Future<void> sendMessageToTelegram(String message) async {
    final String apiUrl =
        'https://api.telegram.org/bot${_pref.botToken}/sendMessage';
    final Map<String, dynamic> messageData = {
      'chat_id': _pref.chatIdUser,
      'text': message,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(messageData),
    );

    if (response.statusCode != 200) {
      print('Error al enviar el mensaje: ${response.statusCode}');
    }
  }

  String formatSmsMessage(SMS sms) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm');
    String formattedDate = formatter.format(sms.timeReceived);
    return "${sms.sender}:\n${sms.body}\n\n$formattedDate";
  }
}
