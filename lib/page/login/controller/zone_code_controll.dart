import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:wechat/base/base_getx.dart';

import '../../../utils/utils.dart';
import '../model/zone_code.dart';

class ZoneCodeController extends BaseXController {

  ///区号
  final List<ZoneCode> zoneCodeList = [];

  @override
  onReady(){
    _fetchZoneCode();
  }


  _fetchZoneCode() async {
    setBusyState();
    // 获取用户信息列表
    final jsonStr = await rootBundle.loadString(Utils.getJsonPath('world_zone_code'));

    // zoneCodeJson
    final List zoneCodeJson = json.decode(jsonStr);

    // 遍历
    for (var json in zoneCodeJson) {
      final ZoneCode zoneCode = ZoneCode.fromJson(json);
      zoneCodeList.add(zoneCode);
    }

    for (int i = 0, length = zoneCodeList.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(zoneCodeList[i].name??'');
      String tag = pinyin.substring(0, 1).toUpperCase();
      zoneCodeList[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        zoneCodeList[i].tagIndex = tag;
      } else {
        zoneCodeList[i].tagIndex = "#";
      }
    }
    // 根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(zoneCodeList);
    setIdleState();
  }

}