// generate a list of random bytes with the given length
import 'dart:math';
import 'dart:typed_data';

Uint8List generate({int length = 20}) {
  final random = Random.secure();
  return Uint8List.fromList(
      List<int>.generate(length, (i) => random.nextInt(256)));
}

/// Uint8List to hex
String toHex(Uint8List bytes) {
  return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
