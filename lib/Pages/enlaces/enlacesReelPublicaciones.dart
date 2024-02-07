import 'package:etfi_point/Components/Utils/showVideo.dart';
import 'package:flutter/material.dart';

class EnlacesReelPublicaciones extends StatefulWidget {
  const EnlacesReelPublicaciones({super.key});

  @override
  State<EnlacesReelPublicaciones> createState() =>
      _EnlacesReelPublicacionesState();
}

class _EnlacesReelPublicacionesState extends State<EnlacesReelPublicaciones> {
  @override
  Widget build(BuildContext context) {
    return const IndividualReelProfile();
  }
}

class IndividualReelProfile extends StatelessWidget {
  const IndividualReelProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey.shade300),
      child: const ShowVideo(
        urlReel:
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
      ),
    );
  }
}
