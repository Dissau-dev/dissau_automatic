import 'dart:ffi';

import 'package:dissau_automatic/providers/subscription_model.dart';
import 'package:dissau_automatic/src/bloc/login_bloc.dart';
import 'package:dissau_automatic/src/bloc/provider.dart';
import 'package:dissau_automatic/src/pages/profile/payment_page.dart';
import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:dissau_automatic/src/utils/utils.dart';
import 'package:dissau_automatic/src/widgets/form_fields.dart';
import 'package:dissau_automatic/src/widgets/subscription._widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../providers/user_provider.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool isLoading = false;
  bool viewPassword = false;
  final userProvider = new UserProvider();
  final _pref = new PreferenciasUsuario();
  final subscription = PreferenciasUsuario().subscription;
  final usuario = PreferenciasUsuario().user;
  final UserProvider _userProvider = UserProvider();
  bool cancelling = false; // Variable para manejar el estado de cancelación
  _viewPassword() {
    setState(() {
      viewPassword = !viewPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 0.6,
            stops: [0.3, 1.0],
            colors: [
              Color(0xFF372781), // Color principal
              Color(0xFF25253A), // Color de fondo
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _chatForm(bloc)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    Map info = await userProvider.loginUser(bloc.email, bloc.password);

    setState(() {
      isLoading = false;
    });

    if (info['ok']) {
      Fluttertoast.showToast(
        msg: "Changes done",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xFF1D88E6),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: info["message"],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Widget _chatForm(LoginBloc bloc) {
    return SingleChildScrollView(
      child: Center(
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(0, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(24.0)),
              border: Border(
                top: BorderSide(color: Color(0xff56567f), width: 2.5),
                left: BorderSide(color: Color(0xff56567f), width: 2.5),
                right: BorderSide(color: Color(0xff56567f), width: 2.5),
                bottom: BorderSide(color: Color(0xff56567f), width: 2.5),
              ),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2.0)],
            ),
            padding: EdgeInsets.all(20.0),
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Change your password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                _passwordField(
                    bloc, bloc.passwordChangeStream, bloc.changePasswordChange),
                SizedBox(height: 16),
                _passwordField(bloc, bloc.passwordConfirmStream,
                    bloc.changePasswordConfirm),
                _Btn(bloc),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Btn(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordMatchStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
              margin: EdgeInsets.only(top: 50),
              width: 320.0,
              height: 52.0,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF372781),
                        blurRadius: 20.0,
                        offset: Offset(0.0, 8.0))
                  ],
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color(0xFF1D88E6)),
              child: TextButton(
                onPressed: snapshot.hasData || !isLoading
                    ? () => _login(bloc, context)
                    : null, // El botón estará deshabilitado si no hay datos,

                child: Text(
                  isLoading ? 'Loading...' : 'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ));
        });
  }

  Widget _passwordField(LoginBloc bloc, stream, change) {
    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            cursorColor: Color(0xFF1D88E6),
            cursorWidth: 1.0,
            style: const TextStyle(
                color: Colors.white, fontFamily: 'Poppins', fontSize: 14),
            decoration: InputDecoration(
              hintText: "password",
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.lock_clock_outlined, color: Colors.white),
              suffixIcon: IconButton(
                  onPressed: _viewPassword,
                  icon: viewPassword
                      ? Icon(
                          Icons.visibility_off,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.visibility,
                          color: Colors.white,
                        )),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Color(0xFF1D88E6), width: 0.5), // Color del contorno
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    15), // Asegúrate de mantener el borderRadius aquí
                borderSide: BorderSide(
                    color: Color(0xFF1D88E6), width: 1.0), // Color al enfocar
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    15), // Asegúrate de mantener el borderRadius aquí
                borderSide: BorderSide(
                    color: Color(0xFF1D88E6), width: 0.5), // Color habilitado
              ),
            ),
            obscureText: !viewPassword,
            onChanged: change,
          );
        });
  }
}
