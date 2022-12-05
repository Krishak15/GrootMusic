// import 'package:flutter/material.dart';

// class PlayButton extends StatelessWidget {
//   const PlayButton({super.key, this.aPlay});
//   final aPlay;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         // Listen to the audioPlayer.state stream to get the current state of the player
//         stream: aPlay.state,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             // If the player is playing, show a pause button
//             return IconButton(
//               // Use the onPressed property to call the pause() method when the button is tapped
//               onPressed: aPlay.pause,
//               icon: Icon(Icons.pause),
//             );
//           }
//           // If the player is paused or stopped, show a play button
//           else {
//             return IconButton(
//               // Use the onPressed property to call the play() method when the button is tapped
//               onPressed: aPlay.play,
//               icon: Icon(Icons.play_arrow),
//             );
//           }
//         }
//         // If the snapshot doesn't have data yet, return a loading indicator

//         );
//   }
// }
