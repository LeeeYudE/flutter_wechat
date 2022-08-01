import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class AudioManager {
  AudioManager._();

  static AudioManager? _instance;

  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioCache _audioCache = AudioCache(prefix: 'assets/audio/');

  static AudioManager get instance{
    if (_instance == null) {
      _instance = AudioManager._();
      _initAudio();
    }
    return _instance!;
  }

  static _initAudio() {
    _audioPlayer.onPlayerStateChanged.listen((event) {
      debugPrint('onPlayerStateChanged = ' + event.toString());
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      // _audioProviderModel.currentProgress = 0;
      debugPrint('onPlayerCompletion ');
    });

    //获取音频的真实时长
    _audioPlayer.onDurationChanged.listen((Duration event) {

    });
  }


  AudioPlayer? getAudioPlayer() {
    return _audioPlayer;
  }


  shake(){
    _audioCache.play('shake.mp3');
  }

  dispose() {
    if(_audioPlayer.state == PlayerState.PLAYING){
      _audioPlayer.stop();
    }
  }

}
