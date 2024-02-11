import 'package:flutter/material.dart';

class FutureGridViewProfile extends StatelessWidget {
  const FutureGridViewProfile({
    super.key,
    required this.idUsuario,
    required this.future,
    required this.bodyItemBuilder,
    required this.physics,
    required this.shrinkWrap,
    required this.gridDelegate,
    this.globalPaddingAll,
  });

  final int idUsuario;
  final Future<List<Object>> Function() future;
  final Widget Function(int index, Object item) bodyItemBuilder;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final SliverGridDelegate gridDelegate;
  final double? globalPaddingAll;

  @override
  Widget build(BuildContext context) {
    List<Object> items = [];

    return FutureBuilder(
        future: future.call(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Error al cargar los... ');
          } else if (snapshot.hasData) {
            items = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(globalPaddingAll ?? 8.0),
                  child: GridView.builder(
                      physics: physics,
                      shrinkWrap: shrinkWrap,
                      gridDelegate: gridDelegate,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, index) {
                        return bodyItemBuilder(index, items[index]);
                      }),
                )
              ],
            );
          } else {
            return const Text('No se encontraron los... ');
          }
        });
  }
}
