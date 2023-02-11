import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenSource {
  static const kAccessTokenKey = "access_token";
  Future<bool> saveToken(String token);
  String getToken();
}

class TokenSourceImpl implements TokenSource {
  final SharedPreferences _preference;

  TokenSourceImpl(this._preference);
  @override
  String getToken() {
    return _preference.getString(TokenSource.kAccessTokenKey) ?? "NO_TOKEN";
  }

  @override
  Future<bool> saveToken(String token) {
    return _preference.setString(TokenSource.kAccessTokenKey, token);
  }
}
