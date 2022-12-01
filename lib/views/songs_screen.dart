// ignore_for_file: sort_child_properties_last
import 'dart:developer';
import 'package:audio_service/audio_service.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:grootmusic/models/art_provider.dart';
import 'package:grootmusic/views/artwork.dart';
import 'package:grootmusic/views/mainartwork.dart';

import 'package:grootmusic/widgets/artwork.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SongsScreen extends StatefulWidget {
  SongsScreen(
      {super.key, required this.songModel, required this.player, this.ids});
  final SongModel songModel;
  final AudioPlayer player;
  final ids;

  @override
  State<SongsScreen> createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final _player = AudioPlayer();

  bool isPlay = false;
  bool anim = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void changetos(int seconds) {
    Duration _duration = Duration(seconds: seconds);
    widget.player.seek(_duration);
  }

  playmusic() {
    try {
      widget.player
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      MediaItem(
          id: '${widget.songModel.id}',
          title: '${widget.songModel.title}',
          artist: '${widget.songModel.artist}',
          album: '${widget.songModel.album}'
          // artUri: widget.songModel.uri
          );
      widget.player.play();
      isPlay = true;
    } catch (e) {
      print("Error loading audio source: $e");
    }
    widget.player.durationStream.listen((d) {
      duration = d!;
    });
    widget.player.positionStream.listen((p) {
      position = p;
    });
  }

  @override
  void initState() {
    super.initState();
    playmusic();
    // _player.playerStateStream.listen((state) {
    //   setState(() {
    //     isPlay = state == PlayerState(true, ProcessingState.ready);
    //   });
    // });

    // _player.durationStream.listen((newDuration) {
    //   setState(() {
    //     duration == newDuration;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayer _player = AudioPlayer();

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent, elevation: 0, actions: []),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Artwork(
              ide: widget.songModel.id,
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
                  child: MainArt(
                    widget: widget,
                    ids: widget.songModel.id,
                  ),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                isPlay == true
                    ? Container(
                        width: 150,
                        height: 100,
                        child: Lottie.asset("assets/playing.json",
                            reverse: true,
                            // animate: anim,
                            fit: BoxFit.contain,
                            frameRate: FrameRate(240)),
                      )
                    : SizedBox(),
                // WaveF(
                //   inputmusic: widget.songModel.track,
                // )

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                )
              ],
            ),
          ),
          const _BackgroundFilter(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 1.15,
                  child: Marquee(
                    text: widget.songModel.title.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    blankSpace: 50.0,
                    velocity: 120.0,
                    showFadingOnlyWhenScrolling: false,
                    fadingEdgeEndFraction: 0.04,
                    fadingEdgeStartFraction: 0.04,
                    startPadding: 1.0,
                    pauseAfterRound: Duration(seconds: 2),
                    accelerationDuration: Duration(milliseconds: 2),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: Duration(milliseconds: 1000),
                    decelerationCurve: Curves.easeOut,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Text(widget.songModel.artist.toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withOpacity(0.4)))),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.98,
                child: Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.indigo.withOpacity(0.2),
                  min: Duration(microseconds: 0).inSeconds.toDouble(),
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      (value.toInt());
                      value = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 60,
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.66,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        if (isPlay) {
                          widget.player.pause();
                        } else {
                          widget.player.play();
                        }
                        isPlay = !isPlay;
                      });
                    },
                    child: Container(
                      child: Container(
                          child: Icon(
                        isPlay ? Iconsax.pause_circle : Iconsax.play_circle,
                        color: Colors.white,
                        size: 60,
                      )),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

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
