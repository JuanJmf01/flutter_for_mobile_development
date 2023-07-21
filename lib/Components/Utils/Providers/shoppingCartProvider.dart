import 'package:etfi_point/Components/Data/EntitiModels/shoppingCartTb.dart';
import 'package:etfi_point/Components/Data/Entities/shoppingCartDb.dart';
import 'package:flutter/foundation.dart';

class ShoppingCartProvider extends ChangeNotifier {
  List<ShoppingCartProductTb> _shoppingCartProducts = [];

  List<ShoppingCartProductTb> get shoppingCartProducts => _shoppingCartProducts;

  Future<void> shoppingCartByUser(int idUsuario) async {
    print('ShopingCardProvider');
    _shoppingCartProducts =
        await ShoppingCartDb.shoppingCardByUsuario(idUsuario);
    notifyListeners();
  }

  void incrementarCantidadProductCar(int index) {
    _shoppingCartProducts[index] = _shoppingCartProducts[index]
        .copyWith(cantidad: shoppingCartProducts[index].cantidad + 1);
    notifyListeners();
  }


  void disminuirCantidadProductCar(int index) {
    _shoppingCartProducts[index] = _shoppingCartProducts[index]
        .copyWith(cantidad: shoppingCartProducts[index].cantidad - 1);
    notifyListeners();
  }
}
