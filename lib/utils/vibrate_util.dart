import 'package:flutter_vibrate/flutter_vibrate.dart';

class VibrateUtil{

  static void  feedback(){

    const _type = FeedbackType.warning;
    Vibrate.feedback(_type);

  }

  static void  selection(){
    // Vibrate.vibrate();
    const _type = FeedbackType.selection;
    Vibrate.feedback(_type);

  }

}