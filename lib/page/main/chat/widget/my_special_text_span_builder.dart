import 'package:extended_text_library/extended_text_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../utils/emoji_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder({this.showAtBackground = false});

  /// whether show background for @somebody
  final bool showAtBackground;
  @override
  TextSpan build(String data,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    if (kIsWeb) {
      return TextSpan(text: data, style: textStyle);
    }

    return super.build(data, textStyle: textStyle, onTap: onTap);
  }

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap, int? index}) {
    if (flag == '') {
      return null;
    }
    ///index is end index of start flag, so text start index should be index-(flag.length-1)
    if (isStart(flag, EmojiText.flag)) {
      return EmojiText(textStyle!, start: index! - (EmojiText.flag.length - 1));
    }
    // else if (isStart(flag, AtText.flag)) {
    //   return AtText(
    //     textStyle!,
    //     onTap,
    //     start: index! - (AtText.flag.length - 1),
    //     showAtBackground: showAtBackground,
    //   );
    // }
    // else if (isStart(flag, DollarText.flag)) {
    //   return DollarText(textStyle, onTap,
    //       start: index - (DollarText.flag.length - 1));
    // }
    return null;
  }
}
