import 'dart:io';

import 'package:etfi_point/Components/Data/EntitiModels/pruebaTb.dart';
import 'package:etfi_point/Components/Data/Entities/pruebasDb.dart';
import 'package:etfi_point/Pages/allProducts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

class Pruebas extends StatefulWidget {
  const Pruebas({Key? key});

  @override
  State<Pruebas> createState() => _PruebasState();
}

class _PruebasState extends State<Pruebas> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  String? _imagePath;

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = image?.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<PruebaTb>>(
        future: PruebasDb.pruebas(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<PruebaTb> pruebas = snapshot.data!;
            return Column(
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    hintText: 'Agrega un nombre',
                  ),
                ),
                TextField(
                  controller: _edadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Agrega una edad',
                  ),
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Icon(Icons.image),
                ),
                if (_imagePath != null && _imagePath!.isNotEmpty)
                  Container(
                    width: 100, // Tamaño deseado de la vista previa
                    height: 100,
                    margin:
                        EdgeInsets.symmetric(vertical: 10), // Margen opcional
                    child: Image.file(File(_imagePath!)),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Verificar si se ha seleccionado una imagen
                      if (_imagePath != null && _imagePath!.isNotEmpty) {
                        final nombre = _nombreController.text;
                        final age = int.tryParse(_edadController.text) ?? 0;
                        final prueba = PruebaTb(
                            nombre: nombre, age: age, imagePath: _imagePath!);
                        await PruebasDb.insert(prueba);
                        setState(() {
                          _nombreController.clear();
                          _edadController.clear();
                          _imagePath =
                              null; // Restablecer la ruta de la imagen seleccionada
                        });
                      } else {
                        // Mostrar un mensaje de error o realizar alguna acción adicional si no se ha seleccionado una imagen
                      }
                    },
                    child: const Text('Agregar'),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: pruebas.length,
                    itemBuilder: (context, index) {
                      final PruebaTb prueba = pruebas[index];
                      return Row(
                        children: [
                          Text(prueba.nombre),
                          Text(prueba.age.toString()),
                          if (prueba.imagePath != null) // Verificar si hay una ruta de imagen
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Image.file(File(prueba.imagePath!)),
                            ),  
                          IconButton(
                            onPressed: () {
                              setState(() {
                                PruebasDb.delete(prueba);
                              });
                            },
                            icon:
                                Icon(Icons.delete, color: Colors.red.shade700),
                          ),
                          // IconButton(
                          //   onPressed: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => PruebaUpdate(data: prueba),
                          //       ),
                          //     );
                          //   },
                          //   icon: Icon(Icons.browser_updated_rounded, color: Colors.blueAccent),
                          // ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error al cargar los datos');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


// class PruebaUpdate extends StatefulWidget {
//   final PruebaTb data;
//   PruebaUpdate({super.key, required this.data});

//   @override
//   State<PruebaUpdate> createState() => _PruebaUpdateState();
// }

// class _PruebaUpdateState extends State<PruebaUpdate> {
//   PruebaTb _prueba = PruebaTb(nombre: '', age: );

//   final myController = TextEditingController();

//   @override
//   void dispose() {
//     myController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _prueba = widget.data;
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController myController =
//         TextEditingController(text: _prueba.nombre);

//     return Scaffold(
//         appBar: AppBar(),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Nombre',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16.0,
//                 )),
//             TextField(
//               controller: myController,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   _prueba.nombre = myController.text;
//                   setState(() {
//                     PruebasDb.update(_prueba);
//                   });
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => Pruebas()));
//                 },
//                 child: const Text('Actualizar'),
//               ),
//             ),
//           ],
//         ));
//   }
// }
