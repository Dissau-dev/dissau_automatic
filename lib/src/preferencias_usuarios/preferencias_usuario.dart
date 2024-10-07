import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  // GET y SET del token
  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  // GET y SET del chatIdUser
  String get chatIdUser {
    return _prefs.getString('chatIdUser') ?? '';
  }

  set chatIdUser(String value) {
    _prefs.setString('chatIdUser', value);
  }

  // GET y SET del chatName
  String get chatName {
    return _prefs.getString('chatName') ?? '';
  }

  set chatName(String value) {
    _prefs.setString('chatName', value);
  }
}
