import 'dart:async';

import 'package:dissau_automatic/src/bloc/validators.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _pref = new PreferenciasUsuario();

  final _chatNameController = BehaviorSubject<String>();
  final _chatIdController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

//Recuperar los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validatorEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatorPassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  //Recuperar los datos del stream
  Stream<String> get chatNameStream =>
      _chatNameController.stream.transform(validatorChatName);
  Stream<String> get chatIdStream =>
      _chatIdController.stream.transform(validatorChatId);

  Stream<bool> get formChatStream =>
      Rx.combineLatest2(chatIdStream, chatNameStream, (e, p) => true);

// insertar valores a stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePasssword => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  // insertar valores a stream
  Function(String) get changeChatName => _chatNameController.sink.add;
  Function(String) get changeChatId => _chatIdController.sink.add;

  String get chatName =>
      _chatNameController.hasValue ? _chatNameController.value : _pref.chatName;
  String get chatId =>
      _chatIdController.hasValue ? _chatIdController.value : _pref.chatIdUser;

  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _chatIdController?.close();
    _chatIdController?.close();
  }
}
