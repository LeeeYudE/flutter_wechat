import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat/page/util/webview_page.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/utils/utils.dart';
import '../color/colors.dart';
import 'emoji_text.dart';
import 'package:wechat/core.dart';

typedef OnAtUserClick = void Function(String uid);
typedef OnURLClick = void Function(String? url);

class PatternUtil {

  static const String _urlStr = r'^(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]';
  static final RegExp _urlPattern = RegExp(_urlStr);
  static RegExp emojiPattern = RegExp(r'\[[^\]]+\]');

  static RichText transformEmoji(String content, TextStyle textStyle,
      {double imageSize = 40,
      overflow = TextOverflow.ellipsis ,
      List<RegExpMatch>? allMatches,
      int? maxLines,OnURLClick? onURLClick}) {
    final hasMatch = emojiPattern.hasMatch(content);
    if (hasMatch) {
      final List<InlineSpan> stack = [];
      List<RegExpMatch> _allMatches;
      if (allMatches != null) {
        _allMatches = allMatches;
      } else {
        _allMatches = emojiPattern.allMatches(content).toList();
      }

      for (int i = 0; i < _allMatches.length; i++) {
        final element = _allMatches[i];
        if (i == 0 && element.start != 0) {
          final String text = content.substring(0, element.start);
          stack.add(TextSpan(children: _checkUrlPattern(text, textStyle,onURLClick)));
        }
        final int end = element.end;

        final group = element.group(0);

        final emoji = EmojiUtil.instance.checkEmoji(group);
        if (emoji != null) {
          stack.add(ImageSpan(AssetImage(Utils.getImgPath(emoji.name!,dir:Utils.DIR_EMOJI)),
              imageWidth: imageSize.w, imageHeight: imageSize.w));
        } else {
          stack.add(TextSpan(children: _checkUrlPattern(group!, textStyle,onURLClick)));
        }

        if (i != _allMatches.length - 1) {
          final elementNext = _allMatches[i + 1];
          if (elementNext.start - end != 1) {
            final String text = content.substring(end, elementNext.start);
            stack.add(TextSpan(children: _checkUrlPattern(text, textStyle,onURLClick)));
          }
        } else {
          if (end != content.length) {
            final String text = content.substring(end, content.length);
            stack.add(TextSpan(children: _checkUrlPattern(text, textStyle,onURLClick)));
          }
        }
      }
      return RichText(
        text: TextSpan(children: stack),
        overflow: overflow,
        maxLines: maxLines,
      );
    } else {
      return RichText(
        text: TextSpan(children: _checkUrlPattern(content, textStyle,onURLClick)),
        overflow: overflow,
        maxLines: maxLines,
      );
    }
  }

  //优化代码，兼容表情和@的显示
  static List<TextSpan> atTextSpan(String content,TextStyle textStyle) {
    return [
      TextSpan(
        text: content,
        style: textStyle,
      )
    ];
  }

  static RichText transformAtStr(String content, TextStyle textStyle, {overflow = TextOverflow.visible, int? maxLines}) {
    return RichText(
      text: TextSpan(
        text: content,
        style: textStyle,
      ),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  static RichText checkEmoji(
      String content, TextStyle textStyle,
      {OnURLClick? onURLClick, int? maxline}) {
    return RichText(
      text: TextSpan(
          children:
          _checkUrlPattern(content, textStyle, onURLClick)),
      maxLines: maxline,
      overflow: TextOverflow.ellipsis,
    );
  }

  static List<InlineSpan> _checkUrlPattern(String content, TextStyle textStyle, OnURLClick? onURLClick) {
    final List<InlineSpan> stack = [];

    final hasMatch = _urlPattern.hasMatch(content);
    if (hasMatch) {
      final List<RegExpMatch> allMatches = _urlPattern.allMatches(content).toList();

      for (int i = 0; i < allMatches.length; i++) {
        final element = allMatches[i];
        final int end = element.end;
        final String? group = element.group(0);

        stack.add(TextSpan(
            text: group,
            style: textStyle.copyWith(color: Colours.c_4486F4),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
              NavigatorUtils.toNamed(WebViewPage.routeName,arguments: WebviewArguments(url: group!));
                // if (await canLaunchUrl(Uri.parse(group!))) {
                //   await launchUrl(Uri.parse(group));
                // }
                // if (onURLClick != null) {
                //   onURLClick(group);
                // }
              }));

        if (i != allMatches.length - 1) {
          final elementNext = allMatches[i + 1];
          if (elementNext.start - end != 1) {
            final String text = content.substring(end, elementNext.start);
            stack.add(TextSpan(
              text: text,
              style: textStyle,
            ));
          }
        } else {
          if (end != content.length) {
            final String text = content.substring(end, content.length);
            stack.add(TextSpan(
              text: text,
              style: textStyle,
            ));
          }
        }
      }
    } else {
      stack.add(TextSpan(
        text: content,
        style: textStyle,
      ));
    }

    return stack;
  }

}
