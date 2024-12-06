import 'package:dissau_automatic/providers/user_provider.dart';
import 'package:dissau_automatic/src/bloc/login_bloc.dart';
import 'package:dissau_automatic/src/bloc/provider.dart';
import 'package:dissau_automatic/src/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_bart.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool viewPassword = false;
  final userProvider = new UserProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _placeholder());
  }

  Widget _placeholder() {
    return Stack(
      children: [
        // Imagen de fondo con degradado
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Color(0xFF372781), // Color principal (centro)
                Color(0xFF25253A), // Color de fondo (extremos)
              ],
              radius: 0.6, // Ajusta el radio para el efecto deseado
              center: Alignment
                  .topRight, // Centrado hacia la esquina superior derecha
              stops: [0.3, 1.0], // Controla la transición entre colores
            ),
          ),
        ),
        SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinear el texto a la izquierda
                children: [
                  const SizedBox(height: 50),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: // Espacio superior
                          const Text(
                        "Sign In",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700),
                      )),
                  const SizedBox(height: 10),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: // Espaciado entre los textos
                          const Text(
                        "Complete your data for enter to the app",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Color.fromARGB(255, 226, 226, 245),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w200),
                      )),
                  const SizedBox(height: 50), // Espaciado antes del formulario
                  Align(
                    alignment: Alignment
                        .center, // Centrar el formulario horizontalmente
                    child: _loginForm(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = Provider.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          width: size.width * 0.8,
          child: Column(
            children: [
              _sizeBox(40.0),
              _emailField(bloc),
              _sizeBox(20.0),
              _passwordField(bloc),
              _sizeBox(20.0),
              _Btn(bloc),
            ],
          ),
        ),
        TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'register'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Do not register? ",
                  style: TextStyle(
                      color: Color.fromARGB(210, 251, 251, 251),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w200),
                ),
                const Text(" Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700)),
              ],
            )),
        _sizeBox(50.0),
      ],
    );
  }

  Widget _sizeBox(double height) {
    return SizedBox(
      height: height,
    );
  }

  Widget _emailField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.emailStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            cursorColor: Colors.white,
            cursorWidth: 1.0,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF2E2D4D),
              hintText: "email@example.com",
              hintStyle: TextStyle(color: Colors.white54),
              prefixIcon: Icon(Icons.email, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Colors.white, width: 0.1), // Color del contorno
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    15), // Asegúrate de mantener el borderRadius aquí
                borderSide: BorderSide(
                    color: Colors.white, width: 0.3), // Color al enfocar
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    15), // Asegúrate de mantener el borderRadius aquí
                borderSide: BorderSide(
                    color: Colors.white, width: 0.1), // Color habilitado
              ),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
            onChanged: bloc.changeEmail,
          );
        });
  }

  Widget _passwordField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextFormField(
            cursorColor: Colors.white,
            cursorWidth: 1.0,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF2E2D4D),
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
                    color: Colors.white, width: 0.1), // Color del contorno
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    15), // Asegúrate de mantener el borderRadius aquí
                borderSide: BorderSide(
                    color: Colors.white, width: 0.3), // Color al enfocar
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    15), // Asegúrate de mantener el borderRadius aquí
                borderSide: BorderSide(
                    color: Colors.white, width: 0.1), // Color habilitado
              ),
            ),
            obscureText: !viewPassword,
            onChanged: bloc.changePasssword,
          );
        });
  }

  Widget _Btn(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
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
                  isLoading ? 'Loading...' : 'Sign in',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ));
        });
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
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      showAlert(context, info["message"]);
    }
  }

  _viewPassword() {
    setState(() {
      viewPassword = !viewPassword;
    });
  }
}
