class ShoppingCartTb {
  final int idCarrito; //PK
  final int idUsuario; //FK
  final int idProducto; //FK
  final int cantidad;

  ShoppingCartTb({
    required this.idCarrito,
    required this.idUsuario,
    required this.idProducto,
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

class ShoppingCartCreacionTb {
  final int idUsuario; //FK
  final int idProducto; //FK
  final int cantidad;

  ShoppingCartCreacionTb({
    required this.idUsuario,
    required this.idProducto,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'idProducto': idProducto,
      'cantidad': cantidad,
    };
  }
}

class ShoppingCartProductTb {
  final int idCarrito;
  final int idUsuario; //FK
  final int idProducto; //FK
  final int cantidad;

  final String nombreProducto;
  final double precio;
  final String urlImage;

  ShoppingCartProductTb copyWith({
    int? idCarrito,
    int? idUsuario,
    int? idProducto,
    int? cantidad,
    String? nombreProducto,
    double? precio,
    String? urlImage,
  }) {
    return ShoppingCartProductTb(
      idCarrito: idCarrito ?? this.idCarrito,
      idUsuario: idUsuario ?? this.idUsuario,
      idProducto: idProducto ?? this.idProducto,
      cantidad: cantidad ?? this.cantidad,
      nombreProducto: nombreProducto ?? this.nombreProducto,
      precio: precio ?? this.precio,
      urlImage: urlImage ?? this.urlImage,
    );
  }

  ShoppingCartProductTb(
      {required this.idCarrito,
      required this.idUsuario,
      required this.idProducto,
      required this.cantidad,
      required this.nombreProducto,
      required this.precio,
      required this.urlImage});

  factory ShoppingCartProductTb.fromJson(Map<String, dynamic> json) {
    return ShoppingCartProductTb(
      idCarrito: json['idCarrito'],
      idUsuario: json['idUsuario'],
      idProducto: json['idProducto'],
      cantidad: json['cantidad'],
      nombreProducto: json['nombreProducto'],
      precio: json['precio'].toDouble(),
      urlImage: json['urlImage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idCarrito': idCarrito,
      'idUsuario': idUsuario,
      'idProducto': idProducto,
      'cantidad': cantidad,
      'nombreProducto': nombreProducto,
      'precio': precio,
      'urlImage': urlImage,
    };
  }
}
