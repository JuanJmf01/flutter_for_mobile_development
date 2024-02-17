// cambiar 'RatingsCreacionTb' por  RatingsTb


class RatingsCreacionTb {
  final int idUsuario;
  final int idProServicio;
  final String? comentario;
  final int? likes;
  final int? ratings;

  RatingsCreacionTb({
    required this.idUsuario,
    required this.idProServicio,
    this.comentario,
    this.likes,
    this.ratings,
  });

  factory RatingsCreacionTb.fromJsonProductRatings(Map<String, dynamic> json) {
    return RatingsCreacionTb(
      idUsuario: json['idUsuario'],
      idProServicio: json['idProducto'],
      comentario: json['comentario'],
      likes: json['likes'],
      ratings: json['ratings'],
    );
  }

  factory RatingsCreacionTb.fromJsonServiceRatings(Map<String, dynamic> json) {
    return RatingsCreacionTb(
      idUsuario: json['idUsuario'],
      idProServicio: json['idServicio'],
      comentario: json['comentario'],
      likes: json['likes'],
      ratings: json['ratings'],
    );
  }

  Map<String, dynamic> toMapProductRatings() {
    return {
      'idUsuario': idUsuario,
      'idProducto': idProServicio,
      'comentario': comentario,
      'likes': likes,
      'ratings': ratings,
    };
  }

    Map<String, dynamic> toMapServiceRatings() {
    return {
      'idUsuario': idUsuario,
      'idServicio': idProServicio,
      'comentario': comentario,
      'likes': likes,
      'ratings': ratings,
    };
  }

  @override
  String toString() {
    return 'RatingsTb{idUsuario: $idUsuario, idProServicio: $idProServicio, comentario: $comentario, likes: $likes,  ratings: $ratings}';
  }
}
