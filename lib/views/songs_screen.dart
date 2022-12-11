// ignore_for_file: sort_child_properties_last
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:grootmusic/model/songslist.dart';

import 'package:rxdart/rxdart.dart' as rxdart;

import 'package:grootmusic/controllers/song_properties.dart';
import 'package:grootmusic/views/artwork.dart';
import 'package:grootmusic/views/mainartwork.dart';
import 'package:grootmusic/widgets/seekbar.dart';

import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widgets/widgets.dart';

class SongsScreen extends StatefulWidget {
  SongsScreen(
      {super.key,
      this.songModel,
      this.lislen,
      this.audioPlayer,
      this.ids,
      this.songId,
      this.SongThumb});

  final SongModel? songModel;
  AudioPlayer? audioPlayer = AudioPlayer();
  final ids;
  final QueryArtworkWidget? SongThumb;
  final playPauseNotifier = ValueNotifier<bool>(false);
  int? songId = 0;
  final lislen;

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  // late AudioPlayerManager manager;

  bool isPlay = false;
  bool anim = false;
  bool _isFavoriteSongsIcon = false;
  Duration duration = const Duration();
  Duration position = const Duration();
  bool playico = false;
  int c = 1;
  void changetos(int seconds) {
    Duration _duration = Duration(seconds: seconds);
    widget.audioPlayer!.seek(_duration);
  }

  @override
  void initState() {
    super.initState();
    playMusic();
  }

//playpause
  playpause() {
    setState(() {
      if (SongsProperties.isPlaying == true) {
        playico = false;
      } else {
        playico = true;
      }
    });
  }

  void refresh() {
    setState(() {});
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          widget.audioPlayer!.positionStream,
          widget.audioPlayer!.durationStream,
          (Duration position, Duration? duration) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  void playMusic() {
    try {
      widget.audioPlayer!
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel!.uri!)));
      setState(() {
        SongList.songDetails = widget.songModel!.title.toString();
        SongList.artistD = widget.songModel!.artist.toString();
        SongList.artistT = widget.songModel!.id;
      });
      MediaItem(
          id: '${widget.songModel!.id}',
          title: '${widget.songModel!.title}',
          artist: '${widget.songModel!.artist}',
          album: '${widget.songModel!.album}'
          // artUri: widget.songModel.uri
          );
      widget.audioPlayer!.play();
      SongsProperties.isPlaying = true;
    } catch (e) {
      print("Error loading audio source: $e");
      log("Unable to load Audio Source");
    }
  }

  skipnext() {
    //SongSkip Forward

    if (widget.songId! + c < widget.lislen) {
      c++;
      print("==============================${SongList.artistT}");
      try {
        widget.audioPlayer!.setAudioSource(AudioSource.uri(
            Uri.parse(SongList.SongsSkip[0][widget.songId! + c].uri!)));
        setState(() {
          SongList.songDetails =
              SongList.SongsSkip[0][widget.songId! + c].title.toString();
          SongList.artistD =
              SongList.SongsSkip[0][widget.songId! + c].artist.toString();
          SongList.artistT = SongList.SongsSkip[0][widget.songId! + c].id;

          // print("================================${SongList.songDetails}");
          // print("====++++++++++++++++++++++=====${SongList.artistT}");
        });
        MediaItem(
            id: '${SongList.SongsSkip[0][widget.songId! + c].id}',
            title: '${SongList.SongsSkip[0][widget.songId! + c].title}',
            artist: '${SongList.SongsSkip[0][widget.songId! + c].artist}',
            album: '${widget.songModel!.album}');
        widget.audioPlayer!.play();
        SongsProperties.isPlaying = true;
      } catch (e) {
        print("Error loading audio source: $e");
        log("Unable to load Audio Source");
      }
    } else {
      // ignore: prefer_const_declarations
      final SnackBar _snackBar = const SnackBar(
        content: Text('No more Skippable Songs'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }
  }

  previous() {
    if (widget.songId! + c >= 0) {
      c--;
      try {
        widget.audioPlayer!.setAudioSource(AudioSource.uri(
            Uri.parse(SongList.SongsSkip[0][widget.songId! + c].uri!)));
        setState(() {
          SongList.songDetails =
              SongList.SongsSkip[0][widget.songId! + c].title.toString();
          SongList.artistD =
              SongList.SongsSkip[0][widget.songId! + c].artist.toString();
          SongList.artistT = SongList.SongsSkip[0][widget.songId! + c].id;
        });
        MediaItem(
            id: '${SongList.SongsSkip[0][widget.songId! + c].id}',
            title: '${SongList.SongsSkip[0][widget.songId! + c].title}',
            artist: '${SongList.SongsSkip[0][widget.songId! + c].artist}',
            album: '${widget.songModel!.album}');
        widget.audioPlayer!.play();
        SongsProperties.isPlaying = true;
      } catch (e) {
        print("Error loading audio source: $e");
        log("Unable to load Audio Source");
      }
    } else {
      // ignore: prefer_const_constructors
      final SnackBar _snackBar = SnackBar(
        content: const Text('No more Skippable Songs'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
    }
    //SongSkip Backward
  }

  // void changeToSeconds(int seconds) {
  //   Duration duration = Duration(seconds: seconds);
  //   widget.audioPlayer.seek(duration);
  // }

  @override
  Widget build(BuildContext context) {
    // print("==${SongList.artistT}");
    AudioPlayer _player = AudioPlayer();
    print(widget.SongThumb);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0, actions: []),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: Artwork(
                //artwork
                ide: SongList.artistT,
              ),
            ),
          ]),
          BlurryContainer(
              blur: 60,
              child: Container(
                height: MediaQuery.of(context).size.height,
              )),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  width: MediaQuery.of(context).size.width / 1.3,
                  height: MediaQuery.of(context).size.height * 0.19,
                  child: widget.SongThumb == null
                      ? MainArt(
                          widget: widget,
                          ids: SongList.artistT,
                        )
                      : Image.asset("assets/images/moosikicon.png"),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: widget.audioPlayer!.playingStream,
              builder: (context, snapshot) {
                if (widget.audioPlayer!.playing) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 150,
                          height: 100,
                          child: Lottie.asset("assets/playing.json",
                              reverse: true,
                              // animate: anim,
                              fit: BoxFit.contain,
                              frameRate: FrameRate(240)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.80,
                        )
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              }),
          const BackgroundFilter(),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, left: 8),
                  child: Container(
                      // height: 50,
                      width: MediaQuery.of(context).size.width / 1.15,
                      child: Text(
                        SongList.songDetails.toString(),
                        maxLines: 2,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      )
                      //  Marquee(
                      //   text: SongList.songDetails.toString(),
                      //   style: const TextStyle(
                      //       fontWeight: FontWeight.bold, fontSize: 24),
                      //   scrollAxis: Axis.horizontal,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   blankSpace: 250.0,
                      //   velocity: 100.0,
                      //   pauseAfterRound: Duration(seconds: 3),
                      //   showFadingOnlyWhenScrolling: false,
                      //   fadingEdgeEndFraction: 0.04,
                      //   fadingEdgeStartFraction: 0.04,
                      //   startPadding: 1.0,
                      //   accelerationDuration: const Duration(milliseconds: 2),
                      //   accelerationCurve: Curves.linear,
                      //   decelerationDuration: const Duration(milliseconds: 1000),
                      //   decelerationCurve: Curves.easeOut,
                      // ),
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 23.0,
                  ),
                  child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Text(SongList.artistD.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.4)))),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(children: [
                  Positioned(
                    child: SliderStream(
                        seekBarDataStream: _seekBarDataStream,
                        widget: widget,
                        songsId: widget.songId!),
                  ),
                  Positioned(
                    left: 0,
                    right: 4,
                    bottom: 20,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  print(
                                      "=================songid${widget.songId! + c}==========");
                                  // print(
                                  //     "=================length${SongList.SongsSkip.length}==========");
                                  print(
                                      "=================Lislength${widget.lislen}==========");
                                  previous();
                                });
                              },
                              icon: const Icon(
                                Iconsax.previous,
                                color: Colors.white,
                                size: 40,
                              )),
                          const SizedBox(
                            width: 60,
                          ),
                          IconButton(
                              onPressed: () {
                                print(
                                    "=================songid${widget.songId! + c}==========");
                                // print(
                                //     "=================length${SongList.SongsSkip.length}==========");
                                print(
                                    "=================Lislength${widget.lislen}==========");
                                if (widget.songId! + c <=
                                    SongList.SongsSkip.length) {
                                  skipnext();
                                } else {
                                  print(
                                      "jhgfdsfdghjkljhjgcgfuhi333##############k");
                                }
                              },
                              icon: const Icon(
                                Iconsax.next,
                                color: Colors.white,
                                size: 40,
                              )),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundFilter extends StatefulWidget {
  const BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  State<BackgroundFilter> createState() => BackgroundFilterState();
}

class BackgroundFilterState extends State<BackgroundFilter> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6,
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.black.withOpacity(0.7),
              Colors.black,
            ])),
      ),
    );
  }
}
