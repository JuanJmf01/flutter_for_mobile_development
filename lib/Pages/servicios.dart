import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Servicios extends StatelessWidget {
  const Servicios({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(10.0),
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.0),
          color: Colors.grey.shade300,
        ),
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.grey,
              ),
              child: Center(
                child: Text("Image"),
              ),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinea el texto a la izquierda
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Titulo principal"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("Precio actual"),
                          Text("Precio Anterior"),
                        ],
                      ),
                      Icon(CupertinoIcons.heart_fill),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
