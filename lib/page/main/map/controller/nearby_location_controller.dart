
import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:wechat/base/base_getx.dart';

import '../../../../base/constant.dart';
import 'base_map_controller.dart';

class NearbyLocationController extends BaseMapController{

  BMFPoiInfo? selectPoi;
  List<BMFPoiInfo> poiList = <BMFPoiInfo>[];

  @override
  void onReady() {
    super.onReady();
    initLocation();
  }

  @override
  onLocationResult(BaiduLocation result) async {
    // 构造检索参数
    if(state == ViewState.Busy){
      return;
    }
    BMFPoiNearbySearchOption poiNearbySearchOption =
    BMFPoiNearbySearchOption(keywords: <String>['银行','酒店','餐饮','商场'], location: BMFCoordinate(22.613863,114.039066), radius: 10000, isRadiusLimit: false,pageSize: Constant.PAGE_SIZE);
    BMFPoiNearbySearch nearbySearch = BMFPoiNearbySearch();
    nearbySearch.onGetPoiNearbySearchResult(callback: (BMFPoiSearchResult result, BMFSearchErrorCode errorCode) {
      debugPrint('poi周边检索回调 errorCode = $errorCode  \n result = ${result.poiInfoList?.length}');
      if(errorCode == BMFSearchErrorCode.NO_ERROR){
        poiList.clear();
        poiList.addAll(result.poiInfoList??[]);
        setIdleState();
      }else{
        setErrorState();
      }
    });
    // 发起检索
    bool flag = await nearbySearch.poiNearbySearch(poiNearbySearchOption);
    debugPrint('poiNearbySearch $flag');
    setBusyState();
  }

}