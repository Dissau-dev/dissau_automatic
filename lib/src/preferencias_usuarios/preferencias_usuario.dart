import 'dart:convert';

import 'package:dissau_automatic/providers/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/subscription_model.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences? _prefs;

  Future<void> ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Claves para las preferencias
  final String _keyIsConnected = 'isConnected';
  final String _keyChatIdUser = 'chatIdUser';
  final String _keyBotToken = 'botToken';
  final String _keyChatName = 'chatName';
  final String _keyToken = "token";
  static const String _subscriptionKey = 'subscription';

  // Estado de conexión
  bool get isConnected => _prefs?.getBool(_keyIsConnected) ?? false;

  set isConnected(bool value) {
    _prefs?.setBool(_keyIsConnected, value);
  }

  Future<void> setIsConnected(bool value) async {
    await _prefs?.setBool('isConnected', value);
  }

  // Método para reiniciar el estado de conexión a falso
  void resetIsConnected() {
    isConnected = false;
  }

  // Obtención y configuración del chat ID
  String get chatIdUser => _prefs?.getString(_keyChatIdUser) ?? '';

  set chatIdUser(String value) {
    _prefs?.setString(_keyChatIdUser, value);
  }

  // Obtención y configuración del token del bot
  String get botToken => _prefs?.getString(_keyBotToken) ?? '';

  set botToken(String value) {
    _prefs?.setString(_keyBotToken, value);
  }

  // Obtención y configuración del nombre del chat
  String get chatName => _prefs?.getString(_keyChatName) ?? '';

  set chatName(String value) {
    _prefs?.setString(_keyChatName, value);
  }

  // Obtención y configuración del nombre del chat
  String get token => _prefs?.getString(_keyToken) ?? '';

  set token(String value) {
    _prefs?.setString(_keyToken, value);
  }

  // Guardar usuario como JSON
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs!.setString('user', json.encode(user));
  }

  // Obtener usuario (devuelve UsuarioModel)
  UserModel? get user {
    final userString = _prefs?.getString('user');
    if (userString != null) {
      final Map<String, dynamic> userJson = json.decode(userString);
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  Future<void> removeUser() async {
    final prefs = await _prefs;
    await prefs?.remove('user');
  }

  //--------------
  // Guardar suscripción
  // Guardar usuario como JSON
  Future<void> saveSubscription(Map<String, dynamic> subscription) async {
    await _prefs!.setString('subscription', json.encode(subscription));
  }

  // Obtener usuario (devuelve UsuarioModel)
  SubscriptionModel? get subscription {
    final subscriptionString = _prefs?.getString('subscription');
    if (subscriptionString != null) {
      final Map<String, dynamic> subscriptionJson =
          json.decode(subscriptionString);
      return SubscriptionModel.fromJson(subscriptionJson);
    }
    return null;
  }

  //  Guardar una nueva suscripción
  Future<void> updateSubscriptionInStorage(
      SubscriptionModel subscription) async {
    print("_______execute update ${subscription}");

    final subscriptionJson = json.encode(subscription.toJson());
    await _prefs?.setString('subscription', subscriptionJson);
  }

// Eliminar la suscripción actual
  Future<void> removeSubscriptionFromStorage() async {
    print("_______execute remoive ${subscription}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('subscription');
  }
}
