import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/language/strings.dart';

/*

https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html
https://www.ibabbleon.com/iOS-Language-Codes-ISO-639.html

*/

class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  @override
  Map<String, Map<String, String>> get keys => localizedSimpleValues;
}
