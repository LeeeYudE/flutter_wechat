import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:get/get.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/base_scaffold.dart';

import '../../../base/base_view.dart';
import '../../../color/colors.dart';
import '../../../language/strings.dart';
import '../../../utils/map_util.dart';
import '../../../widget/tap_widget.dart';
import 'controller/base_map_controller.dart';

class PreviewLocationPage extends BaseGetBuilder<BaseMapController> {

  static const String routeName='/PreviewLocationPage';

  late BMFCoordinate _coordinate;

  PreviewLocationPage({Key? key}) : super(key: key);

  @override
  void onInit() {
    _coordinate = Get.arguments;
    super.onInit();
  }

  @override
  BaseMapController? getController() => BaseMapController();

  @override
  Widget controllerBuilder(BuildContext context, BaseMapController controller) {
    return MyScaffold(
      title: Ids.location.str(),
      body: Column(
        children: [
          Expanded(child: Stack(
            children: [
              (Platform.isAndroid)?
              BMFTextureMapWidget(
                  onBMFMapCreated: (_controller) {
                    controller.onBMFMapCreated(_controller);
                    controller.addMarker(position: _coordinate, icon: Utils.getIconImgPath('icon_slider_location'));
                  },
                  mapOptions: controller.initMapOptions(center: _coordinate),
                )
              : BMFMapWidget(
                  onBMFMapCreated: (_controller) {
                    controller.onBMFMapCreated(_controller);
                    controller.addMarker(position: _coordinate, icon: Utils.getIconImgPath('icon_slider_location'));
                  },
                  mapOptions: controller.initMapOptions(center: _coordinate),
                ),
              _buildMyLocation(context,controller),
            ],
          )),
          Container(
            color: Colours.c_EEEEEE,
            height: 140.w,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(Ids.location.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),),
                TapWidget(onTap: () {
                  MapUtil.showDirections(_coordinate.longitude, _coordinate.latitude);
                },
                child: Image.asset(Utils.getImgPath('ic_navigation',dir: Utils.DIR_ICON),width: 80.w,height: 80.w,))
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildMyLocation(BuildContext context, BaseMapController controller){
    return Align(alignment: Alignment.bottomRight,
      child: TapWidget(
        onTap: () {
          controller.backMyLocation();
        },
        child: Container(
          margin: EdgeInsets.all(40.w),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: Colours.white.boxDecoration(borderRadius: 50.w),
            child: const Icon(Icons.my_location,color: Colours.black,),
          ),
        ),
      ),);
  }

}
