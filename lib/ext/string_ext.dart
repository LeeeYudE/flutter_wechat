import 'dart:typed_data';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sprintf/sprintf.dart';
import '../utils/utils.dart';
import 'toast_ext.dart';

extension StringExt on String {
  Color hex() {
    if (!startsWith('#') && (length != 7 || length != 4)) {
      throw Exception('color 格式不正确');
    }
    String color = this;
    if (color.length == 4) {
      final r = color[1];
      final g = color[2];
      final b = color[3];
      color = "#$r$r$g$g$b$b";
    }
    color.replaceAll('#', '');
    return Color(int.parse('0xff$color'));
  }

  bool checkNull() {
    return isEmpty;
  }

  String? formatter(List<String> _formatters) {
    return sprintf(this, _formatters);
  }

  //匹配中括号的内容
  static final RegExp _regex = RegExp(r'\[([^\[\]]*)\]');
  static final RegExp _characterRegex = RegExp(r'[a-zA-Z]');


  String str() {
    return tr;
  }

  bool get isAlpha => _characterRegex.hasMatch(this);

  bool get hasData => isNotEmpty;

  bool get noData => isEmpty;

  int get toInt {
    try {
      if (isEmpty) {
        return 0;
      } else {
        return int.parse(this);
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  double get secureDouble {
    try {
      if (isEmpty) {
        return 0;
      } else {
        return double.parse(this);
      }
    } catch (e) {
      print(e);
    }
    return 0;
  }

  //计算文本占用宽高
  double paintWidthWithTextStyle(TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  double paintHeightWithTextStyle(TextStyle style, {required double maxWidth}) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: this, style: style),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size.height;
  }

  //根据keyword创建富文本,这里实现忽略大小写
  RichText? formatRichTextWithWord(
    String keyWord,
    List<TextStyle> styles, {
    TextAlign textAlign = TextAlign.left,
    TextOverflow overflow = TextOverflow.visible,
  }) {
    if (TextUtil.isEmpty(keyWord.trim()) || TextUtil.isEmpty(this)) {
      return null;
    }
    final String lowerCaseContent = toLowerCase();
    final String lowerCaseWord = keyWord.toLowerCase();
    if (lowerCaseContent.contains(lowerCaseWord)) {}
    return null;
  }

  //第一个颜色为文本的默认颜色,其它颜色为为格式化的富文本的颜色,匹配中括号内的东西,中括号内的作为富文本不同颜色的部分,
  // 正则匹配中括号的东西,传入的TextStyle列表,给对应中括号内容,设置不同颜色锋哥
  RichText formatColorRichText(
    List<TextStyle> styles, {
    TextAlign textAlign = TextAlign.left,
    TextOverflow overflow = TextOverflow.visible,
  }) {
    String content = this;
    final List<TextSpan> spans = <TextSpan>[];
    final Iterable<RegExpMatch> matchers = _regex.allMatches(this);
    //第二个开始才是真正需要格式化的颜色
    int count = 1;
    TextStyle? style;
    for (final Match m in matchers) {
      if (count < styles.length) {
        style = styles[count];
      }
      final String regexText = m.group(0)!;
      final int index = content.indexOf(regexText);
      //匹配出来的普通文本
      spans.add(TextSpan(text: content.substring(0, index)));
      content = content.substring(index, content.length);
      //切割余下的文本,去掉中括号,留下文本内容
      spans.add(TextSpan(
          text: regexText.substring(1, regexText.length - 1), style: style));
      content = content.substring(regexText.length, content.length);
      count++;
    }
    //剩余最后的内容
    spans.add(TextSpan(text: content));
    return RichText(
      textAlign: textAlign,
      overflow: overflow,
      text: TextSpan(
        text: '',
        style: styles.isNotEmpty ? styles[0] : null,
        children: spans,
      ),
    );
  }

  copy() {
    '已复制'.toast;
    Clipboard.setData(ClipboardData(text: this));
  }

  String sprint(List<String> args) {
    return sprintf(this, args);
  }

  ///value: 文本内容；fontSize : 文字的大小；fontWeight：文字权重；maxWidth：文本框的最大宽度；maxLines：文本支持最大多少行
  double calculateTextWidth(
      BuildContext context, fontSize, double maxWidth, int maxLines) {
    final TextPainter painter = TextPainter(

        ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
        locale: Localizations.localeOf(context),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: this,
            style: TextStyle(
              fontSize: fontSize,
            )));
    painter.layout(maxWidth: maxWidth);

    ///文字的宽度:painter.width
    return painter.width;
  }

  String? getParameters(String key) {
    try {
      final Uri u = Uri.parse(this);
      return u.queryParameters[key];
    } catch (ex) {
      return null;
    }
  }

  Uint8List get convertStringToUint8List{
    final List<int> codeUnits = this.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
    return unit8List;
  }

  String toPassword(){
    var stringBuffer = StringBuffer();
    stringBuffer.writeAll(split('').map((e) => '*').toList());
    return stringBuffer.toString();
  }

  String get imgAsset => Utils.getImgPath(this);

}
