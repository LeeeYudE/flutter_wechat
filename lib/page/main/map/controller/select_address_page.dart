import 'package:wechat/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:get/get.dart';

import 'base_map_controller.dart';

class SelectAddressController extends BaseMapController with GetSingleTickerProviderStateMixin {

  BMFMapController? dituController;

  GlobalKey mapKey = GlobalKey();
  //动画控制器
  late AnimationController sliderController;
  late Animation<Offset> sliderAnimation;

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
      debugPrint('mapDidLoad-setMapStatusDidChangedCallback!!!');
      sliderController.reverse();
      _centerPoint();
    });
  }

  _centerPoint() async {
    var centerOffset = mapKey.centerOffset();
    if(centerOffset != null){
      var bmfCoordinate = await dituController?.convertScreenPointToCoordinate(BMFPoint(centerOffset.dx,centerOffset.dy));
      if(bmfCoordinate != null){

        BMFReverseGeoCodeSearchOption reverseGeoCodeSearchOption = BMFReverseGeoCodeSearchOption(location: bmfCoordinate);
        // 检索实例
        BMFReverseGeoCodeSearch reverseGeoCodeSearch = BMFReverseGeoCodeSearch();
        // 逆地理编码回调
        reverseGeoCodeSearch.onGetReverseGeoCodeSearchResult(callback: (BMFReverseGeoCodeSearchResult result, BMFSearchErrorCode errorCode) {
          debugPrint('onGetReverseGeoCodeSearchResult $errorCode ${result.toMap().toString()}');
        });
        // 发起检索
        bool flag = await reverseGeoCodeSearch.reverseGeoCodeSearch(reverseGeoCodeSearchOption);
      }
    }

  }



}