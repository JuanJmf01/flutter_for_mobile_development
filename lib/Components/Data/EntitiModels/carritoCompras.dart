class CarritoComprasTb {
  final int? idCarrito; //PK
  final int? idUsuario; //FK
  final int? idProducto; //FK
  int cantidad;

  CarritoComprasTb({
    this.idCarrito,
    this.idUsuario,
    this.idProducto,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'idCarrito': idCarrito,
      'idUsuario': idUsuario,
      'idProducto': idProducto,
      'cantidad': cantidad,
    };
  } 

}