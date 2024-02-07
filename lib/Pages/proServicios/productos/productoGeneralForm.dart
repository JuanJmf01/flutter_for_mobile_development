import 'package:etfi_point/Components/Utils/generalInputs.dart';
import 'package:etfi_point/Components/Utils/globalTextButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductoGeneralForm extends StatefulWidget {
  const ProductoGeneralForm({Key? key}) : super(key: key);

  @override
  State<ProductoGeneralForm> createState() => _ProductoGeneralFormState();
}

class _ProductoGeneralFormState extends State<ProductoGeneralForm> {
  int pageController = 1;
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController priceWithDescountController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (pageController == 1) {
              print('Flecha hacia atrás presionada');
              Navigator.of(context).pop();
            } else if (pageController > 1 && pageController <= 3) {
              setState(() {
                pageController -= 1;
              });
            }
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GlobalTextButton(
              textButton: "Siguiente",
              onPressed: () {
                setState(() {
                  pageController += 1;
                });
              },
            )
          ],
        ),
      ),
      body: pageController == 1
          ? ProductDetail(
              nameController: _nombreController,
              precioController: _priceController,
              priceWithDescountController: priceWithDescountController,
            )
          : pageController == 2
              ? SelectImages()
              : Text("Ninguna coincide"),
    );
  }
}

class ProductDetail extends StatelessWidget {
  ProductDetail({
    super.key,
    required this.nameController,
    required this.precioController,
    required this.priceWithDescountController,
  });

  final TextEditingController nameController;
  final TextEditingController precioController;
  final TextEditingController priceWithDescountController;

  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusScopeNode.unfocus();
      },
      child: Column(
        children: [
          GeneralInputs(
            controller: nameController,
            labelText: 'Nombre del producto',
          ),
          Row(
            children: [
              Expanded(
                child: GeneralInputs(
                  controller: precioController,
                  labelText: '\$  Precio',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                ),
              ),
              Expanded(
                child: GeneralInputs(
                  controller: priceWithDescountController,
                  labelText: 'Descuento',
                ),
              ),
            ],
          ),

          // Centrate en este input
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width /
                    2, // Ancho del 25% de la pantalla
                child: GeneralInputs(
                  controller: priceWithDescountController,
                  labelText: 'Precio ahora',
                  borderInput:
                      Border.all(width: 1.0, color: Colors.transparent),
                  color: Colors.grey.shade300,
                  enable: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SelectImages extends StatefulWidget {
  const SelectImages({Key? key}) : super(key: key);

  @override
  State<SelectImages> createState() => _SelectImagesState();
}

class _SelectImagesState extends State<SelectImages> {
  @override
  Widget build(BuildContext context) {
    return Text("Funciona");
  }
}
