import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget btnTest(bool isConnected, void Function() onTest) {
  final _pref = new PreferenciasUsuario();
  return Container(
    width: 140.0,
    height: 38.0,
    margin: EdgeInsets.only(bottom: 16.0, right: 8.0),
    decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10.0),
        color: Color.fromARGB(0, 248, 248, 248)),
    child: TextButton(
      onPressed: () {
        ((_pref.chatIdUser.isNotEmpty && _pref.botToken.isNotEmpty) &&
                isConnected)
            ? onTest()
            : Fluttertoast.showToast(
                msg: "You need Connect the bot before to test",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Color.fromARGB(255, 120, 110, 4),
                textColor: Colors.white,
                fontSize: 16.0,
              );
        ;
      },
      child: const Text(
        "Test",
        style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      ),
    ),
  );
}
