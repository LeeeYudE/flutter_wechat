import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/page/main/discover/page/channels/channels_preview_page.dart';
import 'package:wechat/page/main/discover/page/channels/channels_select_cover_page.dart';
import 'package:wechat/page/util/video_perview_page.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/input_field.dart';
import 'package:wechat/widget/scale_size_image_widget.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../../../language/strings.dart';
import '../../../../../utils/dialog_util.dart';
import '../../../../../utils/navigator_utils.dart';
import '../../../map/nearby_location_page.dart';
import 'channels_video_edit_page.dart';
import 'controller/channels_create_controller.dart';

class ChannelsCreatePage extends BaseGetBuilder<ChannelsCreateController> {

  static const String routeName = '/ChannelsCreatePage';

  ChannelsCreatePage({Key? key}) : super(key: key);

  @override
  ChannelsCreateController? getController() => ChannelsCreateController();

  @override
  Widget controllerBuilder(BuildContext context, ChannelsCreateController controller) {
    return MyScaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colours.white,
        appbarColor: Colours.white,
        body: _buildBody(context),
        actions: [
          CommonBtn(text: Ids.published.str(), onTap: (){
            controller.publishChannles();
          },enable: controller.videoFile != null,)
        ],);
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 40.w,left: 40.w,right: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUser(),
            20.sizedBoxH,
            _buildCover(context),
            if(controller.videoFile != null)
              _buildSelectCover(),
            _buildDescribe(),
            _buildLocation(),
          ],
        ),
      ),
    );
  }

  Widget _buildUser(){
    return Row(
      children: [
        AvatarWidget(avatar: UserController.instance.user?.avatar, weightWidth: 50.w,circle: true,),
        10.sizedBoxW,
        Text(UserController.instance.user?.nickname??'',style: TextStyle(color: Colours.black,fontSize: 32.sp),)
      ],
    );
  }

  Widget _buildCover(BuildContext context){
    if(controller.coverFile != null){
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
              margin: EdgeInsets.only(top: 20.w,right: 20.w),
              child: TapWidget(onTap: () {
                var lcObject = LCObject(Constant.OBJECT_NAME_CHANNLES);
                lcObject['user'] = UserController.instance.user;
                lcObject['video'] = {'url':controller.videoFile?.path};
                NavigatorUtils.toNamed(ChannelsPreviewPage.routeName,arguments: lcObject);
              },
              child: ScaleSizeImageWidget(photoWidth: controller.coverSize?.width.toDouble()??0, photoHeight: controller.coverSize?.height.toDouble()??0, photoUrl: controller.coverFile!.path,tapDetail: false,))),
          TapWidget(
            onTap: () {
              controller.deleteVideo();
            },
            child: Container(
                decoration: Colours.c_EEEEEE.boxDecoration(borderRadius: 50.w),
                padding: EdgeInsets.all(5.w),
                child: Icon(Icons.close,color: Colours.black,size: 30.w,)),
          )
        ],
      );
    }else{
      return TapWidget(
        onTap: () async {
          var file = await DialogUtil.choosePhotoDialog(context,isVideo: true);
          if(file != null){
            var _video = await NavigatorUtils.toNamed(ChannelsVideoEditPage.routeName,arguments: file);
            if(_video != null){
              controller.selectVideo(_video);
            }
          }
        },
        child: Container(
          width: 300.w,
          height: 450.w,
          color: Colours.c_EEEEEE,
          child: Center(
            child: Icon(Icons.add,size: 80.w,color: Colours.black,),
          ),
        ),
      );
    }
  }

  _buildSelectCover(){
    return Container(
      margin: EdgeInsets.only(top: 20.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
      decoration: Colours.c_EEEEEE.boxDecoration(),
      child: TapWidget(
        onTap: () async {
         var cover = await NavigatorUtils.toNamed(ChannelsSelectCoverPage.routeName,arguments: controller.videoFile);
         if(cover != null){
           controller.updateCover(cover);
         }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_library_outlined,color: Colours.black,),
            5.sizedBoxW,
            Text(Ids.select_cover.str(),style: TextStyle(color: Colours.black,fontSize: 28.sp),)
          ],
        ),
      ),
    );
  }

  _buildDescribe(){
    return Container(
      margin: EdgeInsets.only(top: 40.w),
      decoration: Colours.c_EEEEEE.boxDecoration(),
      height: 300.w,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: InputField(
            controller: controller.textEditingController,
            autofocus: false,
            crossAxisAlignment:CrossAxisAlignment.start,
            showDecoration: false,
            showTopic: true,
            extended: true,
            hint: Ids.add_describe.str(),
          )),
          Container(
            margin: EdgeInsets.only(top: 20.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
            decoration: Colours.c_F7F7F7.boxDecoration(),
            child: TapWidget(
              onTap: () async {

              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('#${Ids.topic.str()}',style: TextStyle(color: Colours.black,fontSize: 28.sp),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLocation(){

    var _poiInfo = controller.poiInfo;
    return Container(
      margin: EdgeInsets.only(top: 20.w),
      padding: EdgeInsets.only(left: 20.w),
      height: 100.w,
      decoration: Colours.c_EEEEEE.boxDecoration(),
      child: TapWidget(
        onTap: () async {
          var result = await NavigatorUtils.toNamed(NearbyLocationPage.routeName);
          if('remove' == result){
          }else if(result != null){
            controller.updatePoiInfo(result);
          }
        },
        child: Row(
          children: [
            Icon(Icons.location_on_outlined,color: _poiInfo == null ? Colours.black:Colours.theme_color,),
            20.sizedBoxW,
            Text(_poiInfo == null ? Ids.the_location.str():_poiInfo.city??'',style: TextStyle(color:_poiInfo== null ?  Colours.black : Colours.theme_color,fontSize: 28.sp),),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_right,color: Colours.c_CCCCCC,)
          ],
        ),
      ),
    );
  }

}
