import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({super.key, required this.id,});

  final int id;
  

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBarDetail(),
          SliverListDetail()
        ],
      ),
    );
  }
}



class SliverAppBarDetail extends StatefulWidget {
  const SliverAppBarDetail({super.key});

  @override
  State<SliverAppBarDetail> createState() => _SliverAppBarDetailState();
}

class _SliverAppBarDetailState extends State<SliverAppBarDetail> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      pinned: true,
      centerTitle: false,
      stretch: true,
      expandedHeight: 250.0,
      flexibleSpace: const FlexibleSpaceBar(
        stretchModes: [StretchMode.zoomBackground],
        background: Image(
          image: AssetImage('lib/images/feature.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}



class SliverListDetail extends StatefulWidget {
  const SliverListDetail({super.key});

  @override
  State<SliverListDetail> createState() => _SliverListDetailState();
}

class _SliverListDetailState extends State<SliverListDetail> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 20, right: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color(0xff243A73),
              ),
              height: 200,
              width: MediaQuery.of(context).size.width,
            ),
          );
        },
        childCount: 5,
      ),
    );
  }
}












