import 'package:etfi_point/components/widgets/navigatorPush.dart';
import 'package:etfi_point/config/theme/appTheme.dart';
import 'package:etfi_point/libraries/image_picket_editor/lib/widgets/imagePickerEditorStructure.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme().getTheme(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar imagenes"),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              NavigatorPush.navigate(
                  context, const ImagePickerEditorStructure());
            },
            child: const Text("Seleccionar imagenes")),
      ),
    );
  }
}
