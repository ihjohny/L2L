import 'package:flutter/foundation.dart';
import 'package:dotenv/dotenv.dart' show env, load;

class EnvConfig {
  static late String apiBaseUrl;
  static late String apiVersion;
  static late bool enableLogging;
  static late int connectTimeout;
  static late int receiveTimeout;

  static Future<void> load() async {
    // In production, these would come from environment variables
    apiBaseUrl = kDebugMode
        ? 'http://localhost:3000'
        : 'https://api.l2l.com';
    apiVersion = 'v1';
    enableLogging = kDebugMode;
    connectTimeout = 30000; // 30 seconds
    receiveTimeout = 30000; // 30 seconds;
  }

  static String get apiPath => '$apiBaseUrl/api/$apiVersion';
}
