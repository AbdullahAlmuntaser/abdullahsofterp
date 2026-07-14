import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CsrfService {
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'csrf_token';
  static const Duration _tokenLifetime = Duration(hours: 2);

  CsrfService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<String> generateToken() async {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final token = base64UrlEncode(bytes);
    final expiresAt = DateTime.now().add(_tokenLifetime).toIso8601String();
    final payload = jsonEncode({'token': token, 'expiresAt': expiresAt});
    await _storage.write(key: _tokenKey, value: payload);
    return token;
  }

  Future<bool> validateToken(String token) async {
    final payload = await _storage.read(key: _tokenKey);
    if (payload == null) return false;
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final storedToken = data['token'] as String;
      final expiresAt = DateTime.parse(data['expiresAt'] as String);
      return storedToken == token && DateTime.now().isBefore(expiresAt);
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyRequest(String headerToken) async {
    final valid = await validateToken(headerToken);
    if (valid) {
      await generateToken();
    }
    return valid;
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
