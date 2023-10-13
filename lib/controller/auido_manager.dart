
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
    _audioPlayer.onPlayerComplete.listen((event) {
      debugPrint('onPlayerCompletion');
      playAudioMessage.value = _initAudioMessage;
      _clearAudio();
    });
    //获取音频的真实时长
    _audioPlayer.onDurationChanged.listen((Duration event) {

    });
  }

  playMessage(AudioMessage message) async {
    if(_audioPlayer.state == PlayerState.playing && playAudioMessage.value == message){
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
      _audioPlayer.play(DeviceFileSource(path));
      playAudioMessage.value = message;
    });
  }

  shake(){
    _audioPlayer.play(AssetSource('audio/shake.mp3'));
  }

  sendMessage(){
    _audioPlayer.play(AssetSource('audio/send_message.mp3'));
  }

  receiveMessage(){
    _audioPlayer.play(AssetSource('audio/receive_message.mp3'));
  }

  static _clearAudio(){
    playAudioMessage.value = _initAudioMessage;
  }

  dispose() {
    if(_audioPlayer.state == PlayerState.playing){
      _audioPlayer.stop();
      _clearAudio();
    }
  }

}
