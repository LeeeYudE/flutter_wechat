import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/cache_image_widget.dart';
import 'package:wechat/widget/remove_top_widget.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'dart:math' as math ;
import '../../../../language/strings.dart';
import '../../../../utils/dialog_util.dart';
import '../../../../utils/navigator_utils.dart';
import '../../../../widget/scale_size_image_widget.dart';
import '../../../../widget/scale_size_video_widget.dart';
import '../../../util/photo_preview_page.dart';
import '../controller/friend_circle_controller.dart';

class FriendCircleItem extends StatelessWidget {

  LCObject lcObject;
  FriendCircleController controller;

   FriendCircleItem({required this.lcObject,required this.controller,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical:20.w ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWidget(avatar: lcObject['user']['avatar'], weightWidth: 100.w),
          20.sizedBoxW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(lcObject['user']['nickname'],style: TextStyle(color: Colours.c_5B6B8D,fontSize: 32.sp),maxLines: 1,),
                10.sizedBoxH,
                if(!TextUtil.isEmpty(lcObject['text']))
                  SizedBox(
                      width: Get.width-200.w,
                      child: ExpandableText(
                        lcObject['text'],
                        expandText: Ids.full_text.str(),
                        collapseText: Ids.expandable_text.str(),
                        maxLines: 4,
                        linkColor: Colours.c_5B6B8D,
                      )),
                20.sizedBoxH,
                if(lcObject['mediaType'] == 1)
                  _buildImage(),
                if(lcObject['mediaType'] == 2)
                  _buildVideo(),
                20.sizedBoxH,
                _buildFooder(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooder(BuildContext context){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text((lcObject.createdAt!.millisecondsSinceEpoch).commonDateTime(showTime: true),style: TextStyle(color: Colours.c_999999,fontSize: 24.sp,height: 1.1),),
        10.sizedBoxW,
        if(lcObject['user']['username'] == UserController.instance.username)
          TapWidget(onTap: () async {
           var result = await DialogUtil.showConfimDialog(context, Ids.delete.str());
           if(result??false){
             controller.deleteFriendCircle(lcObject);
           }
          },
          child: Text(Ids.delete.str(),style: TextStyle(color: Colours.c_5B6B8D,fontSize: 24.sp,height: 1.1),)),
        const Spacer(),
        CustomPopupMenu(
          pressType: PressType.singleClick,
          showArrow: false,
          horizontalMargin: 90.w,
          verticalMargin: -40.w,
          barrierColor: Colours.transparent,
          menuBuilder: () {
            return Container(
              width: 240.w,
              height: 60.w,
              decoration: Colours.black.boxDecoration(),
              child: Row(
                children: [
                  Expanded(child: Row(
                    children: [
                      Icon(Icons.favorite_border,color: Colours.white,size: 24.sp),
                      10.sizedBoxW,
                      Text(Ids.like.str(),style: TextStyle(color: Colours.white,fontSize: 24.sp),)
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),),
                  Expanded(child: Row(
                    children: [
                      Icon(Icons.comment_sharp,color: Colours.white,size: 24.sp,),
                      10.sizedBoxW,
                      Text(Ids.comment.str(),style: TextStyle(color: Colours.white,fontSize: 24.sp),)
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),),
                ],
              ),
            );
          },
          child: Container(width: 60.w,height: 25.w,decoration: Colours.c_EEEEEE.boxDecoration(borderRadius: 4.w),child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 10.w,height: 10.w,decoration: Colours.c_5B6B8D.boxDecoration(borderRadius: 10.w),),
                10.sizedBoxW,
                Container(width: 10.w,height: 10.w,decoration: Colours.c_5B6B8D.boxDecoration(borderRadius: 10.w),),
              ],
            ),
          ),),
        )
      ],
    );
  }

  Widget _buildImage(){
    List<dynamic> photos = lcObject['photos'];

    if(photos.isEmpty){
      return Container();
    }

    if(photos.length == 1){
      var photo = photos.first;
      return ScaleSizeImageWidget(photoHeight: photo['height'].toDouble(), photoUrl: photo['url'], photoWidth: photo['width'].toDouble(),);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double layoutWidth = constraints.maxWidth;
        int crossCount = ((photos.length / 3) + 1).toInt();
        double layoutHeight = layoutWidth * (math.min(crossCount,3)/3);
        return SizedBox(
          height: layoutHeight,
          width: layoutWidth,
          child: RemoveTopPaddingWidget(
            child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20.w,
              crossAxisSpacing: 20.w,
              childAspectRatio: 1,
            ), itemBuilder: (context , index){
              String url = photos[index]['url'];
              return TapWidget(onTap: () {
                NavigatorUtils.toNamed(PhotoPreviewPage.routeName,arguments: PhotoPreviewArguments(heroTag: url,url: url));
              },
                  child: CacheImageWidget(url: url, weightWidth: 0, weightHeight: 0,hero: true,));
            },itemCount: photos.length,physics: const NeverScrollableScrollPhysics(),),
          ),
        );
      },
    );
  }

  Widget _buildVideo(){
    return ScaleSizeVideoWidget(photoWidth: lcObject['thumbnail']['width'].toDouble(),videoUrl: lcObject['video']['url'], photoHeight: lcObject['thumbnail']['height'].toDouble(), photoUrl: lcObject['thumbnail']['url'],);
  }

}
