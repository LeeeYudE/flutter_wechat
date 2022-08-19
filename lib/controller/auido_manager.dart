import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/file_utils.dart';
import 'package:wechat/utils/range_download_manage.dart';

class AudioManager  {

  static AudioManager? _instance;

  static final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioCache _audioCache = AudioCache(prefix: 'assets/audio/');

  static final AudioMessage _initAudioMessage =  AudioMessage();

  // 单例公开访问点
  factory AudioManager() => _getInstance()!;
  static Rx<AudioMessage> playAudioMessage = _initAudioMessage.obs;

  // 私有构造函数
  AudioManager._() {
    // 具体初始化代码
    _initAudio();
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
      debugPrint('onPlayerCompletion');
      playAudioMessage.value = _initAudioMessage;
      _clearAudio();
    });
    _audioPlayer.onPlayerError.listen((event) {
      debugPrint('onPlayerError $event');
      playAudioMessage.value = _initAudioMessage;
    });
    //获取音频的真实时长
    _audioPlayer.onDurationChanged.listen((Duration event) {

    });
  }

  playMessage(AudioMessage message) async {
    if(_audioPlayer.state == PlayerState.PLAYING && playAudioMessage.value == message){
      _audioPlayer.stop();
      _clearAudio();
      return;
    }
    var audioTemporaryDirectory = await FileUtils.getAudioTemporaryDirectory();
    var filename = message.filename;
    if(filename == null){
      return;
    }
    DownLoadManage().download(message.url, audioTemporaryDirectory.path + '/'+filename,done: (path){
      var file = File(path);
      if(Platform.isAndroid){
        _audioPlayer.playBytes(file.readAsBytesSync());
      }else{
        _audioPlayer.play(path,isLocal:true);
      }
      playAudioMessage.value = message;
    });
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

  static _clearAudio(){
    playAudioMessage.value = _initAudioMessage;
  }

  dispose() {
    if(_audioPlayer.state == PlayerState.PLAYING){
      _audioPlayer.stop();
      _clearAudio();
    }
  }

}
