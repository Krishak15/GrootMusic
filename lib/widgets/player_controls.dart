import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:grootmusic/controllers/slider_dialog.dart';
import 'package:grootmusic/model/songslist.dart';
import 'package:grootmusic/views/songs_screen.dart';
import 'package:grootmusic/widgets/seekbar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../controllers/song_properties.dart';

class SliderStream extends StatefulWidget {
  final int songsId;
  SliderStream({
    this.TitleSong,
    this.songModelList,
    Key? key,
    required Stream<SeekBarData> seekBarDataStream,
    required this.widget,
    required this.songsId,
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Stream<SeekBarData> _seekBarDataStream;
  final SongsScreen widget;
  final List<SongModel>? songModelList;
  var TitleSong;
  final audioPlayer = AudioPlayer();

  @override
  State<SliderStream> createState() => _SliderStreamState();
}

class _SliderStreamState extends State<SliderStream> {
  int c = 1;
  bool isFavIcon = false;
  int currentIndex = 0;
  List<AudioSource> songList = [];

  @override
  void initState() {
    super.initState();
  }

  skipnext() {
    //SongSkip Forward
    c++;
    try {
      widget.widget.audioPlayer!.setAudioSource(AudioSource.uri(
          Uri.parse(SongList.SongsSkip[0][widget.widget.songId! + c].uri!)));
      setState(() {
        fulldat = SongList.SongsSkip[0][widget.widget.songId! + c];
        SongList.songDetails =
            SongList.SongsSkip[0][widget.widget.songId! + c].title.toString();
        SongList.artistD =
            SongList.SongsSkip[0][widget.widget.songId! + c].artist.toString();
        SongList.artistT = SongList.SongsSkip[0][widget.widget.songId! + c].id;

        // print("================================${SongList.songDetails}");
        // print("====++++++++++++++++++++++=====${SongList.artistT}");
      });
      MediaItem(
          id: '${SongList.SongsSkip[0][widget.widget.songId! + c].id}',
          title: '${SongList.SongsSkip[0][widget.widget.songId! + c].title}',
          artist: '${SongList.SongsSkip[0][widget.widget.songId! + c].artist}',
          album: '${widget.widget.songModel!.album}');
      widget.widget.audioPlayer!.play();
      SongsProperties.isPlaying = true;
    } catch (e) {
      print("Error loading audio source: $e");
      log("Unable to load Audio Source");
    }
  }

  SongModel? fulldat;

  previous() {
    //SongSkip Backward
    c--;
    try {
      widget.widget.audioPlayer!.setAudioSource(AudioSource.uri(
          Uri.parse(SongList.SongsSkip[0][widget.widget.songId! + c].uri!)));
      setState(() {
        SongList.songDetails =
            SongList.SongsSkip[0][widget.widget.songId! + c].title.toString();
        SongList.artistD =
            SongList.SongsSkip[0][widget.widget.songId! + c].artist.toString();
        SongList.artistT = SongList.SongsSkip[0][widget.widget.songId! + c].id;

        fulldat = SongList.SongsSkip[0][widget.widget.songId! + c];
      });
      MediaItem(
          id: '${SongList.SongsSkip[0][widget.widget.songId! + c].id}',
          title: '${SongList.SongsSkip[0][widget.widget.songId! + c].title}',
          artist: '${SongList.SongsSkip[0][widget.widget.songId! + c].artist}',
          album: '${widget.widget.songModel!.album}');
      widget.widget.audioPlayer!.play();
      SongsProperties.isPlaying = true;
    } catch (e) {
      print("Error loading audio source: $e");
      log("Unable to load Audio Source");
    }
  }

  @override
  Widget build(BuildContext context) {
    var sup = "HELOO";
    bool rep = false;
    var ico;
    ico = Iconsax.repeat;
    final refreshr = BackgroundFilter();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Iconsax.shuffle,
                  size: 35,
                  color: Colors.white,
                ),
                InkWell(
                  onTap: () {
                    SongsProperties.ind = currentIndex;
                    SongsProperties.fav.add(SongsProperties.musicData);
                    // SongsProperties.fav.add(fulldat);

                    setState(() {});
                    setState(() {
                      print(
                          "=================full data=======${SongsProperties.MusicData}");

                      if (isFavIcon == false) {
                        isFavIcon = true;
                      }

                      if (SongsProperties.FaveSongMusicName.contains(SongList
                          .SongsSkip[currentIndex][widget.widget.songId!]
                          .title)) {
                        SongsProperties.MusicData.remove(SongList
                            .SongsSkip[currentIndex][widget.widget.songId!]);
                        SongsProperties.FaveSongMusicName.remove(SongList
                            .SongsSkip[currentIndex][widget.widget.songId!]
                            .title);
                        SongsProperties.FaveSongSingerName.remove(SongList
                                .SongsSkip[currentIndex][widget.widget.songId!]
                                .artist ??
                            "No Artist");
                        SongsProperties.Artwork.remove(SongList
                            .SongsSkip[currentIndex][widget.widget.songId!].id);
                      } else {
                        SongsProperties.MusicData.add(
                            SongList.SongsSkip[currentIndex]
                                [widget.widget.songId!]); //ALL MUSIC DATA
                        //----------------------------------------------//
                        SongsProperties.FaveSongMusicName.add(SongList
                            .SongsSkip[currentIndex][widget.widget.songId!]
                            .title);
                        SongsProperties.FaveSongSingerName.add(SongList
                                .SongsSkip[currentIndex][widget.widget.songId!]
                                .artist ??
                            "No Artist");
                        SongsProperties.Artwork.add(SongList
                            .SongsSkip[currentIndex][widget.widget.songId!].id);

                        print("====================${currentIndex}");
                        // print(
                        //     "====================${SongsProperties.MusicData}");
                        print("===================${SongsProperties.Artwork}");
                      }
                    });
                  },
                  child: Container(
                      child: isFavIcon
                          ? Icon(
                              Iconsax.heart5,
                              color: Colors.purple.shade300,
                              size: 35,
                            )
                          : const Icon(
                              Iconsax.heart,
                              color: Colors.white,
                              size: 35,
                            )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder<SeekBarData>(
            stream: widget._seekBarDataStream,
            builder: (context, snapshot) {
              final PositionData = snapshot.data;
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: SeekBar1(
                  position: PositionData?.position ?? Duration.zero,
                  duration: PositionData?.duration ?? Duration.zero,
                  onChangeEnd: widget.widget.audioPlayer!.seek,
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // StreamBuilder<SequenceState?>(
              //   stream: widget.widget.audioPlayer.sequenceStateStream,
              //   builder: (context, index) {
              //     return IconButton(
              //         onPressed: () {
              //           previous();
              //           widget.widget.audioPlayer.seekToPrevious;
              //         },
              //         icon: const Icon(
              //           Iconsax.previous,
              //           color: Colors.white,
              //           size: 40,
              //         ));
              //   },
              // ),
              StreamBuilder<PlayerState>(
                stream: widget.widget.audioPlayer!.playerStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final playerState = snapshot.data;
                    final processingState = playerState!.processingState;
                    if (processingState == ProcessingState.loading) {
                      return const Icon(
                        Iconsax.data,
                        size: 79.5,
                      );
                    } else if (!widget.widget.audioPlayer!.playing) {
                      return IconButton(
                          iconSize: 63,
                          onPressed: widget.widget.audioPlayer!.play,
                          icon: Icon(
                            Iconsax.play_circle,
                            color: Colors.white.withOpacity(0.85),
                          ));
                    } else if (processingState != ProcessingState.completed) {
                      return IconButton(
                          iconSize: 63,
                          onPressed: widget.widget.audioPlayer!.pause,
                          icon: Icon(
                            Iconsax.pause_circle,
                            color: Colors.white.withOpacity(0.85),
                          ));
                    } else {
                      return IconButton(
                          iconSize: 63,
                          onPressed: () => widget.widget.audioPlayer!.seek(
                                Duration.zero,
                                index: widget.widget.audioPlayer!
                                    .effectiveIndices!.first,
                              ),
                          icon: Icon(
                            Iconsax.repeat_circle,
                            color: Colors.white.withOpacity(0.85),
                          ));
                    }
                  } else {
                    return const Icon(
                      Iconsax.data,
                      size: 79.5,
                    );
                  }
                },
              ),
              // StreamBuilder<SequenceState?>(
              //   stream: widget.widget.audioPlayer.sequenceStateStream,
              //   builder: (context, index) {
              //     return IconButton(
              //         onPressed: (() {
              //           setState(() {});
              //           skipnext();
              //           widget.widget.audioPlayer.seekToNext();
              //         }),
              //         icon: const Icon(
              //           Iconsax.next,
              //           color: Colors.white,
              //           size: 40,
              //         ));
              //   },
              // ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
          //   child: Row(
          //     children: [
          //       IconButton(
          //         iconSize: 40,
          //         icon: Icon(
          //           rep == false ? Iconsax.repeat : Iconsax.repeate_one,
          //           color: Colors.white,
          //         ),
          //         onPressed: () {},
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
