import 'package:photo_manager/photo_manager.dart';

class ImageContent {
  ImageContent({
    required this.images,
    required this.albums,
  });

  final List<AssetEntity> images;
  final List<AssetPathEntity> albums;
}
