import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../base/constant.dart';
import '../language/strings.dart';
import '../language/language_model.dart';

///设置语音工具
class LanguageUtilV2 {
  //支持的多语言
  static List<LanguageModel> getLanguages() => [
    LanguageModel(Ids.language_system, 'zh', 'CN'),
    LanguageModel(Ids.languageZH, 'zh', 'CN'),
    LanguageModel(Ids.languageEN, 'en', 'US'),
  ];

  static LanguageModel? _selectLanguage;

  static void setLocalModel(LanguageModel model) {
    final List<LanguageModel> list = getLanguages();
    if (list.contains(model)) {
      _selectLanguage = model;
    } else {
      _selectLanguage = list[0];
    }
    SpUtil.putObject(Constant.SP_KEY_LANGUAGE, _selectLanguage!.toJson());
    Get.updateLocale(model.toLocale());
  }

  static LanguageModel getCurrentLanguage() {
    if (null == _selectLanguage) {
      _selectLanguage = SpUtil.getObj(Constant.SP_KEY_LANGUAGE, (Map v) => LanguageModel.fromJson(v as Map<String?, dynamic>));
      _selectLanguage ??= getLanguages()[0];
    }
    return _selectLanguage!;
  }

  static LanguageModel initLanguage() {
    final Locale? deviceLocale = Get.deviceLocale;
    final LanguageModel? selectLanguage =
        SpUtil.getObj(Constant.SP_KEY_LANGUAGE, (Map v) => LanguageModel.fromJson(v as Map<String?, dynamic>));
    getLanguages()[0].languageCode = deviceLocale?.languageCode;
    getLanguages()[0].countryCode = deviceLocale?.countryCode;
    //首次设置，使用系统的，没有再默认英文
    if (selectLanguage == null) {
      final List<LanguageModel> list = getLanguages();
      if (null == deviceLocale) {
        return list[0];
      }
      for (final element in list) {
        if (deviceLocale.languageCode == element.languageCode ||
            element.languageCode!.contains(deviceLocale.languageCode)) {
          return element;
        }
      }
      return list[0];
    }
    return selectLanguage;
  }

}
