import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

import 'package:on_audio_query/on_audio_query.dart';

class SongCard extends StatefulWidget {
  const SongCard({super.key});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.26,
      child: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: SongSortType.TITLE,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (item.data!.isEmpty) return const Text("Musics not found!");
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item.data!.length,
                itemBuilder: (context, index) {
                  // print("---------------${item.data![index].title}");
                  return Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: QueryArtworkWidget(
                            id: item.data![index].id,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.cover,
                            artworkWidth: 50,
                            artworkHeight: 200,
                            artworkBorder: BorderRadius.circular(15),
                            artworkClipBehavior: Clip.antiAlias,
                          ),
                        ),
                      ),
                      BlurryContainer(
                        width: MediaQuery.of(context).size.width * 0.50,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.37,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.data![index].title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    item.data![index].artist.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              // ignore: prefer_const_constructors
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: const Icon(
                                  Icons.play_circle,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  );
                });
          }),
    );
  }
}
