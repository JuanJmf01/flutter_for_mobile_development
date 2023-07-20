import 'package:etfi_point/Components/Data/EntitiModels/shoppingCartTb.dart';
import 'package:etfi_point/Components/Data/Entities/shoppingCartDb.dart';
import 'package:etfi_point/Components/Utils/Providers/UsuarioProvider.dart';
import 'package:etfi_point/Components/Utils/Providers/shoppingCartProvider.dart';
import 'package:etfi_point/Components/Utils/confirmationDialog.dart';
import 'package:etfi_point/Components/Utils/showImage.dart';
import 'package:etfi_point/Pages/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  Widget build(BuildContext context) {
    int? idUsuario = Provider.of<UsuarioProvider>(context).idUsuario;

    return Scaffold(
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
                        ),
                      ],
                    ),
                  ),
                  StaticBottom()
                ],
              )
            : Text('Debes iniciar sesion'));
  }
}

class HorizontalProduct extends StatefulWidget {
  const HorizontalProduct({super.key, required this.idUsuario});

  final int idUsuario;

  @override
  State<HorizontalProduct> createState() => _HorizontalProductState();
}

class _HorizontalProductState extends State<HorizontalProduct> {
  List<ShoppingCartProductTb> shoppingCartProducts = [];

  bool isSelected = false;
  bool isLoading = true;

  Future<void> shoppingCardProducts(int idUsuario) async {
    context.read<ShoppingCartProvider>().shoppingCartByUser(idUsuario);

    setState(() {
      isLoading = false;
    });
  }

  void aumentar(int index) {
    setState(() {
      shoppingCartProducts[index] = shoppingCartProducts[index]
          .copyWith(cantidad: shoppingCartProducts[index].cantidad + 1);
    });
  }

  void disminuir(int index) {
    int cantidad = shoppingCartProducts[index].cantidad;
    if (cantidad > 1) {
      setState(() {
        shoppingCartProducts[index] = shoppingCartProducts[index]
            .copyWith(cantidad: shoppingCartProducts[index].cantidad - 1);
      });
    } else if (cantidad == 1) {
      int idProducto = shoppingCartProducts[index].idProducto;
      deleteShoppingCartProduct(idProducto, index);
    }
  }

  void deleteShoppingCartProduct(int idProducto, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DeletedDialog(
              onPress: () {
                ShoppingCartDb.deleteShoppingCardByProduct(idProducto);
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

  @override
  void initState() {
    super.initState();
    shoppingCardProducts(widget.idUsuario);
  }

  @override
  Widget build(BuildContext context) {
    shoppingCartProducts =
        Provider.of<ShoppingCartProvider>(context).shoppingCartProducts;
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CircularSelector(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              isSelected: isSelected,
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
                                    Padding(
                                      padding: const EdgeInsets.only(top: 40.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            shoppingCartProducts[index]
                                                .precio
                                                .toString(),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const Spacer(),
                                          createButtonPress(
                                            () {
                                              disminuir(index);
                                            },
                                            Icons.remove,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6.0),
                                            child: Text(
                                              shoppingCartProducts[index]
                                                  .cantidad
                                                  .toString(),
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                          createButtonPress(
                                            () {
                                              aumentar(index);
                                            },
                                            Icons.add,
                                          ),
                                        ],
                                      ),
                                    ),
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

class CircularSelector extends StatefulWidget {
  const CircularSelector(
      {super.key, required this.isSelected, this.onChanged, this.padding});

  final bool isSelected;
  final ValueChanged<bool>? onChanged;
  final EdgeInsets? padding;

  @override
  State<CircularSelector> createState() => _CircularSelectorState();
}

class _CircularSelectorState extends State<CircularSelector> {
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(isSelected);
        }
      },
      child: Padding(
        padding: widget.padding ?? EdgeInsets.zero,
        child: Icon(
          isSelected ? Icons.check_circle : Icons.panorama_fish_eye,
          color: isSelected ? Colors.blue : Colors.grey,
        ),
      ),
    );
  }
}

class StaticBottom extends StatelessWidget {
  const StaticBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57.0,
      color: Colors.white60,
      child: Row(
        children: [Text('funciona')],
      ),
    );
  }
}

// // ----------------------------------------------------------------------------------------------------------//
