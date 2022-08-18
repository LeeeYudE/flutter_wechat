import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class AudioManager {

  static AudioManager? _instance;

  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioCache _audioCache = AudioCache(prefix: 'assets/audio/');

  // 单例公开访问点
  factory AudioManager() => _getInstance()!;


  // 私有构造函数
  AudioManager._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static AudioManager? _getInstance() {
    _instance ??= AudioManager._();
    return _instance;
  }


  static _initAudio() {
    _audioPlayer.onPlayerStateChanged.listen((event) {
      debugPrint('onPlayerStateChanged = ' + event.toString());
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
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

  sendMessage(){
    _audioCache.play('send_message.mp3');
  }

  receiveMessage(){
    _audioCache.play('receive_message.mp3');
  }

  dispose() {
    if(_audioPlayer.state == PlayerState.PLAYING){
      _audioPlayer.stop();
    }
  }

}
