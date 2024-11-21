import 'package:shared_preferences/shared_preferences.dart';

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
    _prefs?.setString(_keyChatName, value);
  }
}
