import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class PruebaTb {
  final int? id;
  String nombre;
  int? age;
  String imagePath;

  PruebaTb({
    this.id,
    required this.nombre,
    this.age,
    required this.imagePath
  });

  get length => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'age': age,
      'imagePath': imagePath,
    };
  } 
}
