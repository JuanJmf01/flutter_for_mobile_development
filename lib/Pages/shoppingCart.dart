import 'package:etfi_point/Components/Utils/productDetail.dart';
import 'package:etfi_point/main.dart';
import 'package:flutter/material.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        backgroundColor: Colors.grey[200],        
      ),
      body: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Menu(index: 1,)),
          );
      },
      child: Text('Prueba'))
   );
  }
}




















// // ----------------------------------------------------------------------------------------------------------//




class FloatButton extends StatelessWidget {
  const FloatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.more_horiz_rounded),
        onPressed: () {
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
            items: [
              PopupMenuItem(
                value: 1,
                child:TextButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductDetail(id: 1))
                    )
                  },
                  child: const Text('Opcion 1')
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Opción 2'),
              ),
              PopupMenuItem(
                value: 3, 
                child: Text('Opción 3'),
              ),
            ],
            elevation: 8.0,
          );
        },
      ),
    );
  }
}

