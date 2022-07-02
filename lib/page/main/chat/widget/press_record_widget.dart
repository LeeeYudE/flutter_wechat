import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/permission_utils.dart';
import 'package:wechat/widget/subscription_mixin.dart';
import '../../../../language/strings.dart';
import '../../../../utils/file_utils.dart';
import '../../../../utils/vibrate_util.dart';
import '../../../../widget/custom_long_tap.dart';
import '../controller/chat_controller.dart';

class PressRecordWidget extends StatefulWidget {

  const PressRecordWidget({Key? key}) : super(key: key);

  @override
  State<PressRecordWidget> createState() => PressRecordWidgetState();
}

class PressRecordWidgetState extends State<PressRecordWidget> with SubscriptionMixin {

  static const int VOICE_STATUS_START = 0;
  static const int VOICE_STATUS_END = 1;
  static const int VOICE_STATUS_CANCEL = 2;

  FlutterAudioRecorder2? mFlutterAudioRecorder2;
  final ChatController _controller = Get.find();
  final GlobalKey _key = GlobalKey();
  bool isVoiceFinish = false;
  late String path;
  Timer? _powerTimer;

  @override
  Widget build(BuildContext context) {
    return Obx((){
      var status = _controller.recordStatus.value;
      return GestureDetectorCustomLongTapDuration(
        child: Container(
          key: _key,
          height: 60.w,
          decoration: Colours.white.boxDecoration(),
          child: Center(
            child: Text((status == VOICE_STATUS_START?Ids.press_start_voice:status == VOICE_STATUS_END?Ids.press_end_voice:Ids.press_cancel_voice).str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),),
          ),
        ),
        onLongPress: (){
          debugPrint('onLongPress');
          VibrateUtil.feedback();
          _startRecord();
          _updateStatus(VOICE_STATUS_END);
        },
        onLongPressStart: (details){
          debugPrint('onLongPressStart');
        },
        onLongPressEnd: (details){
          debugPrint('onLongPressEnd');
          _stopVoice(status == VOICE_STATUS_CANCEL);
          _updateStatus(VOICE_STATUS_START);
        },
        onLongPressMoveUpdate: (LongPressMoveUpdateDetails details){
          if(mFlutterAudioRecorder2 != null){
            var includeOffset = _key.includeOffset(details.globalPosition);
            if(includeOffset){
              if(status == VOICE_STATUS_CANCEL){
                _updateStatus(VOICE_STATUS_END);
              }
            }else{
              if(status == VOICE_STATUS_END){
                _updateStatus(VOICE_STATUS_CANCEL);
              }
            }
          }
        },
      );
    },
    );
  }

  _updateStatus(int status){
    _controller.recordStatus.value = status;
  }

  //开始录音
  _startRecord() async {
    if(!((await FlutterAudioRecorder2.hasPermissions)??false)){
      if(!await PermissionUtils.requestPermissionMicrophone()){
        Ids.no_permission.str().toast();
      }
      return;
    }

    final Directory tempDir = await FileUtils.getVoiceTemporaryDirectory();
    path = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    mFlutterAudioRecorder2 = FlutterAudioRecorder2(path, audioFormat: AudioFormat.AAC); // or AudioFormat.WAV
    await mFlutterAudioRecorder2!.initialized;
    mFlutterAudioRecorder2?.start();
    periodic(200,(time){
      _powerTimer = time;
      mFlutterAudioRecorder2?.current().then((value){
        debugPrint('metering ${value?.metering?.peakPower} ${value?.metering?.averagePower}');
      });
    });
  }


  _stopVoice(bool isCancel) async {
    debugPrint('检查结束  _stopVoice');
    _powerTimer?.cancel();
    _powerTimer = null;
    mFlutterAudioRecorder2?.stop().then((value) async {

      mFlutterAudioRecorder2 = null;
      if (isCancel || value == null) {
        return;
      }
      int _second = value.duration!.inSeconds;
      debugPrint('value.duration $_second');
      if(_second < 1){
        Ids.record_too_short.str().toast();
        return;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    mFlutterAudioRecorder2?.stop();
  }

}
