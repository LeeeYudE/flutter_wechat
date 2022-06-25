import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';

import '../base/constant.dart';

extension DituExt on BMFMapController {

  updateBaiduLocation(BaiduLocation? location){
    if(location != null) {
      setNewLatLngZoom(zoom: Constant.MAP_ZOOM, coordinate: BMFCoordinate(location.latitude!, location.longitude!),animateDurationMs: 500);
    }
  }

}