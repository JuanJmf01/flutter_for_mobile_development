import 'dart:typed_data';

import 'package:multi_image_picker/multi_image_picker.dart';

Future<Uint8List> assetToUint8List(Asset image) async {
  final ByteData byteData = await image.getByteData();
  final Uint8List bytes = byteData.buffer.asUint8List();

  return bytes;
}
