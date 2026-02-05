import 'dart:io';
import 'package:flutter/foundation.dart';

class EnvConfig {
  static late String apiBaseUrl;
  static late String apiVersion;
  static late bool enableLogging;
  static late int connectTimeout;
  static late int receiveTimeout;

  static Future<void> load() async {
    // In production, these would come from environment variables
    // Android emulator uses 10.0.2.2 to access host machine's localhost
    final host = kDebugMode && Platform.isAndroid ? '10.0.2.2' : 'localhost';
    apiBaseUrl = kDebugMode
        ? 'http://$host:3000'
        : 'https://api.l2l.com';
    apiVersion = 'v1';
    enableLogging = kDebugMode;
    connectTimeout = 30000; // 30 seconds
    receiveTimeout = 30000; // 30 seconds;
  }

  static String get apiPath => '$apiBaseUrl/api/$apiVersion';
}
