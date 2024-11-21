import 'package:flutter/material.dart';
import 'package:dissau_automatic/src/bloc/login_bloc.dart';

Widget chatFormField(
    LoginBloc bloc,
    dynamic Function(String) onChanged,
    String initialValue,
    String hintText,
    String labelText,
    Stream<String>? stream,
    IconData icon) {
  return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: TextFormField(
            style: TextStyle(
                color: Colors.white, fontFamily: 'Poppins', fontSize: 14),
            keyboardType: TextInputType.name,
            initialValue: initialValue,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              prefixIcon: Padding(
                // Cambiado a prefixIcon
                padding: const EdgeInsets.only(right: 8.0), // Espaciado
                child: Icon(icon, color: Colors.white),
              ),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              labelText: labelText,
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    BorderSide(color: Color(0xFF1D88E6)), // Color del contorno
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    15), // Asegúrate de mantener el borderRadius aquí
                borderSide:
                    BorderSide(color: Color(0xFF1D88E6)), // Color al enfocar
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    15), // Asegúrate de mantener el borderRadius aquí
                borderSide:
                    BorderSide(color: Color(0xFF1D88E6)), // Color habilitado
              ),
            ),
            onChanged: onChanged,
          ),
        );
      });
}
