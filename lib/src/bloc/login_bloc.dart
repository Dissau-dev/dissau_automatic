import 'dart:async';

import 'package:dissau_automatic/src/bloc/validators.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _pref = PreferenciasUsuario();

  // Controllers para email y password
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Controllers para chat
  final _chatNameController = BehaviorSubject<String>();
  final _chatIdController = BehaviorSubject<String>();
  final _botTokenController = BehaviorSubject<String>();

  // Controllers para cambio de contraseña
  final _passwordChangeController = BehaviorSubject<String>();
  final _passwordConfirmController = BehaviorSubject<String>();

// Streams para email y password
  Stream<String> get emailStream =>
      _emailController.stream.transform(validatorEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatorPassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Streams para chat
  Stream<String> get chatNameStream =>
      _chatNameController.stream.transform(validatorChatName);
  Stream<String> get chatIdStream =>
      _chatIdController.stream.transform(validatorChatId);
  Stream<String> get botTokenStream =>
      _botTokenController.stream.transform(validatorBotToken);

  Stream<bool> get formChatStream => Rx.combineLatest3(
      chatNameStream, chatIdStream, botTokenStream, (n, i, t) => true);

  // Streams para cambio de contraseña
  Stream<String> get passwordChangeStream =>
      _passwordChangeController.stream.transform(validatorPassword);
  Stream<String> get passwordConfirmStream =>
      _passwordConfirmController.stream.transform(validatorPassword);

  Stream<bool> get passwordMatchStream => Rx.combineLatest2(
        passwordChangeStream,
        passwordConfirmStream,
        (change, confirm) => change == confirm,
      );

// insertar valores para email and password
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePasssword => _passwordController.sink.add;

  String get email => _emailController.value;
  String get password => _passwordController.value;

  // insertar valores para el chatForm
  Function(String) get changeChatName => _chatNameController.sink.add;
  Function(String) get changeChatId => _chatIdController.sink.add;
  Function(String) get changeBotToken =>
      _botTokenController.sink.add; // Añadir esta función

  String get chatName =>
      _chatNameController.hasValue ? _chatNameController.value : _pref.chatName;
  String get chatId =>
      _chatIdController.hasValue ? _chatIdController.value : _pref.chatIdUser;
  String get botToken =>
      _botTokenController.hasValue ? _botTokenController.value : _pref.botToken;

  // Insertar valores en cambio de contraseña
  Function(String) get changePasswordChange =>
      _passwordChangeController.sink.add;
  Function(String) get changePasswordConfirm =>
      _passwordConfirmController.sink.add;

  // Obtener valores actuales de cambio de contraseña
  String get passwordChange => _passwordChangeController.valueOrNull ?? '';
  String get passwordConfirm => _passwordConfirmController.valueOrNull ?? '';

  dispose() {
    _emailController.close();
    _passwordController.close();
    _chatIdController.close();
    _chatIdController.close();
    _botTokenController.close();
    _passwordChangeController.close();
    _passwordConfirmController.close();
  }
}
