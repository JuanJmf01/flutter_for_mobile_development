import 'package:photo_manager/photo_manager.dart';

class PickerImage {

 static Future<List<AssetPathEntity>> fetchAlbums() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    print("albunes: $albums");
    return albums;
  }
  static Future<List<AssetEntity>> fetchImages() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    final images = await albums[0].getAssetListPaged(page: 0, size: 1000);
    return images;
  }
}
