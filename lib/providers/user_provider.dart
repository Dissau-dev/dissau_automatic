import 'dart:convert';

import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final String _firebaseToken = 'AIzaSyCiUKWya_5JHhSWF75aEDz6XfsgzYFp5To';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> newUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'), // Convertir a Uri
      body: json.encode(authData),
      headers: {
        'Content-Type':
            'application/json', // Asegúrate de establecer el tipo de contenido
      },
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'message': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken'), // Convertir a Uri
      body: json.encode(authData),
      headers: {
        'Content-Type':
            'application/json', // Asegúrate de establecer el tipo de contenido
      },
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': false, 'message': decodedResp['error']['message']};
    }
  }
}

// https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]

//https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]