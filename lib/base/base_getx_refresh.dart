import 'package:wechat/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/utils/dialog_util.dart';

import 'base_getx.dart';
import 'constant.dart';

typedef OnQueryList = Future Function(List<LCObject> list);

///Controller
abstract class BaseXRefreshController extends BaseXController {

  int _page = 0;
  RxList<LCObject> list = <LCObject>[].obs;
  bool canLoad = true;

  Future<bool> queryList(LCQuery query,{bool refresh = false,OnQueryList? onQueryList}){
   return lcPost(() async {
      var lcQuery = query;
      lcQuery.limit(Constant.PAGE_SIZE);
      lcQuery.skip(refresh?0:Constant.PAGE_SIZE * _page);
      List<LCObject> find = await lcQuery.find(cachePolicy: CachePolicy.networkElseCache)??[];
      canLoad = find.length >= Constant.PAGE_SIZE;
      if(refresh){
        list.clear();
      }
      await onQueryList?.call(find);
      list.addAll(find);
      if(refresh){
        _page = 1;
      }else{
        _page ++ ;
      }
    },showloading: false,updated: false,changeState: list.isEmpty);
  }


}

