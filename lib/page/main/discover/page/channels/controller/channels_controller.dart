import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx_refresh.dart';

import '../../../../../../base/constant.dart';

class ChannelsController extends BaseXRefreshController with GetSingleTickerProviderStateMixin {

  final PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    queryChannles(refresh: true);
  }

  queryChannles({bool refresh = false}) async {
    var lcQuery = LCQuery(Constant.OBJECT_NAME_CHANNLES);
    lcQuery.orderByDescending('createdAt');
    lcQuery.include('user');
    var bool = await queryList(lcQuery,refresh: refresh,onQueryList: (list) async {
      await Future.forEach<LCObject>(list, (channel) async {
        var lcQuery = LCQuery(Constant.OBJECT_NAME_CHANNLES_COMMENTS);
        lcQuery.whereEqualTo('channel', channel);
        var commentsCount = await lcQuery.count();
        channel['commentsCount'] = commentsCount;
      });
    });
    var _index = pageController.page?.toInt()??0;

    if(!refresh && bool && _index < list.length){
      WidgetsBinding.instance.addPostFrameCallback((callback) {
        pageController.jumpToPage(_index+1);
      });
    }
  }

}