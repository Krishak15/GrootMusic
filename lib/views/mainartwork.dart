import 'package:flutter/material.dart';

import 'package:grootmusic/views/songs_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MainArt extends StatelessWidget {
  const MainArt({
    Key? key,
    this.ids,
    required this.widget,
  }) : super(key: key);

  final SongsScreen widget;
  final ids;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: ids,
      type: ArtworkType.AUDIO,
      // artworkFit: BoxFit.fill,
      artworkWidth: MediaQuery.of(context).size.width / 1.8,
      artworkHeight: MediaQuery.of(context).size.height * 0.30,
      artworkBorder: BorderRadius.circular(20),
      quality: 100,
      artworkQuality: FilterQuality.high,
    );
  }
}
