import 'package:etfi_point/Components/Data/EntitiModels/shoppingCartTb.dart';
import 'package:etfi_point/Components/Data/Entities/shoppingCartDb.dart';
import 'package:etfi_point/Components/Utils/CircularSelector.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/shoppingCartProvider.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  ShoppingCart({super.key, this.idUsuario});

  final int? idUsuario;

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<ShoppingCartProductTb> shoppingCartProducts = [];

  bool isLoading = true;

  Future<void> shoppingCardProducts(int idUsuario) async {
    await context.read<ShoppingCartProvider>().shoppingCartByUser(idUsuario);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    int? idUsuario = widget.idUsuario;
    if (idUsuario != null) {
      shoppingCardProducts(idUsuario);
    }
  }

  @override
  Widget build(BuildContext context) {
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;
    shoppingCartProducts =
        context.watch<ShoppingCartProvider>().shoppingCartProducts;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              backgroundColor: Colors.grey[200],
            ),
            body: idUsuario != null
                ? Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            HorizontalProduct(
                              idUsuario: idUsuario,
                              shoppingCartProducts: shoppingCartProducts,
                            ),
                          ],
                        ),
                      ),
                      StaticBottom(
                        shoppingCartProducts: shoppingCartProducts,
                      ),
                    ],
                  )
                : Text('Debes iniciar sesion'),
          );
  }
}

class HorizontalProduct extends StatefulWidget {
  const HorizontalProduct(
      {super.key, required this.idUsuario, required this.shoppingCartProducts});

  final int idUsuario;
  final List<ShoppingCartProductTb> shoppingCartProducts;

  @override
  State<HorizontalProduct> createState() => _HorizontalProductState();
}

class _HorizontalProductState extends State<HorizontalProduct> {
  List<ShoppingCartProductTb> shoppingCartProducts = [];

  bool isSelected = false;
  bool isLoading = false;
  double total = 0.0;



  void aumentar(int index) {
    ShoppingCartProductTb productInCar = shoppingCartProducts[index];
    if (productInCar.cantidad < productInCar.cantidadDisponible) {
      context.read<ShoppingCartProvider>().incrementarCantidadProductCar(index);
    } else {
      print('Maxima cantidad');
    }
  }

  void disminuir(int index) {
    int cantidad = shoppingCartProducts[index].cantidad;
    if (cantidad > 1) {
      context.read<ShoppingCartProvider>().disminuirCantidadProductCar(index);
    } else if (cantidad == 1) {
      int idProductCart = shoppingCartProducts[index].idCarrito;
      deleteShoppingCartProduct(idProductCart, index);
      //calcularTotal(index, true);
    }
  }

  void deleteShoppingCartProduct(int idProductCart, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeletedDialog(
              onPress: () async {
                context
                    .read<ShoppingCartProvider>()
                    .calcularTotal(index, true, false);
                await ShoppingCartDb.deleteShoppingCart(idProductCart);
                setState(() {
                  shoppingCartProducts.removeAt(index);
                });
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              objectToDelete: 'el producto de tu carrito');
        });
  }

  void navigateToProductDetail(int idProducto) async {
    if (context.mounted) {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(id: idProducto),
          ));
    }
  }

  void calcularTotalProvider() {
    Future.delayed(Duration.zero, () {
      context.read<ShoppingCartProvider>().calcularTotal(0, false, true);
    });
  }

  @override
  void initState() {
    super.initState();
    shoppingCartProducts = widget.shoppingCartProducts;

    calcularTotalProvider();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()))
        : SliverToBoxAdapter(
            child: ListView.builder(
                /**  En caso de tener dos widgets desplazables anidados 'shrinkWrap: true'
                 *  entonces ListView.builder se acomoda y evita expandirse,*/
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), //Evitamos el desplazamiento del widget anidado
                itemCount: shoppingCartProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.all(7.0),
                    child: IntrinsicHeight(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            CircularSelector(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              isSelected: isSelected,
                              sizeIcon: 25.0,
                              onChanged: (value) {
                                setState(() {
                                  isSelected = value;
                                });
                                print(isSelected);
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                navigateToProductDetail(
                                    shoppingCartProducts[index].idProducto);
                              },
                              child: ShowImage(
                                networkImage:
                                    shoppingCartProducts[index].urlImage,
                                height: 115,
                                width: 135,
                                color: Colors.grey,
                                heightAsset: 20,
                                fit: BoxFit.fill,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shoppingCartProducts[index]
                                          .nombreProducto,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                      ),
                                    ),
                                    IncreaseAndDecrease(
                                        padding:
                                            const EdgeInsets.only(top: 40.0),
                                        myWidget: Text(
                                          shoppingCartProducts[index]
                                              .precio
                                              .toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        disminuir: () {
                                          disminuir(index);
                                        },
                                        aumentar: () {
                                          aumentar(index);
                                        },
                                        cantidad: shoppingCartProducts[index]
                                            .cantidad
                                            .toString()),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}

class IncreaseAndDecrease extends StatelessWidget {
  const IncreaseAndDecrease(
      {super.key,
      this.padding,
      required this.disminuir,
      required this.aumentar,
      required this.cantidad,
      this.myWidget});

  final EdgeInsets? padding;
  final VoidCallback disminuir;
  final VoidCallback aumentar;
  final String cantidad;
  final Widget? myWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Row(
        children: [
          myWidget ?? const SizedBox.shrink(),
          Spacer(),
          createButtonPress(
            () {
              disminuir();
            },
            Icons.remove,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              cantidad,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          createButtonPress(
            () {
              aumentar();
            },
            Icons.add,
          ),
        ],
      ),
    );
  }

  Widget createButtonPress(VoidCallback onTap, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 24,
        width: 24,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(100.0)),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}



class StaticBottom extends StatefulWidget {
  const StaticBottom({super.key, required this.shoppingCartProducts});

  final List<ShoppingCartProductTb> shoppingCartProducts;

  @override
  State<StaticBottom> createState() => _StaticBottomState();
}

class _StaticBottomState extends State<StaticBottom> {
  List<ShoppingCartProductTb> shoppingCartProducts = [];

  @override
  void initState() {
    super.initState();
    shoppingCartProducts = widget.shoppingCartProducts;
  }

  @override
  Widget build(BuildContext context) {
    double total = context.watch<ShoppingCartProvider>().total;
    return Container(
      height: 57.0,
      color: Colors.white60,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Text(
              '\$ ${total.toString()}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// // 
