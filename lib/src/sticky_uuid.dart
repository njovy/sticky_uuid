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
    /// read a device id from a secure storage


    final storage = FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

    final String? key = await storage.read(key: _key);
    if(key?.isNotEmpty ?? false){
      return key!;
    }

    /// if there is no device id, create a new one and save it to the secure storage
    final String newId = toHex(generate());
    await storage.write(key: _key, value: newId);
    return newId;

  }
}
