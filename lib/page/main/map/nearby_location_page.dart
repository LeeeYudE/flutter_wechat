import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/base/common_state_widget_x.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/remove_top_widget.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../language/strings.dart';
import 'controller/nearby_location_controller.dart';

class NearbyLocationPage extends BaseGetBuilder<NearbyLocationController> {

  static const String routeName='/NearbyLocationPage';
  int? _selectIndex;

  NearbyLocationPage({Key? key}) : super(key: key);


  @override
  NearbyLocationController? getController()  => NearbyLocationController();

  @override
  Widget controllerBuilder(BuildContext context, NearbyLocationController controller) {
    return MyScaffold(
      title: Ids.the_location.str(),
      body: _buildBody(context),
      actions: [
        CommonBtn(text: Ids.confirm.str(), onTap: (){
          if(_selectIndex == 0){
            NavigatorUtils.pop('remove');
          }else{
            NavigatorUtils.pop(controller.poiList[_selectIndex! - 1]);
          }
        },enable: _selectIndex != null,)
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return CommonStateWidgetX(
      controller: controller,
      widgetBuilder: (BuildContext context) {
        return Container(
          color: Colours.white,
          child: RemoveTopPaddingWidget(child: ListView.builder(itemBuilder: (context , index){
            if(index == 0){
             return _buildNoLocation();
           }
            return _buildAddress(controller.poiList[index-1],index);
          },itemCount: controller.poiList.length + 1,),),
        );
      },
    );
  }

  Widget _buildNoLocation(){
    return TapWidget(
      onTap: () {
        _selectIndex = 0;
        update();
      },
      child: Container(
        height: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: Colours.c_EEEEEE.bottomBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(Ids.no_show_location.str(),style: TextStyle(color: Colours.c_5B6B8D,fontSize: 32.sp),),
            Opacity(opacity: _selectIndex == 0 ? 1 : 0,
            child: const Icon(Icons.radio_button_checked_outlined,color: Colours.theme_color,))
          ],
        ),
      ),
    );
  }

  Widget _buildAddress(BMFPoiInfo poiInfo ,int index ){
    return TapWidget(
      onTap: () {
        _selectIndex = index;
        update();
      },
      child: Container(
        height: 120.w,
        decoration: Colours.c_EEEEEE.bottomBorder(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(poiInfo.name??'',style: TextStyle(color: Colours.black,fontSize: 32.sp),maxLines: 1,overflow: TextOverflow.clip,),
                Text(poiInfo.address??'',style: TextStyle(color: Colours.c_999999,fontSize: 24.sp),maxLines: 1,overflow: TextOverflow.clip),
              ],
            )),
            20.sizedBoxW,
            Opacity(opacity: _selectIndex == index ? 1 : 0,
            child: const Icon(Icons.radio_button_checked_outlined,color: Colours.theme_color,))
          ],
        ),
      ),
    );
  }



}
