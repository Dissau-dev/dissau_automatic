import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:dissau_automatic/src/widgets/form_fields.dart';
import 'package:flutter/material.dart';
import 'package:dissau_automatic/src/bloc/login_bloc.dart';

class ChatForm extends StatefulWidget {
  const ChatForm(LoginBloc bloc, {Key? key}) : super(key: key);

  @override
  State<ChatForm> createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  bool isEditing = false;
  bool isSaving = false;
  bool isConnected = false;
  final _pref = new PreferenciasUsuario();

  Widget chatForm(LoginBloc bloc) {
    return SingleChildScrollView(
      child: Center(
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      //   _btnTest(),
                    ]),
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
                  chatFormField(
                      bloc,
                      bloc.changeChatName,
                      _pref.chatName,
                      "chat name",
                      "Chat name",
                      bloc.chatNameStream,
                      Icons.chat_bubble_outline),
                  SizedBox(height: 16),
                  chatFormField(
                      bloc,
                      bloc.changeChatId,
                      _pref.chatIdUser,
                      "e: -111111111",
                      "Chat id",
                      bloc.chatIdStream,
                      Icons.telegram_outlined),
                  SizedBox(height: 16),
                  chatFormField(
                      bloc,
                      bloc.changeBotToken,
                      _pref.botToken,
                      "e: 6664921519:AAESkD025zmDyB9Z8fh87n1sSRDYyX1pmGo",
                      "Bot token",
                      bloc.chatIdStream,
                      Icons.code),
                  SizedBox(height: 16),
                  // _BtnSave(bloc)
                ],
                SizedBox(
                  height: 30.0,
                ),
                //  _btnConect(bloc)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(width: 8),
            Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _saveButton(LoginBloc bloc) {
    return TextButton(
      onPressed: () {},
      child: Text('Save Changes'),
    );
  }

  Widget _connectButton(LoginBloc bloc) {
    return TextButton(
      onPressed: () {},
      child: Text(isConnected ? 'Disconnect' : 'Connect Bot'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
