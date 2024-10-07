import 'dart:async';

import 'package:dissau_automatic/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class ChatBot with Validators {
  final _chatNameController = BehaviorSubject<String>();
  final _chatIdController = BehaviorSubject<String>();

//Recuperar los datos del stream
  Stream<String> get chatNameStream => _chatNameController.stream;
  Stream<String> get chatIdStream =>
      _chatIdController.stream.transform(validatorChatId);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(chatIdStream, chatNameStream, (e, p) => true);

// insertar valores a stream
  Function(String) get changeChatName => _chatNameController.sink.add;
  Function(String) get changeChatId => _chatIdController.sink.add;

  String get chatName => _chatNameController.value;
  String get chatId => _chatIdController.value;

  dispose() {
    _chatIdController?.close();
    _chatIdController?.close();
  }
}
