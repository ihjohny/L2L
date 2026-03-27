import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  factory SecureStorage() {
    return _instance;
  }

  SecureStorage._internal();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Save both tokens
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Clear access token
  Future<void> clearAccessToken() async {
    await _storage.delete(key: _accessTokenKey);
  }

  /// Clear refresh token
  Future<void> clearRefreshToken() async {
    await _storage.delete(key: _refreshTokenKey);
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
  }

  /// Initialize storage (can be used to migrate from old storage)
  Future<void> initialize() async {
    // Preload any values if needed
  }
}
