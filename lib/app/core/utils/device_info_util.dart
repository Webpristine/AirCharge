import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoUtil {
  static final DeviceInfoUtil _instance = DeviceInfoUtil._internal();

  factory DeviceInfoUtil() {
    _init();
    return _instance;
  }
  static String deviceId = '';
  DeviceInfoUtil._internal();
  static String? deviceInfo;

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<String> getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        deviceId =
            androidInfo.id; // Use Android ID for unique device identifier
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceId =
            iosInfo.identifierForVendor!; // Use identifierForVendor for iOS
      }
    } catch (e) {
      debugPrint('>>>> [DEBUG] Error getting device id: $e');
    }
    return deviceId;
  }

  static void _init() async {
    deviceInfo = await getDeviceId();
  }
}
