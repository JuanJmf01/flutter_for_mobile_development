import 'package:etfi_point/libraries/image_picker/lib/data/models/imageContent.dart';
import 'package:etfi_point/libraries/image_picker/lib/utils/pickerImage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageContentProvider = FutureProvider.family<ImageContent, String?>(
    (ref, String? albumName) async {
  print("Se ejecuta");
  return await PickerImage.fetchImages(albumName: albumName);
});
