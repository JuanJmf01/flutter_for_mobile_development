import 'package:dio/dio.dart';
import 'package:etfi_point/Components/Data/EntitiModels/categoriaTb.dart';
import 'package:etfi_point/Components/Data/Entities/productosCategoriasDb.dart';
import 'package:etfi_point/Components/Data/Routes/rutas.dart';

class CategoriaDb {

  /// The function `getCategoriasSeleccionadas` retrieves a list of selected categories for a specific
  /// product.
  ///
  /// Args:
  ///   idProducto (int): The id of the specific product for which we want to retrieve the selected
  /// categories.
  ///
  /// Returns:
  ///   a Future object that resolves to a List of CategoriaTb objects.
  static Future<List<CategoriaTb>> getCategoriasSeleccionadas(
      int idProducto) async {
    try {
      //Obtenemos una lista de idCategorias que pertenezcan unicamnete a idProducto
      final idCategoriasDeProducto =
          await ProductosCategoriasDb.getIdCategoriasPorIdProducto(idProducto);
      final categoriasSeleccionadas = <CategoriaTb>[];
   
      // Recorremos 'idCategoriasDeProducto' y en cada ciclo llamamos al metodo 'obtenerCategoriasPorId'
      // 'obtenerCategoriasPorId' nos retorna una categoria (nombre de la categoria) y lo guardamos en la lista 'categoriasSeleccionadas'
      for (int idCategoria in idCategoriasDeProducto) {
        final categoria = await getCategoria(idCategoria);

        categoriasSeleccionadas.add(categoria);
      }

      return categoriasSeleccionadas;
    } catch (error) {
      print('Error al obtener las categorías seleccionadas: $error');
      return [];
    }
  }


 /// The function `getCategorias` is a static method that makes an HTTP GET request to retrieve a list
 /// of categories and returns a Future containing a list of `CategoriaTb` objects.
 /// 
 /// Returns:
 ///   a Future object that resolves to a List of CategoriaTb objects.
  static Future<List<CategoriaTb>> getCategorias() async {
    try {
      Dio dio = Dio();

      Response response = await dio.get(MisRutas.rutaCategorias);
      print('llega a getCate');
      if (response.statusCode == 200) {
        print('llega al if getCate');

        List<CategoriaTb> categorias = List<CategoriaTb>.from(
          response.data
              .map((categoriaData) => CategoriaTb.fromJson(categoriaData)),
        );
        return categorias;
      } else {
        // Si hay un error en la respuesta
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      // Si ocurre un error durante la solicitud
      print('Error: $error');
      return [];
    }
  }

 /// The function `getCategoria` is a static method that retrieves a category from an API using the Dio
 /// library in Dart.
 /// 
 /// Args:
 ///   idCategoria (int): The parameter "idCategoria" is an integer that represents the ID of a
 /// category.
 /// 
 /// Returns:
 ///   a Future object of type CategoriaTb.
  static Future<CategoriaTb> getCategoria(int idCategoria) async {
    try {
      Dio dio = Dio();
      Response response =
          await dio.get('${MisRutas.rutaCategorias}/$idCategoria');

      if (response.statusCode == 200) {
        return CategoriaTb.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch category');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
