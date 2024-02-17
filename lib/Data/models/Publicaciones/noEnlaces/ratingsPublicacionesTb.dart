
class RatingsPublicacionesTb {
  final int idUsuario;
  final int idPublicacion;
  final int? likes;

  RatingsPublicacionesTb({
    required this.idUsuario,
    required this.idPublicacion,
    this.likes,
  });

  Map<String, dynamic> toMapRatingFotoPublicacion() {
    return {
      'idUsuario': idUsuario,
      'idFotoPublicacion': idPublicacion,
      'likes': likes,
    };
  }

   Map<String, dynamic> toMapRatingReelPublicacion() {
    return {
      'idUsuario': idUsuario,
      'idReelPublicacion': idPublicacion,
      'likes': likes,
    };
  }
}