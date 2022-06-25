

import 'package:flustars/flustars.dart';

extension IntExt on int {

  String getDurationTime(){
    if(this == 0){
      return '00:00';
    }
    final second = (this) % 60;
    final strSecond = second < 10?'0$second':'$second';
    final min = (this)~/60;
    final strMin = min < 10?'0$min':'$min';
    return '$strMin:$strSecond';
  }

  duration() async {
    await Future.delayed(Duration(milliseconds: this));
  }

  String formatTime({String? format}) {
    //不满足13位,也就是当前不是毫秒,补足变成毫秒
    return DateUtil.formatDate(DateTime.fromMillisecondsSinceEpoch(this), format: format);
  }

  String commonDateTime({bool show_time = true}) {
    if(0 == this){
      return '';
    }

    return formatTime(format: show_time?'yyyy-MM-dd HH:mm':'yyyy-MM-dd');
  }

}