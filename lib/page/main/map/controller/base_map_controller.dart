
import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat/core.dart';
import '../../../../base/base_getx.dart';
import '../../../../base/constant.dart';
import '../../../../language/strings.dart';


class BaseMapController extends BaseXController {

  BMFMapController? dituController;

  LocationFlutterPlugin myLocPlugin = LocationFlutterPlugin();
  BaiduLocation? _lastLocation;
  BMFCoordinate? _coordinateCenter;

  @override
  void onReady() {
    super.onReady();

  }

  _init() async {
    myLocPlugin.setAgreePrivacy(true);
    BMFMapSDK.setAgreePrivacy(true);
    requestPermission();
  }

  requestPermission() async {
    Map iosMap = initIOSOptions().getMap();
    Map androidMap = initAndroidOptions().getMap();
    await myLocPlugin.prepareLoc(androidMap, iosMap);
    var status = await Permission.location.request();
    if (status.isGranted) {
      //接受定位回调
      if(Platform.isAndroid){
        myLocPlugin.seriesLocationCallback(callback:_onBaiduLocationResult);
        var bool = await myLocPlugin.startLocation();
        debugPrint("startLocation $bool");
      }else{
        myLocPlugin.singleLocationCallback(callback:_onBaiduLocationResult);
        var bool = await myLocPlugin.singleLocation({'isReGeocode': true, 'isNetworkState': true});
        debugPrint("singleLocation $bool");
      }
    }else{
      Ids.no_permission.str().toast();
    }
  }

  _onBaiduLocationResult(BaiduLocation result) async {
    print('BaiduLocation ${result.getMap().toString()}');
    if(_lastLocation == null && _coordinateCenter == null){
      dituController?.updateBaiduLocation(result);
    }
    _lastLocation = result;
    SpUtil.putString(Constant.SP_LAST_LOCATION, "${result.latitude},${result.longitude}");

    BMFLocation location = BMFLocation(
        coordinate: BMFCoordinate(result.latitude!, result.longitude!),
        altitude: result.altitude,
        horizontalAccuracy: result.horizontalAccuracy,
        verticalAccuracy: result.verticalAccuracy,
        speed: result.speed,
        course: result.course);

    BMFUserLocation userLocation = BMFUserLocation(location: location,);

    dituController?.updateLocationData(userLocation);
    myLocPlugin.stopLocation();
  }


  BaiduLocationAndroidOption initAndroidOptions() {
    BaiduLocationAndroidOption options =
    BaiduLocationAndroidOption(
        locationMode: BMFLocationMode.hightAccuracy,// 定位模式，可选的模式有高精度、仅设备、仅网络。默认为高精度模式
        isNeedAddress: true,// 是否需要返回地址信息
        isNeedAltitude: false,// 是否需要返回海拔高度信息
        isNeedLocationPoiList: false,// 是否需要返回周边poi信息
        isNeedNewVersionRgc: false,// 是否需要返回新版本rgc信息
        isNeedLocationDescribe: true,// 是否需要返回位置描述信息
        openGps: true,// 是否使用gps
        locationPurpose: BMFLocationPurpose.signIn,// 可选，设置场景定位参数，包括签到场景、运动场景、出行场景
        coordType: BMFLocationCoordType.bd09ll,
        scanspan: 0);// 如果设置为0，则代表单次定位，即仅定位一次，默认为0
    return options;
  }

  BaiduLocationIOSOption initIOSOptions() {
    BaiduLocationIOSOption options =
    BaiduLocationIOSOption(
      coordType: BMFLocationCoordType.bd09ll,// 坐标系
      locationTimeout: 10,// 位置获取超时时间
      reGeocodeTimeout: 10,// 获取地址信息超时时间
      activityType: BMFActivityType.automotiveNavigation,// 应用位置类型 默认为automotiveNavigation
      desiredAccuracy: BMFDesiredAccuracy.best,// 设置预期精度参数 默认为best
      isNeedNewVersionRgc: true,// 是否需要最新版本rgc数据
      pausesLocationUpdatesAutomatically: false,// 指定定位是否会被系统自动暂停
      allowsBackgroundLocationUpdates: false,//指定是否允许后台定位,允许的话是可以进行后台定位的，但需要项目配置允许后台定位，否则会报错，具体参考开发文档
      distanceFilter: 10,);// 设定定位的最小更新距离
    return options;
  }

  void backMyLocation() {
    dituController?.updateBaiduLocation(_lastLocation);
  }

  void moveToLocation(BMFCoordinate coordinate) {
    dituController?.updateBaiduBMFCoordinate(coordinate);
  }

  /// 创建完成回调
  @mustCallSuper
  void onBMFMapCreated(BMFMapController controller) async {
    dituController = controller;
    /// 地图加载回调
    dituController?.setMapDidLoadCallback(callback: () async {
      debugPrint('mapDidLoad-地图加载完成!!!');
      var showUserLocation = await dituController?.showUserLocation(true);
      debugPrint('showUserLocation $showUserLocation');
      _init();
    });
  }

  /// 设置地图参数
  BMFMapOptions initMapOptions({BMFCoordinate? center}) {
    _coordinateCenter = center;
    if(center == null){
      String? _loaction = SpUtil.getString(Constant.SP_LAST_LOCATION, defValue: null);
      double lat = 39.917215;
      double lng = 116.380341;
      if(_loaction != null){
        var split = _loaction.split(',');
        lat = double.parse(split[0]);
        lng = double.parse(split[1]);
      }
      center = BMFCoordinate(lat,lng);
    }
    BMFMapOptions mapOptions = BMFMapOptions(
      center: center,
      zoomLevel: Constant.MAP_ZOOM.toInt(),
      changeCenterWithDoubleTouchPointEnabled:true,
      gesturesEnabled:true ,
      scrollEnabled:true ,
      zoomEnabled: true ,
      rotateEnabled :true,
      showZoomControl: false,
      compassPosition :BMFPoint(0,0) ,
      showMapScaleBar:false ,
    );
    return mapOptions;
  }

  addMarker({required BMFCoordinate position,
    required String icon,
  }){
    /// 创建BMFMarker
    var bmfMarker = BMFMarker.icon(position: position, icon: icon);
    /// 添加Marker
    dituController?.addMarker(bmfMarker);
  }

}