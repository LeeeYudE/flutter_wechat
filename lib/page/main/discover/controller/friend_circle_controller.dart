
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';

class FriendCircleController extends BaseXController{

  final RefreshController refreshController = RefreshController();

  RxList<LCObject> list = <LCObject>[].obs;
  ValueNotifier<bool> headerNotifier = ValueNotifier<bool>(true);
  int _page = 0;

  @override
  onReady(){
    queryFriendCircle(refresh: true);
  }

  queryFriendCircle({bool refresh = false}){
    lcPost(() async {
      var lcQuery = LCQuery(Constant.OBJECT_NAME_FRIEND_CIRCLE);
      lcQuery.limit(Constant.PAGE_SIZE);
      lcQuery.skip(refresh?0:Constant.PAGE_SIZE * _page);
      lcQuery.orderByDescending('createdAt');
      lcQuery.include('user');
      List<LCObject>? find = await lcQuery.find(cachePolicy: CachePolicy.networkElseCache);
      if(refresh){
        list.clear();
      }
      list.addAll(find??[]);
      if(refresh){
        _page = 1;
      }else{
        _page ++ ;
      }
    },showloading: false);
  }

  void deleteFriendCircle(LCObject lcObject) {
    lcPost(() async {
      await lcObject.delete();
      list.remove(lcObject);
    });
  }

}