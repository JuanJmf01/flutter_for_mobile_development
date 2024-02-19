import 'package:photo_manager/photo_manager.dart';

class PickerImage {
  static Future<List<String>> fetchAlbums() async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    List<String> listaNombres = albums.map((album) => album.name).toList();
    return listaNombres;
  }

  static Future<List<AssetEntity>> fetchImages({String? albumName}) async {
    final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
    if (albumName != null) {
      AssetPathEntity selectedAlbum = albums[0];
      for (var album in albums) {
        if (albumName == album.name) {
          selectedAlbum = album;
          break;
        }
      }
      return await selectedAlbum.getAssetListPaged(page: 0, size: 1000);
    } else {
      return await albums[0].getAssetListPaged(page: 0, size: 1000);
    }
  }
}
