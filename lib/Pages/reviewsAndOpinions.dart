import 'dart:math';
import 'package:etfi_point/Components/Data/Entities/ratingsDb.dart';
import 'package:etfi_point/Components/Utils/stars.dart';
import 'package:flutter/material.dart';

class ReviewsAndOpinions extends StatefulWidget {
  const ReviewsAndOpinions({super.key, required this.idProducto});

  final int idProducto;

  @override
  State<ReviewsAndOpinions> createState() => _ReviewsAndOpinionsState();
}

class _ReviewsAndOpinionsState extends State<ReviewsAndOpinions> {
  int selectIndex = 0;

  Future<List<int>> obtenerStarCounts() async {
    return await RatingsDb.getStarCounts(widget.idProducto);
  }

  void onRatingSelected(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Titulo',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: FutureBuilder<List<int>>(
            future: obtenerStarCounts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final starCounts = snapshot.data!;
                return CustomScrollView(
                  slivers: [
                    GeneralReviews(starCounts: starCounts),
                    StarsOptions(onRatingSelected: onRatingSelected),
                    SliverToBoxAdapter(
                      child: Comments(
                        selectIndex: selectIndex,
                        idProducto: widget.idProducto,
                        paddingOutsideHorizontal: 15.0,
                        paddingOutsideVertical: 5.0,
                        containerPadding: 15.0,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error al obtener los datos');
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}

// return widget(
//   child: Column(
//     children: [
//       Padding(
//         padding: const EdgeInsets.symmetric(vertical: 20.0),
//         child: GeneralReviews(starCounts: starCounts),
//       ),
//       StarsOptions(onRatingSelected: onRatingSelected),
//       Comments(
//         selectIndex: selectIndex,
//         idProducto: widget.idProducto,
//       ),
//     ],
//   ),
// );

class GeneralReviews extends StatelessWidget {
  const GeneralReviews({
    super.key,
    required this.starCounts,
  });

  final List<int> starCounts;

  String formatVotes(int votes) {
    if (votes >= 1000) {
      double num = votes / 1000;
      String suffix = 'k';
      if (num >= 1000) {
        num = num / 1000;
        suffix = 'M';
      }
      return num.toStringAsFixed(1) + suffix;
    }
    return votes.toString();
  }

  String obtenerPromedio() {
    double averageRating = 0.0;
    int totalStars = 0;
    int totalPersonasQueVotaron = 0;

    for (int i = 0; i < starCounts.length; i++) {
      int stars = starCounts[i];
      int starValue = 5 - i;
      totalStars += stars * starValue;
      totalPersonasQueVotaron +=
          stars; // Sumar la cantidad de votos en esta posición
    }

    // Calcula el promedio dividiendo la suma de estrellas entre la cantidad de personas que votaron
    if (totalPersonasQueVotaron > 0) {
      averageRating = totalStars / totalPersonasQueVotaron;
    }

    return averageRating.toString();
  }

  @override
  Widget build(BuildContext context) {
    const double barWidth = 150.0;
    const double barHeight = 10.0;
    const double barSpacing = 10.0;
    const double borderRadius = 30.0;
    final Color lightGray = Colors.grey[300]!;
    final Color darkGray = Colors.grey[600]!;

    int totalVotes = starCounts.reduce((sum, count) => sum + count);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    obtenerPromedio(),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(5, (index) {
                final int starIndex = 5 - index;
                final int starCount = starCounts[index];

                final double percentage =
                    totalVotes > 0 ? starCount / totalVotes : 0.0;
                final double width = barWidth * percentage;

                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          20.0, barSpacing, 10.0, 0.0),
                      child: Stars(
                        index: starIndex,
                        size: 19.0,
                        separationEachStar: 15.0,
                        color: darkGray,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, barSpacing, 10.0, 0.0),
                      child: Container(
                        width: barWidth,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: lightGray,
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              width: width,
                              decoration: BoxDecoration(
                                color: darkGray,
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: barSpacing),
                      child: Text(
                        formatVotes(starCount),
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class StarsOptions extends StatefulWidget {
  const StarsOptions({Key? key, required this.onRatingSelected})
      : super(key: key);

  final ValueChanged<int> onRatingSelected;

  @override
  State<StarsOptions> createState() => _StarsOptionsState();
}

class _StarsOptionsState extends State<StarsOptions> {
  int? selectedRating;

  @override
  void initState() {
    selectedRating = 0;
    super.initState();
  }

  void onRatingSelected(int index) {
    setState(() {
      selectedRating = index;
    });
    widget.onRatingSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 55,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CajaDeFiltros(
                onRatingSelected: onRatingSelected,
                selectIndexActual: 0,
                isSelected: selectedRating == 0,
                texto: 'Todos',
              ),
              for (int index = 5; index >= 1; index--)
                CajaDeFiltros(
                  onRatingSelected: onRatingSelected,
                  selectIndexActual: index,
                  isSelected: selectedRating == index,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CajaDeFiltros extends StatelessWidget {
  const CajaDeFiltros({
    Key? key,
    required this.onRatingSelected,
    this.selectIndexActual,
    this.isSelected = false,
    this.texto,
    this.icon,
  }) : super(key: key);

  final ValueChanged<int> onRatingSelected;
  final int? selectIndexActual;
  final bool isSelected;
  final String? texto;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          onRatingSelected(selectIndexActual!);
        },
        child: AnimatedContainer(
          width: texto == null ? min(62, 80) : min(100, 130),
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white24 : Colors.grey[200],
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: Colors.grey.shade500,
              width: 2.0,
            ),
          ),
          child: Row(
            children: [
              Text(
                texto ?? selectIndexActual.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  color: Colors.black,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Icon(
                  Icons.star_rounded,
                  size: 20,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Comments extends StatefulWidget {
  Comments({
    Key? key,
    required this.selectIndex,
    required this.idProducto,
    this.maxCommentsToShow,
    required this.paddingOutsideHorizontal,
    required this.paddingOutsideVertical,
    required this.containerPadding,
    this.fontSizeName,
    this.fontSizeStarts,
    this.color,
    this.fontSizeDescription,
  }) : super(key: key);

  final int selectIndex;
  final int idProducto;
  final int? maxCommentsToShow;
  final double paddingOutsideHorizontal;
  final double paddingOutsideVertical;
  final double containerPadding;
  final Color? color;
  final double? fontSizeName;
  final double? fontSizeStarts;
  final double? fontSizeDescription;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  int rating = 0;
  int selectIndex = 0;

  List<Map<String, dynamic>> reviews = [];
  List<Map<String, dynamic>> reviewsAux = [];
  int? maxCommentsToShow;

  @override
  void initState() {
    super.initState();

    maxCommentsToShow = widget.maxCommentsToShow;
  }

  @override
  void didUpdateWidget(Comments oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectIndex != widget.selectIndex) {
      selectIndex = widget.selectIndex;

      //print(selectIndex);
    }
  }

  Future<List<Map<String, dynamic>>> identifyQuery() async {
    List<Map<String, dynamic>> ratings;
    if (selectIndex == 0) {
      ratings = await obtenerRatingsAndOthersbyProduct();
      reviewsAux = ratings;
    } else {
      ratings = filtrarReviewsPorRating(selectIndex);
    }
    return ratings;
  }

  Future<List<Map<String, dynamic>>> obtenerRatingsAndOthersbyProduct() async {
    final List<Map<String, dynamic>> ratings =
        await RatingsDb.getReviewsByProducto(widget.idProducto);

    return ratings;
  }

  List<Map<String, dynamic>> filtrarReviewsPorRating(int rating) {
    print('llega a filtrar');
    reviews = [];
    reviews = reviewsAux.where((review) {
      return review['ratings'] == rating;
    }).toList();

    return reviews;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: identifyQuery(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          reviews = snapshot.data!;
          if (maxCommentsToShow != null && maxCommentsToShow! > 0) {
            reviews = reviews.take(maxCommentsToShow!).toList();
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: widget.paddingOutsideHorizontal,
                    vertical: widget.paddingOutsideVertical),
                child: Container(
                  padding: EdgeInsets.all(widget.containerPadding),
                  decoration: BoxDecoration(
                    color: widget.color ?? Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviews[index]['nombreUsuario'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: widget.fontSizeName ?? 16.0, //16
                        ),
                      ),
                      Row(
                        children: [
                          Stars(
                            index: reviews[index]['ratings'] ?? 0,
                            size: widget.fontSizeStarts ?? 23.0, //23
                            separationEachStar: 20,
                            color: Colors.grey.shade800,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          reviews[index]['comentario'] ?? '',
                          style: TextStyle(
                              fontSize: widget.fontSizeDescription ?? 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error al obtener los datos');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
