import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Artwork extends StatelessWidget {
  const Artwork({
    Key? key,
    this.ide,
  }) : super(key: key);
  final ide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          transform: Matrix4.translationValues(
              MediaQuery.of(context).size.width * .0, -100.0, 0.0),
          child: QueryArtworkWidget(
            // artworkWidth: MediaQuery.of(context).size.width,
            // artworkHeight: MediaQuery.of(context).size.height,
            id: ide,
            type: ArtworkType.AUDIO,
            artworkBorder: BorderRadius.circular(0),
            quality: 100,
            artworkColor: Colors.blue.withOpacity(0.1),
            artworkBlendMode: BlendMode.saturation,
            artworkFit: BoxFit.cover,
            artworkQuality: FilterQuality.high,
          ),
        ),
      ],
    );
  }
}
