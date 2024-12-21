import 'dart:convert';

import 'package:dissau_automatic/src/preferencias_usuarios/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UserProvider {
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> registerUser(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'name': "user Name",
      "role": "USER_ROLE"
    };

    final resp = await http.post(
      Uri.parse(
          'https://jumb2bot-backend.onrender.com/user/register'), // Convertir a Uri
      body: json.encode(authData),
      headers: {
        'Content-Type':
            'application/json', // Asegúrate de establecer el tipo de contenido
      },
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    final user = decodedResp['user'];
    if (decodedResp.containsKey('token')) {
      _prefs.token = decodedResp['token'];
      _prefs.saveUser(user);
      return {'ok': true, 'token': decodedResp['token'], 'user': user};
    } else {
      return {'ok': false, 'message': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
    };

    final resp = await http.post(
      Uri.parse(
          'https://jumb2bot-backend.onrender.com/user/login'), // Convertir a Uri
      body: json.encode(authData),
      headers: {
        'Content-Type':
            'application/json', // Asegúrate de establecer el tipo de contenido
      },
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    final user = decodedResp['user'];
    if (decodedResp.containsKey('token')) {
      _prefs.token = decodedResp['token'];
      print("${user}");
      await _prefs.saveUser(user);
      return {'ok': true, 'token': decodedResp['token'], 'user': user};
    } else {
      final errorMessage =
          decodedResp['message'] ?? 'An unknown error occurred';
      return {'ok': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> changePassword(
     String password, userId) async {
    final authData = {
      'password': password,
    };

    final resp = await http.put(
      Uri.parse(
          'https://jumb2bot-backend.onrender.com/user/change-passwors/${userId}'), // Convertir a Uri
      body: json.encode(authData),
      headers: {
        'Content-Type':
            'application/json', // Asegúrate de establecer el tipo de contenido
      },
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    
    if (resp.statusCode == 200) {
   
      return {'ok': true, 'message': decodedResp['message']};
    } else {
      final errorMessage =
          decodedResp['message'] ?? 'An unknown error occurred';
      return {'ok': false, 'message': errorMessage};
    }
  }

  Future<Map<String, dynamic>> cancelUserSubscription(int userId) async {
    final url = 'https://jumb2bot-backend.onrender.com/subscription/cancel';

    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode({'userId': userId}),
        headers: {'Content-Type': 'application/json'},
      );

      final decodedResp = json.decode(response.body);
      print("_____ response desde el provider : $decodedResp['']");

      if (response.statusCode == 200) {
        return {
          'ok': true,
          'message': decodedResp['message'],
          'subscription': decodedResp['subscription']
        };
      } else {
        return {
          'ok': false,
          'message': decodedResp['error'] ?? 'An error occurred'
        };
      }
    } catch (e) {
      return {
        'ok': false,
        'message': 'Failed to connect to the server. Please try again.'
      };
    }
  }
}

// https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]

//https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]