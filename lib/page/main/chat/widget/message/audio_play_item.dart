import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import '../../../../../utils/utils.dart';

class AudioPlayWidget extends StatefulWidget {

  bool isPlay;
  bool isSend;

  AudioPlayWidget(this.isPlay,this.isSend,{Key? key}) : super(key: key);

  @override
  State<AudioPlayWidget> createState() => _AudioPlayWidgetState();
}

class _AudioPlayWidgetState extends State<AudioPlayWidget> {

  Timer? _timer;

  int _count = 1;
  bool _isStart = false;

  @override
  void didUpdateWidget(covariant AudioPlayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('didUpdateWidget ');
    if(widget.isPlay){
      startAnim();
    }else{
      stopAnim();
    }
  }

  @override
  void initState() {
    if(widget.isPlay){
      startAnim();
    }
    super.initState();
  }

  void startAnim(){
    if(_isStart){
      return;
    }
    _isStart = true;
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _count++;
      _count = _count % 3;
      setState(() {});
    });
  }

  void stopAnim(){
    if(!_isStart){
      return;
    }
    _isStart = false;
    _count = 0;
    _timer?.cancel();
    _timer = null;
  }


  @override
  Widget build(BuildContext context) {
    return Image.asset(Utils.getChatImgPath(widget.isPlay?widget.isSend?'message_voice_send_$_count':'message_voice_receive_$_count':widget.isSend?'message_voice_send_0':'message_voice_receive_0'),width: 40.w,height: 40.w,);
  }

  @override
  void dispose() {
    stopAnim();
    super.dispose();
  }

}
