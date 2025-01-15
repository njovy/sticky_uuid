import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_uuid/src/utils/generator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _key = 'sticky_uuid';

/// DeviceId that holds a secure storage for the device id.
class StickyUuid {
  static final _instance = StickyUuid._internal();

  StickyUuid._internal();

  /// create a singleton instance of DeviceId with a factory pattern
  factory StickyUuid() => _instance;

  Future<String>? _deviceId;

  /// get a device id from a secure storage
  /// if there is no device id, create a new one and save it to the secure storage
  Future<String> get deviceId async {
    if (_deviceId == null) {
      _deviceId = _getOrPersistDeviceId();
    }
    return _deviceId!;
  }

  Future<String> _getOrPersistDeviceId() async {
    if(Platform.isAndroid){
      final pref = await SharedPreferences.getInstance();
      final deviceId = pref.getString(_key);
      if (deviceId?.isNotEmpty ?? false) {
        return deviceId!;
      }
      try {
        final androidId = await AndroidId().getId();
        if (androidId?.isNotEmpty ?? false) {
          await pref.setString(_key, androidId!);
          return androidId;
        }
      }catch(_){

      }
      final String newId = toHex(generate());
      await pref.setString(_key, newId);
      return newId;
    }
    /// read a device id from a secure storage
    final storage = FlutterSecureStorage();

    final String? key = await storage.read(key: _key);
    if (key?.isNotEmpty ?? false) {
      return key!;
    }

    /// if there is no device id, create a new one and save it to the secure storage
    final String newId = toHex(generate());
    await storage.write(key: _key, value: newId);
    return newId;
  }
}
