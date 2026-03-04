import 'package:flutter/services.dart';

class VirtualAppChannel {
  static const MethodChannel _channel = MethodChannel('com.vphone/virtual_app');

  /// Initialize VirtualApp engine
  static Future<bool> initialize() async {
    try {
      final result = await _channel.invokeMethod<bool>('initialize');
      return result ?? false;
    } on PlatformException catch (e) {
      print('VirtualApp init error: ${e.message}');
      return false;
    }
  }

  /// Install APK into virtual space
  static Future<bool> installApp({
    required String apkPath,
    required int userId,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('installApp', {
        'apkPath': apkPath,
        'userId': userId,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print('Install error: ${e.message}');
      return false;
    }
  }

  /// Launch an installed virtual app
  static Future<bool> launchApp({
    required String packageName,
    required int userId,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('launchApp', {
        'packageName': packageName,
        'userId': userId,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print('Launch error: ${e.message}');
      return false;
    }
  }

  /// Stop a running virtual app
  static Future<void> stopApp({
    required String packageName,
    required int userId,
  }) async {
    try {
      await _channel.invokeMethod('stopApp', {
        'packageName': packageName,
        'userId': userId,
      });
    } on PlatformException catch (e) {
      print('Stop error: ${e.message}');
    }
  }

  /// Uninstall app from virtual space
  static Future<bool> uninstallApp({
    required String packageName,
    required int userId,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('uninstallApp', {
        'packageName': packageName,
        'userId': userId,
      });
      return result ?? false;
    } on PlatformException catch (e) {
      print('Uninstall error: ${e.message}');
      return false;
    }
  }

  /// Get list of installed virtual apps
  static Future<List<Map<String, dynamic>>> getInstalledApps(int userId) async {
    try {
      final result = await _channel.invokeMethod<List>('getInstalledApps', {
        'userId': userId,
      });
      return result?.cast<Map<String, dynamic>>() ?? [];
    } on PlatformException catch (e) {
      print('Get apps error: ${e.message}');
      return [];
    }
  }

  /// Get real-time resource stats
  static Future<Map<String, dynamic>> getStats() async {
    try {
      final result = await _channel.invokeMethod<Map>('getStats');
      return result?.cast<String, dynamic>() ?? {};
    } on PlatformException catch (e) {
      return {};
    }
  }
}
