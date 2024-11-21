import 'package:dissau_automatic/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:dissau_automatic/src/bloc/login_bloc.dart';
import 'package:dissau_automatic/src/bloc/provider.dart';
import 'package:dissau_automatic/src/utils/utils.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  bool viewPassword = false;
  final userProvider = new UserProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _createBack(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _createBack(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final backPurple = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 153, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circle = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    final titleApp = Container(
      padding: EdgeInsets.only(top: 90.0),
      child: Column(
        children: [
          Icon(
            Icons.person_pin_circle,
            color: Colors.white,
            size: 100.0,
          ),
          SizedBox(
            height: 10.0,
            width: double.infinity,
          ),
          Text(
            "Dissau Automatic",
            style: TextStyle(color: Colors.white, fontSize: 30),
          )
        ],
      ),
    );

    return Stack(children: <Widget>[
      backPurple,
      Positioned(top: 90, left: 30, child: circle),
      Positioned(top: -40, right: -30, child: circle),
      Positioned(bottom: -50, right: -10, child: circle),
      Positioned(bottom: 120, right: 20, child: circle),
      Positioned(bottom: -50, left: -20, child: circle),
      titleApp
    ]);
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 200.0,
          )),
          Container(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            width: size.width * 0.8,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            // height: size.height * 0.4
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 3.0))
            ], color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              children: [
                Text(
                  "Sign up",
                  style: TextStyle(fontSize: 20.0),
                ),
                _sizeBox(40.0),
                _emailField(bloc),
                _sizeBox(20.0),
                _passwordField(bloc),
                _sizeBox(20.0),
                _Btn(bloc)
              ],
            ),
          ),
          TextButton(
            onPressed: () => _onBack(context, bloc),
            child: Text(
              "Do you have an account ?",
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
          _sizeBox(100.0)
        ],
      ),
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
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.alternate_email,
                    color: Colors.deepPurple,
                  ),
                  hintText: ("ejemplo@gmail.com"),
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  labelText: "email"),
              // counterText : snapshot.data,
              onChanged: bloc.changeEmail,
            ),
          );
        });
  }

  Widget _passwordField(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: !viewPassword,
              onChanged: bloc.changePasssword,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.lock_clock_outlined,
                    color: Colors.deepPurple,
                  ),
                  suffix: IconButton(
                      onPressed: _viewPassword,
                      icon: viewPassword
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility)),
                  errorText:
                      snapshot.hasError ? snapshot.error.toString() : null,
                  labelText: "password"),
            ),
          );
        });
  }

  Widget _Btn(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextButton(
              onPressed: snapshot.hasData || !isLoading
                  ? () => _register(bloc, context)
                  : null, // El botón estará deshabilitado si no hay datos,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: isLoading ? Colors.grey : Colors.deepPurple,
                ),
                child: Text(
                  isLoading ? 'Loading...' : 'Sign in',
                  style: TextStyle(color: Colors.white),
                ),
              ));
        });
  }

  _register(LoginBloc bloc, BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    Map info = await userProvider.newUser(bloc.email, bloc.password);

    setState(() {
      isLoading = false;
    });

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'sms');
    } else {
      showAlert(context, info["message"]);
    }
  }

  _onBack(BuildContext context, LoginBloc bloc) {
    Navigator.pushReplacementNamed(context, 'login');
    print("onBack");
  }

  _viewPassword() {
    setState(() {
      viewPassword = !viewPassword;
    });
  }
}
