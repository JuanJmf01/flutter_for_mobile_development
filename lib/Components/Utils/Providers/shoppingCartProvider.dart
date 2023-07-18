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
}
