import 'package:dissau_automatic/src/bloc/login_bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  static Provider? _instance; // Cambiado a nullable

  factory Provider({Key? key, required Widget child}) {
    _instance ??= Provider._internal(
      child: child,
      key: key,
    );
    return _instance!;
  }

  Provider._internal({Key? key, required Widget child})
      : super(key: key, child: child);

  final loginBloc = LoginBloc();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        .loginBloc;
  }
}
