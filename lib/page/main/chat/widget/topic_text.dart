import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';

import '../../../../color/colors.dart';

class TopicText extends SpecialText {
  static const String flag = "#";
  final int start;

  /// whether show background for @somebody
  final bool showAtBackground;

  TopicText(TextStyle textStyle, SpecialTextGestureTapCallback? onTap,
      {this.showAtBackground = false, this.start = 0})
      : super(
    flag,
    " ",
    textStyle,
  );

  @override
  InlineSpan finishText() {
    TextStyle? textStyle = this.textStyle?.copyWith(color: Colours.c_5B6B8D);

    final String atText = toString();

    return showAtBackground
        ? BackgroundTextSpan(
        background: Paint()..color = Colours.c_5B6B8D.withOpacity(0.15),
        text: atText,
        actualText: atText,
        start: start,
        ///caret can move into special text
        deleteAll: true,
        style: textStyle)
        : SpecialTextSpan(
        text: atText,
        actualText: atText,
        start: start,
        style: textStyle,
    );
  }
}
