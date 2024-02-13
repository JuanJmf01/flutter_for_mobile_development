// import 'package:etfi_point/Components/Data/EntitiModels/productoTb.dart';
// import 'package:etfi_point/Components/Data/EntitiModels/servicioTb.dart';
// import 'package:etfi_point/Components/Data/Entities/productosDb.dart';
// import 'package:etfi_point/Components/Data/Entities/servicioDb.dart';
// import 'package:flutter/material.dart';

// class ProServiciosProvider extends ChangeNotifier {
//   List<ProductoTb> _productosByNegocio = [];
//   List<ServicioTb> _serviciosByNegocio = [];

//   bool _isInitProductos = false;
//   bool _isInitServicios = false;

//   List<ProductoTb> get productosByNegocio => _productosByNegocio;
//   List<ServicioTb> get serviciosByNegocio => _serviciosByNegocio;

//   bool get isInitProductos => _isInitProductos;
//   bool get isInitServicios => _isInitServicios;

//   Future<List<ProductoTb>> obtenerProductosByNegocio(int idUsuario) async {
//     if (!_isInitProductos) {
//       _productosByNegocio = await ProductoDb.getProductosByNegocio(idUsuario);
//       _isInitProductos = true;
      
//       notifyListeners();
//     }

//     return _productosByNegocio;
//   }

//   Future<List<ServicioTb>> obtenerServiciosByNegocio(int idUsuario) async {
//     if (!_isInitServicios) {
//       _serviciosByNegocio = await ServicioDb.getServiciosByNegocio(idUsuario);
//       _isInitServicios = true;

//       notifyListeners();
//     }
//     return _serviciosByNegocio;
//   }

//   void obtenerProServiciosByNegocio(int idUsuario){
//     obtenerProductosByNegocio(idUsuario);
//     obtenerServiciosByNegocio(idUsuario);
//   }
// }
