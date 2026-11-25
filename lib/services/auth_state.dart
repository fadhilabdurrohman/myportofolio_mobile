import 'package:flutter/foundation.dart';

import 'api_client.dart';

class AuthState extends ChangeNotifier {
  AuthState(this._api, {String? initialToken}) : _token = initialToken;

  final ApiClient _api;
  String? _token;

  String? get token => _token;
  bool get isLoggedIn => _token != null;

  Future<void> login(String username, String password) async {
    _token = await _api.obtainToken(username.trim(), password);
    notifyListeners();
  }

  void clearIfCurrent(String token) {
    if (_token != token) return;
    _token = null;
    notifyListeners();
  }

  Future<void> logout() async {
    final current = _token;
    if (current == null) return;

    try {
      await _api.logout(token: current);
    } on ApiException catch (error) {
      if (error.statusCode != 401) rethrow;
    } finally {
      clearIfCurrent(current);
    }
  }
}