
// Cheekku 🐒 💝, [11/26/2022 3:53 PM]
// import 'dart:developer';
// import 'dart:io';

// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttericon/entypo_icons.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:just_audio_background/just_audio_background.dart';
// import 'package:musicapp/widgets/song_art.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// class Playp extends StatefulWidget {
//    Playp({Key? key, required this.songModel, required this.Audio}) : super(key: key);
//   final SongModel songModel;
//   final AudioPlayer Audio ;



//   @override
//   State<Playp> createState() => _PlaypState();
// }

// class _PlaypState extends State<Playp> {
//   // @override
//   // void dispose() {
//   //   // TODO: implement dispose
//   //   widget.Audio.dispose();
//   //   super.dispose();
//   // }
//   bool isplay = false;
//   bool isrepeat = false;

//   Duration duration = Duration();
//   Duration position = Duration();
//   // void changeplayerview(){
//   //   setState(() {
//   //     isplayer = !isplayer;
//   //   });
//   // }

//   play(){
//     try {
//       widget.Audio.setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
//       tag: MediaItem(
//         id: '${widget.songModel.id}',
//         album: "${widget.songModel.album}",
//         title: "${widget.songModel.displayName}",
//         // artUri: Uri.parse('https://example.com/albumart.jpg'),
//       );
//       widget.Audio.play();
//       isplay = true;
//     } on Exception catch(e){
//       return Text("Error loading audio source: $e");
//     }
//     widget.Audio.durationStream.listen((d) {
//       setState(() {
//         duration = d!;
//       });
//     });
//     widget.Audio.positionStream.listen((p) {
//       setState(() {
//         position = p!;
//       }
//       );});
//   }
//   // Stream<Durationstate> get _durationstate =>
//   //     Rx.combineLatest2<Duration, Duration?, Durationstate>(
//   //       widget.Audio.positionStream, widget.Audio.positionStream, (position, duration) => Durationstate(
//   //       position: position, total: duration?? Duration.zero
//   //     )
//   //     );
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     play();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Container(
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.indigo,
//                     Colors.indigo[100]!,],
//                 )),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//             SizedBox(
//             height: 40,
//           ),
//           Row(
//             children: [
//               SizedBox(
//                 width: 10,
//               ),
//               InkWell(
//                   onTap: ()
//                   {
//                     Navigator.pop(context);
//                   },
//                   child: Icon(CupertinoIcons.back,color: Colors.white,size: 25,)),
//               SizedBox(
//                 width: 320,
//               ),
//               Icon(Icons.more_vert, color: Colors.white,size: 25,)
//             ],
//           ),
//               SizedBox(
//                 height: 50,

// Cheekku 🐒 💝, [11/26/2022 3:53 PM]
// ),
//               Container(
//                 child: const Song_art(),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Center(
//                 child: Container(
//                   alignment: Alignment.topCenter,
//                   height: 50,
//                   width: 250,
//                   child: Center(
//                     child: Text(widget.songModel.displayName,
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 1,style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20
//                       ),),
//                   ),
//                 ),
//               ),
//               Row(mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     height: 30,
//                     width: 120,
//                     child: Text(widget.songModel.artist.toString(),
//                       overflow: TextOverflow.ellipsis,style: TextStyle(
//                         color: Colors.white
//                       ),
//                       maxLines: 1,),
//                   ),
//                   IconButton(onPressed: (){

//                   }, icon: Icon(Icons.favorite_border_outlined,
//                   color: Colors.white,
//                   size: 30,))
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: Text(position.toString().split(".")[0], style: TextStyle(
//                       color: Colors.white
//                     ),),
//                   ),
//                   Expanded(
//                       child: Slider(
//                         activeColor: Colors.indigo,
//                         min: Duration(microseconds: 0).inSeconds.toDouble(),
//                         max: duration.inSeconds.toDouble(),
//                         value: position.inSeconds.toDouble(),
//                         onChanged: (value){
//                           setState(() {
//                             changetosec(value.toInt());
//                             value = value;
//                           });
//                         },
//                       )),
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: Text(duration.toString().split(".")[0], style: TextStyle(
//                       color: Colors.white
//                     ),),
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   IconButton(onPressed: (){
//                   widget.Audio.seek(Duration.zero,
//                   index: widget.Audio.effectiveIndices!.first);
//                   }, icon: Icon(Icons.repeat,
//                     color: Colors.white,
//                     size: 30,)),

//                   IconButton(onPressed: (){
//                     widget.Audio.hasPrevious ? widget.Audio.seekToPrevious : null;
//                   }, icon: Icon(Icons.skip_previous,
//                   color: Colors.white,
//                   size: 30,)),

// Cheekku 🐒 💝, [11/26/2022 3:53 PM]
// IconButton(onPressed: (){
//                     setState(() {
//                       if(isplay){
//                         widget.Audio.pause();
//                       }
//                       else{
//                         widget.Audio.play();
//                       }
//                       isplay = !isplay;
//                     });
//                   }, icon: Container(
//                     child: Center(
//                       child: Icon(isplay? Icons.pause : Icons.play_arrow,
//                         color: Colors.white,
//                         size: 30,),
//                     ),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,color: Colors.indigo,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black,
//                           blurRadius: 8.0,
//                         )
//                       ],),
//                     )
//                     ),

//                   IconButton(onPressed: (){
//                     widget.Audio.hasNext ? widget.Audio.seekToNext : null;
//                   }, icon: Icon(Icons.skip_next,
//                     color: Colors.white,
//                   size: 30,)),

//                   IconButton(onPressed: () async {
//                       final enable = !isrepeat;
//                       if (enable) {
//                         await widget.Audio.shuffle();
//                       }
//                       await widget.Audio.setShuffleModeEnabled(enable);
//                     }, icon: Icon(Icons.shuffle,
//                     color: Colors.white,
//                     size: 30,),
//                   ),
//                 ],
//               ),
        //       Container(
        //         child: StreamBuilder<Durationstate>(
        //           stream: _durationstate,
        //           builder: (context, snapshot){
        //             final durationstate = snapshot.data;
        //             final progresss = durationstate?.position?? Duration.zero;
        //             final total = durationstate?.total?? Duration.zero;
        //             return ProgressBar(
        //               progress: progresss,
        //               total: total,
        //               barHeight: 20.0,
        //               progressBarColor: Colors.white,
        //               thumbColor: Colors.white,baseBarColor: Colors.grey,
        //               timeLabelTextStyle: TextStyle(
        //                 fontSize: 0
        //               ),
        //               onSeek: (duration){
        //                 widget.Audio.seek(duration);
        //               },
        //             );
        //           },
        //
        //         ),
        //       ),
        //   StreamBuilder<Durationstate>(
        //     stream: _durationstate,
        //     builder: (context, snapshot) {
        //       final durationstate = snapshot.data;
        //       final progresss = durationstate?.position ?? Duration.zero;
        //       final total = durationstate?.total ?? Duration.zero;
        //       return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Flexible(
        //               child: Text(
        //                 progresss.toString().split(".")[0],
        //                 style: TextStyle(
        //                   color: Colors.white
        //                 ),
        //               ) ),
        //           Flexible(
        //               child: Text(
        //                 total.toString().split(".")[0],
        //                 style: TextStyle(
        //                     color: Colors.white
        //                 ),
        //               ) )
        //         ],
        //       );
        //     }
        //       ),
        //       Container(
        //         child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //           mainAxisSize: MainAxisSize.max,
        //           children: [
        //             Flexible(
        //                 child: InkWell(