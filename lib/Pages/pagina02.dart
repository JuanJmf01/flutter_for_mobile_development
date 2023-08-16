import 'package:etfi_point/main.dart';
import 'package:flutter/material.dart';

class Pagina02 extends StatelessWidget {
  const Pagina02({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Pagina 2'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            const Text('Terminos y condiciones', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),),
            const SizedBox(height: 15,),
            const Text('Aceptar los terminos y condiciones es necesario para continuar con el optimo funcionamiento de la app, Aceptar los terminos y condiciones es necesario para continuar con el optimo funcionamiento de la app',
            style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,),
            const SizedBox(height: 15,),
            const Text('Aceptar los terminos y condiciones es necesario para continuar con el optimo funcionamiento de la app, Aceptar los terminos y condiciones es necesario para continuar con el optimo funcionamiento de la app',
            style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,),
            const SizedBox(height: 15,),
            const Text('Aceptar los terminos y condiciones es necesario para continuar con el optimo funcionamiento de la app, Aceptar los terminos y condiciones es necesario para continuar con el optimo funcionamiento de la app',
            style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,),
            const SizedBox(height: 15,),
            const Text('Aceptar los terminos y condiciones es necesario para continuar con el optimo funcionamiento de la app, Aceptar los terminos y condiciones es necesario para continuar con el optimo funcionamiento de la app',
            style: TextStyle(fontSize: 15), textAlign: TextAlign.justify,),
            const SizedBox(height: 15,),

            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: ElevatedButton(
            //     child: const Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         Text('Aceptar terminos y condiciones', style: TextStyle(fontSize: 15),),
            //         Icon(Icons.arrow_forward_ios_outlined)
            //       ],
            //     ),
            //     onPressed: () => {
            //       Navigator.push(context,
            //       MaterialPageRoute(builder: (context) =>  MyAppp()))
            //     },
            //    ),
            // )

          ],
        ),
      ),
    );
  }
}