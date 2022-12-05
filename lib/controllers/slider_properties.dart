import 'package:flutter/material.dart';

class MusicPlayerState with ChangeNotifier {
  bool _isPlaying = false;
  bool isPlay = false;

  bool get isPlaying => _isPlaying;

  void togglePlayPause() {
    isPlay = !isPlay;
    notifyListeners();
  }

  void play() {
    _isPlaying = true;
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    notifyListeners();
  }
}
