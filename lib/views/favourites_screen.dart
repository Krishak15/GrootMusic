import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grootmusic/controllers/song_properties.dart';
import 'package:grootmusic/model/songslist.dart';
import 'package:grootmusic/views/songs_screen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final _audioPlayer = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  refreshLV() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200,
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Favourites',
              style:
                  GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w500),
            )),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                FutureBuilder<List<SongModel>>(
                    future: _audioQuery.querySongs(
                        sortType: SongSortType.DISPLAY_NAME,
                        uriType: UriType.EXTERNAL,
                        path: 'YMusic',
                        ignoreCase: false),
                    builder: (context, item) {
                      if (item.data == null)
                        return const CircularProgressIndicator();

                      if (item.data!.isEmpty)
                        return Column(
                          children: [
                            const Text("Musics not found!"),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        );

                      return ListView.builder(
                          shrinkWrap: true,
                          addAutomaticKeepAlives: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: SongsProperties.FaveSongMusicName.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 75,
                              margin: EdgeInsets.only(
                                  bottom: 10, right: 20, left: 20),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.deepPurple.withOpacity(0.7)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(18),
                                onTap: () {
                                  print(
                                      "======================${item.data![SongsProperties.ind]}");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SongsScreen(
                                          lislen:
                                              SongsProperties.Artwork.length,
                                          songId:
                                              SongsProperties.Artwork[index],
                                          songModel:
                                              SongsProperties.MusicData[index],
                                          audioPlayer: _audioPlayer,
                                          ids: SongsProperties.Artwork[index],
                                        ),
                                      ));
                                },
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      QueryArtworkWidget(
                                        id: SongsProperties.Artwork[index],
                                        type: ArtworkType.AUDIO,
                                        artworkFit: BoxFit.fitHeight,
                                        artworkWidth: 50,
                                        artworkHeight: 50,
                                        artworkBorder:
                                            BorderRadius.circular(15),
                                        artworkClipBehavior: Clip.antiAlias,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              SongsProperties
                                                  .FaveSongMusicName[index],
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            Text(
                                              SongsProperties
                                                  .FaveSongSingerName[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            // SongList.artistL
                                            //     .add(item.data![index].id);
                                          },
                                          icon: const Icon(
                                            Icons.play_circle,
                                            color: Colors.white,
                                          ))
                                    ]),
                              ),
                            );
                          });
                    }),
              ],
            )),
      ),
    );
  }
}
