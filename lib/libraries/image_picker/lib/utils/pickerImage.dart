import 'package:etfi_point/libraries/image_picker/lib/data/models/imageContent.dart';
import 'package:photo_manager/photo_manager.dart';  

class PickerImage {
  static Future<List<AssetPathEntity>> fetchAlbums() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);

    return albums;
  }

  static Future<ImageContent> fetchImages({String? albumName}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    List<AssetPathEntity> albums = await fetchAlbums();
    if (albumName != null) {
      AssetPathEntity selectedAlbum = albums[0];
      for (var album in albums) {
        if (albumName == album.name) {
          selectedAlbum = album;
          break;
        }
      }
      List<AssetEntity> images =
          await selectedAlbum.getAssetListPaged(page: 0, size: 1000);
      return ImageContent(images: images, albums: albums);
    } else {
      List<AssetEntity> images =
          await albums[0].getAssetListPaged(page: 0, size: 1000);
      return ImageContent(images: images, albums: albums);
    }
  }
}
