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



