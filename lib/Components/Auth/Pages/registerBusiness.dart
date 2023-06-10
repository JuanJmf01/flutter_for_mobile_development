import 'package:flutter/material.dart';

class RegisterBusiness extends StatelessWidget {
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessDescriptionController =
      TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar Negocio',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey[200],
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 70, // Establecer una altura mayor
      ),
      backgroundColor: Colors.grey[200], // Fondo gris claro
      body: SingleChildScrollView(
        // Widget SingleChildScrollView para evitar el desplazamiento
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Cuadro blanco
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: businessNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del negocio',
                      border: InputBorder.none, // Sin borde
                      contentPadding:
                          EdgeInsets.all(13.0), // Ajustar el padding
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Cuadro blanco
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: businessDescriptionController,
                    maxLines:
                        3, // Establecer un valor mayor que 1 para permitir múltiples líneas
                    decoration: const InputDecoration(
                      labelText: 'Descripción del negocio',
                      border: InputBorder.none, // Sin borde
                      contentPadding:
                          EdgeInsets.all(16.0), // Ajustar el padding
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                        height: 0.8,
                      ), // Modificar estilo del labelText
                      alignLabelWithHint: true, // Alinear labelText con el hint
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Cuadro blanco
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: facebookController,
                    decoration: const InputDecoration(
                      labelText: 'Facebook',
                      border: InputBorder.none, // Sin borde
                      contentPadding:
                          EdgeInsets.all(13.0), // Ajustar el padding
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Cuadro blanco
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: instagramController,
                    decoration: const InputDecoration(
                      labelText: 'Instagram',
                      border: InputBorder.none, // Sin borde
                      contentPadding:
                          EdgeInsets.all(13.0), // Ajustar el padding
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      // Realizar la acción de registro del negocio
                      String businessName = businessNameController.text;
                      String businessDescription = businessDescriptionController.text;
                      String facebook = facebookController.text;
                      String instagram = instagramController.text;
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Guardar',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
