import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/page/main/contacts/friend_detail_page.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../../language/strings.dart';
import '../../../../utils/dialog_util.dart';
import '../../../../utils/navigator_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/friend_circle_grid_view.dart';
import '../../../../widget/scale_size_image_widget.dart';
import '../../../../widget/scale_size_video_widget.dart';
import '../../map/preview_loctaion_page.dart';
import '../controller/friend_circle_controller.dart';
import 'friend_circle_comment_dialog.dart';

class FriendCircleItem extends StatefulWidget {

  LCObject lcObject;
  FriendCircleController controller;


  FriendCircleItem({required this.lcObject, required this.controller, Key? key}) : super(key: key);

  @override
  State<FriendCircleItem> createState() => _FriendCircleItemState();
}

class _FriendCircleItemState extends State<FriendCircleItem> {
  final CustomPopupMenuController _customPopupMenuController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarWidget(avatar: widget.lcObject['user']['avatar'], weightWidth: 100.w),
          20.sizedBoxW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.lcObject['user']['nickname'], style: TextStyle(color: Colours.c_5B6B8D, fontSize: 32.sp),
                  maxLines: 1,),
                10.sizedBoxH,
                if(!TextUtil.isEmpty(widget.lcObject['text']))
                  SizedBox(
                      width: Get.width - 200.w,
                      child: ExpandableText(
                        widget.lcObject['text'],
                        expandText: Ids.full_text.str(),
                        collapseText: Ids.expandable_text.str(),
                        maxLines: 4,
                        linkColor: Colours.c_5B6B8D,
                      )),
                _buildLocation(),
                20.sizedBoxH,
                if(widget.lcObject['mediaType'] == 1)
                  _buildImage(),
                if(widget.lcObject['mediaType'] == 2)
                  _buildVideo(),
                20.sizedBoxH,
                _buildFooder(context),
                20.sizedBoxH,
                _buildLiked(),
                _buildComment(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooder(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text((widget.lcObject.createdAt!.millisecondsSinceEpoch).commonDateTime(showTime: true),
          style: TextStyle(color: Colours.c_999999, fontSize: 24.sp, height: 1.1),),
        10.sizedBoxW,
        if(widget.lcObject['user']['username'] == UserController.instance.username)
          TapWidget(onTap: () async {
            var result = await DialogUtil.showConfimDialog(context, Ids.delete.str());
            if (result ?? false) {
              widget.controller.deleteFriendCircle(widget.lcObject);
            }
          },
              child: Text(Ids.delete.str(), style: TextStyle(color: Colours.c_5B6B8D, fontSize: 24.sp, height: 1.1),)),
        const Spacer(),
        CustomPopupMenu(
          controller: _customPopupMenuController,
          pressType: PressType.singleClick,
          showArrow: false,
          horizontalMargin: 90.w,
          verticalMargin: -40.w,
          barrierColor: Colours.transparent,
          menuBuilder: () {
            List liked = widget.lcObject['liked'] ?? [];
            bool _liked = liked.hasIndex((element) => element['username'] == UserController.instance.username);
            return Container(
              width: 240.w,
              height: 60.w,
              decoration: Colours.black.boxDecoration(),
              child: Row(
                children: [
                  Expanded(child: TapWidget(
                    onTap: () async {
                      _customPopupMenuController.hideMenu();
                      await widget.controller.likeFriendCircle(widget.lcObject);
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Icon(Icons.favorite_border, color: Colours.white, size: 24.sp),
                        10.sizedBoxW,
                        Text(_liked ? Ids.cancel.str() : Ids.like.str(), style: TextStyle(
                            color: Colours.white, fontSize: 24.sp),)
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),),
                  Expanded(child: TapWidget(
                    onTap: () async {
                      _customPopupMenuController.hideMenu();
                     String? comment = await NavigatorUtils.toBottomPage(const FriendCircleCommentDialog());
                     if(comment != null){
                       await widget.controller.comment(widget.lcObject,comment);
                       setState(() {});
                     }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.comment_sharp, color: Colours.white, size: 24.sp,),
                        10.sizedBoxW,
                        Text(Ids.comment.str(), style: TextStyle(color: Colours.white, fontSize: 24.sp),)
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),),
                ],
              ),
            );
          },
          child: Container(
            width: 60.w, height: 25.w, decoration: Colours.c_EEEEEE.boxDecoration(borderRadius: 4.w), child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 10.w, height: 10.w, decoration: Colours.c_5B6B8D.boxDecoration(borderRadius: 10.w),),
                10.sizedBoxW,
                Container(width: 10.w, height: 10.w, decoration: Colours.c_5B6B8D.boxDecoration(borderRadius: 10.w),),
              ],
            ),
          ),),
        )
      ],
    );
  }

  Widget _buildImage() {
    List<dynamic> photos = widget.lcObject['photos'];

    if (photos.isEmpty) {
      return Container();
    }

    if (photos.length == 1) {
      var photo = photos.first;
      return ScaleSizeImageWidget(
        photoHeight: photo['height'].toDouble(), photoUrl: photo['url'], photoWidth: photo['width'].toDouble(),);
    }
    return FriendCircleGridView(photos: photos.map<String>((e) => e['url']).toList());
  }

  Widget _buildVideo() {
    return ScaleSizeVideoWidget(photoWidth: widget.lcObject['thumbnail']['width'].toDouble(),
      videoUrl: widget.lcObject['video']['url'],
      photoHeight: widget.lcObject['thumbnail']['height'].toDouble(),
      photoUrl: widget.lcObject['thumbnail']['url'],);
  }

  Widget _buildLiked() {
    List<dynamic> liked = widget.lcObject['liked'] ?? [];
    if (liked.isEmpty) {
      return Container();
    }

    return Container(
      color: Colours.c_EEEEEE,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
      child: Text.rich(
        TextSpan(
          children: <InlineSpan>[
            ImageSpan(AssetImage(Utils.getIconImgPath('icon_liked')), imageWidth: 28.sp,
                imageHeight: 28.sp,
                margin: EdgeInsets.only(right: 10.w)), ...liked.map((e) =>
                TextSpan(text: e['nickname']+(liked.indexOf(e) != liked.length - 1 ?',':''), style: TextStyle(color: Colours.c_5B6B8D, fontSize: 28.sp, height: 1.1),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        NavigatorUtils.toNamed(FriendDetailPage.routeName, arguments: e['username']);
                      })),
          ],
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildComment(){
    List<dynamic> comments = widget.lcObject['comments'] ?? [];
    if (comments.isEmpty) {
      return Container();
    }

    return Container(
        width: double.infinity,
        decoration: Colours.c_CCCCCC.bottomBorder(bgColor: Colours.c_EEEEEE),
        padding: EdgeInsets.only(bottom: 10.w, left: 10.w,right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: comments.map((e) => Container(
            margin: EdgeInsets.only(top: 10.w),
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(text: e['sender']['nickname'], style: TextStyle(color: Colours.c_5B6B8D, fontSize: 28.sp, height: 1.1),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          NavigatorUtils.toNamed(FriendDetailPage.routeName, arguments: e['sender']['username']);
                        }),
                  TextSpan(text: '：'+e['comment'], style: TextStyle(color: Colours.black, fontSize: 28.sp, height: 1.1),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if(e['sender']['username'] == UserController.instance.username){
                           var _delete = await DialogUtil.showConfimDialog(context, Ids.delete_comment.str());
                           if(_delete??false){
                            await  widget.controller.deleteComment(widget.lcObject,e);
                            setState(() {});
                           }
                          }
                        }),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          )).toList()),
    );
  }

  _buildLocation(){
    if(widget.lcObject['poiInfo'] == null){
      return Container();
    }
    BMFPoiInfo? poiInfo = BMFPoiInfo.fromMap(widget.lcObject['poiInfo']);
    return Container(
      margin: EdgeInsets.only(top: 10.w),
      child: TapWidget(onTap: () {
        NavigatorUtils.toNamed(PreviewLocationPage.routeName,arguments: poiInfo.pt);
      },
      child: Text(poiInfo.name??'',style: TextStyle(color: Colours.c_5B6B8D,fontSize: 24.sp),)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _customPopupMenuController.dispose();
  }

}
