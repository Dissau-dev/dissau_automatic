import 'dart:async';

import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';

mixin Validators {
  final validatorPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError("Password is to short");
      }
    },
  );
  final validatorEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      String pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if (regExp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError("invalid email address");
      }
    },
  );

  final validatorChatName = StreamTransformer<String, String>.fromHandlers(
    handleData: (chatName, sink) {
      if (!chatName.isEmpty) {
        sink.add(chatName);
      } else {
        sink.addError("Field is required");
      }
    },
  );
  final validatorChatId = StreamTransformer<String, String>.fromHandlers(
    handleData: (chatId, sink) {
      final RegExp regex = RegExp(r'^-\d{9,12}$');
      final _pref = new PreferenciasUsuario();
      if (chatId.isEmpty && _pref.chatIdUser.isEmpty) {
        sink.addError("Invalid chat id");
      }
      if (regex.hasMatch(chatId)) {
        sink.add(chatId);
      } else if (!regex.hasMatch(chatId)) {
        sink.addError("Invalid chat id");
      }
    },
    // Expresión regular para verificar si el chat ID es un número entero
    // que empieza con "-" (negativo) y tiene entre 9 y 12 dígitos.
  );
}
