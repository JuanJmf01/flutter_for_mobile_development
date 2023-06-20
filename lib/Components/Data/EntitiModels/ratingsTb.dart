class RatingsTb {
  final int id;
  final int? idUsuario;
  final int? idProducto;
  final String? comentario;
  final int? likes;
  final int? ratings;

  RatingsTb({
    required this.id,
    this.idUsuario,
    this.idProducto,
    this.comentario,
    this.likes,
    this.ratings
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idUsuario': idUsuario,
      'idProducto': idProducto,
      'comentario': comentario,
      'likes': likes,
      'ratings': ratings,
    };
  }

  factory RatingsTb.fromMap(Map<String, dynamic> map) {
    return RatingsTb(
      id: map['id'],
      idUsuario: map['idUsuario'],
      idProducto: map['idProducto'],
      comentario: map['comentario'],
      likes: map['likes'],
      ratings: map['ratings'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RatingsTb &&
        other.id == id &&
        other.idUsuario == idUsuario &&
        other.idProducto == idProducto &&
        other.comentario == comentario &&
        other.likes == likes &&
        other.ratings == ratings;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      idUsuario.hashCode ^
      idProducto.hashCode ^
      comentario.hashCode ^
      likes.hashCode ^
      ratings.hashCode;

  @override
  String toString() {
    return 'RatingsTb{id: $id, idUsuario: $idUsuario, idProducto: $idProducto, comentario: $comentario, likes: $likes,  ratings: $ratings}';
  }
}

class RatingsCreacionTb {
  final int idUsuario;
  final int idProducto;
  final String? comentario;
  final int? likes;
  final int? ratings;


  RatingsCreacionTb({
    required this.idUsuario,
    required this.idProducto,
    this.comentario,
    this.likes,
    this.ratings,
  });


   factory RatingsCreacionTb.fromMap(Map<String, dynamic> map) {
    return RatingsCreacionTb(
      idUsuario: map['idUsuario'],
      idProducto: map['idProducto'],
      comentario: map['comentario'],
      likes: map['likes'],
      ratings: map['ratings'],
    );
  }
  

  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'idProducto': idProducto,
      'comentario': comentario,
      'likes': likes,
      'ratings': ratings,
    };
  }
}
