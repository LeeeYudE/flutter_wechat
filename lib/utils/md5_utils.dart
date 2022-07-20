import 'dart:convert';
import 'dart:io';

/// @author Barry
/// @date 2020/9/1
/// describe:
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Md5Util {
  // md5 加密
  static String generateMd5(String data) {
    final content = const Utf8Encoder().convert(data);
    final digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static String generateHeroTag(List<String> args) => generateMd5(args.toString());

  //根据json生成唯一的herotag,后面看有没有必要使用uuid
  static String jsonHero(Map map) => generateMd5(map.toString());

  static Future<String?> calculateMD5SumAsyncWithCrypto(String filePath) async {
    var ret = '';
    final file = File(filePath);
    if (await file.exists()) {
      ret =  hex.encode((await md5.bind(file.openRead()).first).bytes);
    } else {
      print('`$filePath` does not exits so unable to evaluate its MD5 sum.');
      return null;
    }
    debugPrint('calculateMD5SumAsyncWithCrypto = ' + ret);
    return ret;
  }

  static String get createWxId => 'wxid_'+generateMd5(const Uuid().v4().toString()).substring(16);

}
