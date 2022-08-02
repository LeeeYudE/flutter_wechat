import 'package:wechat/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:get/get.dart';

import '../../../../base/base_getx.dart';
import '../../../../base/constant.dart';
import '../../../../language/strings.dart';
import 'base_map_controller.dart';

class SelectLocationController extends BaseMapController with GetSingleTickerProviderStateMixin {

  BMFMapController? dituController;

  GlobalKey mapKey = GlobalKey();
  //动画控制器
  late AnimationController sliderController;
  late Animation<Offset> sliderAnimation;
  List<BMFPoiInfo> poiList = <BMFPoiInfo>[];
  BMFPoiInfo? selectPoi;
  bool _selectingPoi = false;

  @override
  void onInit() {
    sliderController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    sliderAnimation = Tween(begin: Offset.zero, end: const Offset(0, -0.3)).animate(sliderController);
    super.onInit();
  }

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    super.onBMFMapCreated(controller);
    dituController?.setMapRegionWillChangeCallback(callback: (BMFMapStatus status){
      debugPrint('mapDidLoad-setMapRegionWillChangeCallback!!! $status');
      sliderController.forward();
    });
    dituController?.setMapStatusDidChangedCallback(callback: () {
      debugPrint('mapDidLoad-setMapStatusDidChangedCallback!!! $_selectingPoi');
      if(_selectingPoi){
        _selectingPoi = false;
        return;
      }
      sliderController.reverse();
      // _centerPoint();
      poiNearbySearch();
    });
  }

  selectedPoi(BMFPoiInfo poi){
    selectPoi = poi;
    update();
    if(poi.pt != null){
      _selectingPoi = true;
      moveToLocation(poi.pt!);
    }
  }

  poiNearbySearch() async {
    // 构造检索参数
    if(state == ViewState.Busy){
      return;
    }
    var centerOffset = mapKey.centerOffset();
    if(centerOffset != null){
      var bmfCoordinate = await dituController?.convertScreenPointToCoordinate(BMFPoint(centerOffset.dx,centerOffset.dy));
      BMFPoiNearbySearchOption poiNearbySearchOption =
      BMFPoiNearbySearchOption(keywords: <String>['银行','酒店','餐饮','商场'], location: BMFCoordinate(22.613863,114.039066), radius: 10000, isRadiusLimit: false,pageSize: Constant.PAGE_SIZE);
      BMFPoiNearbySearch nearbySearch = BMFPoiNearbySearch();
      nearbySearch.onGetPoiNearbySearchResult(callback: (BMFPoiSearchResult result, BMFSearchErrorCode errorCode) {
        debugPrint('poi周边检索回调 errorCode = $errorCode  \n result = ${result.toMap()}');
        if(errorCode == BMFSearchErrorCode.NO_ERROR){
          var bmfPoiInfo = BMFPoiInfo.fromMap({
            'name':Ids.location.str(),
            'pt':bmfCoordinate?.toMap()
          });
          selectPoi = bmfPoiInfo;
          poiList.clear();
          poiList.add(bmfPoiInfo);
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

  // _centerPoint() async {
  //   var centerOffset = mapKey.centerOffset();
  //   if(centerOffset != null){
  //     var bmfCoordinate = await dituController?.convertScreenPointToCoordinate(BMFPoint(centerOffset.dx,centerOffset.dy));
  //     if(bmfCoordinate != null){
  //
  //       BMFReverseGeoCodeSearchOption reverseGeoCodeSearchOption = BMFReverseGeoCodeSearchOption(location: bmfCoordinate);
  //       // 检索实例
  //       BMFReverseGeoCodeSearch reverseGeoCodeSearch = BMFReverseGeoCodeSearch();
  //       // 逆地理编码回调
  //       reverseGeoCodeSearch.onGetReverseGeoCodeSearchResult(callback: (BMFReverseGeoCodeSearchResult result, BMFSearchErrorCode errorCode) {
  //         debugPrint('onGetReverseGeoCodeSearchResult $errorCode ${result.toMap().toString()}');
  //       });
  //       // 发起检索
  //       bool flag = await reverseGeoCodeSearch.reverseGeoCodeSearch(reverseGeoCodeSearchOption);
  //     }
  //   }
  //
  // }



}