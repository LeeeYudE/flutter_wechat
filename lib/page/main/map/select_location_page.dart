import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:wechat/base/common_state_widget_x.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/remove_top_widget.dart';
import '../../../base/base_view.dart';
import '../../../color/colors.dart';
import '../../../language/strings.dart';
import '../../../widget/tap_widget.dart';
import 'controller/select_address_page.dart';
import 'package:wechat/core.dart';

class SelectLocationPage extends BaseGetBuilder<SelectLocationController> {

  static const String routeName='/SelectAddressPage';

  final DraggableScrollableController _draggableScrollableController = DraggableScrollableController();

  SelectLocationPage({Key? key}) : super(key: key);

  @override
  SelectLocationController? getController() => SelectLocationController();

  @override
  Widget controllerBuilder(BuildContext context, SelectLocationController controller) {
    return Scaffold(
      body: _buildBody(context,controller),
    );
  }

  _buildBody(BuildContext context, SelectLocationController controller){
    return Stack(
      children: [
        Container(
          height: double.infinity,
          margin: EdgeInsets.only(bottom: 480.w),
          child: Stack(
            children: [
              BMFMapWidget(
                key: controller.mapKey,
                onBMFMapCreated: (_controller) {
                  controller.onBMFMapCreated(_controller);
                },
                mapOptions: controller.initMapOptions(),
              ),
              _buildHeader(),
              buildSlideTransition(context,controller),
              _buildMyLocation(context,controller),
            ],
          ),
        ),
        _buildBottomAddress(context)
      ],
    );
  }

  _buildBottomAddress(BuildContext context){
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 800.w,
        child: NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification){
            debugPrint('####################');
            debugPrint('minExtent = ${notification.minExtent}');
            debugPrint('maxExtent = ${notification.maxExtent}');
            debugPrint('initialExtent = ${notification.initialExtent}');
            debugPrint('extent = ${notification.extent}');
            debugPrint('####################');
            return true;
          },
          child: DraggableScrollableSheet(builder: (BuildContext context, ScrollController scrollController) {
            return CommonStateWidgetX(
              controller: controller,
              widgetBuilder: (BuildContext context) {
                return RemoveTopPaddingWidget(
                  child: ListView.builder(itemBuilder: (context , index){
                    var poi = controller.poiList[index];
                    return TapWidget(
                      onTap: () {
                        controller.selectedPoi(poi);
                      },
                      child: Container(
                        height: 100.w,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        color: Colours.white,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(poi.name??'',style: TextStyle(color: Colours.black,fontSize: 32.sp),),
                            if(poi == controller.selectPoi)
                            Image.asset(Utils.getImgPath('ic_selected',dir: Utils.DIR_ICON),width: 40.w,height: 40.w,)
                          ],
                        ),
                      ),
                    );
                  },itemCount: controller.poiList.length,controller: scrollController,),
                );
              },
            );
          }, initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 1.0,
            controller: _draggableScrollableController,),
        ),
      ),
    );
  }

  _buildHeader(){
    return Container(
      height: 250.w,
      padding: EdgeInsets.only(top: 100.w,left: 20.w,right: 20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colours.black_transparent,Colours.transparent]
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TapWidget(onTap: () {
            NavigatorUtils.pop();
          },
          child: Text(Ids.cancel.str(),style: TextStyle(color: Colours.white,fontSize: 32.sp),)),
          CommonBtn(text: Ids.send.str(), width: 120.w, height: 60.w, onTap: (){
            if(controller.selectPoi != null){
              NavigatorUtils.pop(controller.selectPoi);
            }
          })
        ],
      ),
    );
  }

  Widget buildSlideTransition(BuildContext context, SelectLocationController controller) {
    return Center(//SlideTransition 用于执行平移动画
      child: SlideTransition(
        position: controller.sliderAnimation, //将要执行动画的子view
        child: Image.asset(Utils.getIconImgPath('icon_slider_location'),width: 80.w,height: 80.w,),
      ),
    );
  }

  _buildMyLocation(BuildContext context, SelectLocationController controller){
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
