import 'package:etfi_point/Components/Data/EntitiModels/shoppingCartTb.dart';
import 'package:etfi_point/Components/Data/Entities/shoppingCartDb.dart';
import 'package:flutter/foundation.dart';

class ShoppingCartProvider extends ChangeNotifier {
  List<ShoppingCartProductTb> _shoppingCartProducts = [];
  List<ShoppingCartProductTb> _shoppingCartProductsAux = [];
  double _total = 0.0;
  bool _isFirstTime = true;

  List<ShoppingCartProductTb> get shoppingCartProducts => _shoppingCartProducts;
  List<ShoppingCartProductTb> get shoppingCartProductsAux =>
      _shoppingCartProductsAux;
  double get total => _total;
  bool get isFirstTime => _isFirstTime;

  Future<void> shoppingCartByUser(int idUsuario) async {
    print('ShopingCardProvider: $_isFirstTime');

    if (_isFirstTime) {
      _shoppingCartProducts =
          await ShoppingCartDb.shoppingCardByUsuario(idUsuario);
      _isFirstTime = false;

      _shoppingCartProductsAux = [..._shoppingCartProducts];
      notifyListeners();
    }
  }

  void initializeValues() async {
    _isFirstTime = true;

    //Checamos si no tenemos pendiente una actualizacion
    updateCantidadProductCartProvider();

    //Finalemnte actualizamos globalmente _isFirstTime
    notifyListeners();
  }

  void incrementarCantidadProductCar(int index) {
    _shoppingCartProducts[index] = _shoppingCartProducts[index]
        .copyWith(cantidad: shoppingCartProducts[index].cantidad + 1);
    calcularTotal(index, false, false);

    notifyListeners();
  }

  void disminuirCantidadProductCar(int index) {
    _shoppingCartProducts[index] = _shoppingCartProducts[index]
        .copyWith(cantidad: shoppingCartProducts[index].cantidad - 1);
    calcularTotal(index, true, false);
    notifyListeners();
  }

  void calcularTotal(int index, bool disminuir, bool inicial) {
    double totalAux = 0.0;

    if (inicial) {
      _total = 0;
      updateCantidadProductCartProvider();
    }

    if (_total == 0.0) {
      for (var productCart in shoppingCartProducts) {
        totalAux += productCart.precio * productCart.cantidad;
      }
    } else if (_total > 0.0) {
      print('total > 0');
      totalAux = shoppingCartProducts[index].precio;
    }

    if (!disminuir) {
      _total += totalAux;
    } else {
      _total -= totalAux;
    }
    notifyListeners();
  }

  void updateCantidadProductCartProvider() async {
    if (!listEquals(_shoppingCartProducts, _shoppingCartProductsAux)) {
      print('Actualizamos BD');

      for (int i = 0; i < _shoppingCartProducts.length; i++) {
        print('INGRESA');
        final producto = _shoppingCartProducts[i];
        if (producto.cantidad != _shoppingCartProductsAux[i].cantidad) {
          await ShoppingCartDb.updateCantidadProductCart(
              producto.idCarrito, producto.cantidad);
        }
      }
      _shoppingCartProductsAux.clear();
      _shoppingCartProductsAux = [..._shoppingCartProducts];
      notifyListeners();
    }
  }
}
