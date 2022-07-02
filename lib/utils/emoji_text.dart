import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/core.dart';

///emoji/image text
class EmojiText extends SpecialText {
  EmojiText(TextStyle textStyle, {this.start}) : super(flag, ']', textStyle);

  static const String flag = '[';

  final int? start;
  @override
  InlineSpan finishText() {
    final String key = toString();

    ///https://github.com/flutter/flutter/issues/42086
    /// widget span is not working on web
    final checkEmoji = EmojiUtil.instance.checkEmoji(key);
    if (checkEmoji != null && !kIsWeb) {
      //fontsize id define image height
      //size = 30.0/26.0 * fontSize
      double size = 32.sp;

      ///fontSize 26 and text height =30.0
      //final double fontSize = 26.0;
      return ImageSpan(
          AssetImage(Utils.getImgPath(checkEmoji.name!,dir: Utils.DIR_EMOJI)),
          actualText: key,
          imageWidth: size,
          imageHeight: size,
          start: start!,
          fit: BoxFit.fill,
          margin: const EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0)
      );
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class EmojiUtil {

  EmojiUtil._();

  List<EmojiModel> emojiList = [];

  EmojiModel? checkEmoji(String? tag){
     final where = emojiList.indexWhere((element) => tag == element.tag);
     if(where != -1){
       return emojiList[where];
     }
     return null;
  }

  Future<void> init() async {
    if(emojiList.isNotEmpty){
      return;
    }
    for (int i = 1; i < 100; i++) {
      emojiList.add(EmojiModel('sg$i','[sg$i]'));
    }
    // final snapshot = await rootBundle
    //     .loadString('assets/data/emoji_json.json');
    // final List<dynamic> data = json.decode(snapshot.toString());
    // for (int i = 0; i < data.length; i++) {
    //   final Map map =  data[i];
    //   emojiList.add(EmojiModel(map['name'],map['tag'] ));
    // }
  }


  static EmojiUtil? _instance;
  static EmojiUtil get instance => _instance ??= EmojiUtil._();
}

class EmojiModel{
  String? name;
  String? tag;

  EmojiModel(this.name, this.tag);
}