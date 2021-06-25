import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_aad_oauth/model/token.dart';
import "dart:convert" as Convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static AuthStorage shared = new AuthStorage();
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final String _identifier = "Token";
  static final _insecureStorage = Map<String, String>();

  Future<void> saveTokenToCache(Token? token) async {
    var data = Token.toJsonMap(token);
    var json = Convert.jsonEncode(data);
    if (kReleaseMode | !Platform.isMacOS) {
      await _secureStorage.write(key: _identifier, value: json);
    } else {
      // use non-secure storage for macOS in development; see
      // https://github.com/mogol/flutter_secure_storage/issues/106
      _insecureStorage[_identifier] = json;
    }
  }

  Future<T?> readTokenFromCache<T extends Token>() async {
    var json;
    if (kReleaseMode | !Platform.isMacOS) {
      json = await _secureStorage.read(key: _identifier);
    } else {
      json = _insecureStorage[_identifier];
    }
    if (json == null) return null;
    try {
      var data = Convert.jsonDecode(json);
      return _getTokenFromMap<T>(data) as FutureOr<T?>;
    } catch (exception) {
      print(exception);
      return null;
    }
  }

  Token _getTokenFromMap<T extends Token>(Map<String, dynamic>? data) =>
      Token.fromJson(data);

  Future clear() async {
    _secureStorage.delete(key: _identifier);
  }
}
