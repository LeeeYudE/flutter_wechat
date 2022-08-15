import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/discover/create_friend_circle_page.dart';
import 'package:wechat/page/main/discover/widget/friend_circle_item.dart';
import 'package:wechat/utils/dialog_util.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/refresh/refresh_widget.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../language/strings.dart';
import '../../../widget/my_children_delegate.dart';
import 'controller/friend_circle_controller.dart';

class FriendCirclePage extends BaseGetBuilder<FriendCircleController> {
  static const String routeName = '/FriendCirclePage';

  final ScrollController _scrollController = ScrollController();
  final double _headerHeight = 600.w;

  FriendCirclePage({Key? key}) : super(key: key);

  @override
  FriendCircleController? getController() => FriendCircleController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  Widget controllerBuilder(BuildContext context, FriendCircleController controller) {
    return MyScaffold(
      showAppbar: false,
      backgroundColor: Colours.white,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        _buildList(context),
        _buildBar(),
      ],
    );
  }

  _buildBar() {
    return ValueListenableBuilder(
      valueListenable: controller.headerNotifier,
      builder: (BuildContext context, bool value, Widget? child) {
        return Container(
          color: value ? null : Colours.c_EEEEEE,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 20.w, bottom: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TapWidget(
                onTap: () {
                  NavigatorUtils.pop();
                },
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: value ? Colours.white : Colours.black,
                ),
              ),
              if (!value)
                Text(
                  Ids.friends_circle.str(),
                  style: TextStyle(color: Colours.black, fontSize: 32.sp),
                ),
              TapWidget(
                onTap: () async {
                  var create = await NavigatorUtils.toNamed(CreateFriendCirclePage.routeName);
                  if (create??false) {
                    WidgetsBinding.instance.addPostFrameCallback((callback) {
                      controller.refreshController.requestRefresh();
                    });

                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Icon(
                    Icons.camera_alt,
                    color: value ? Colours.white : Colours.black,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  _buildList(BuildContext context) {
    return Obx(
      () => NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          switch(notification.runtimeType){
            case ScrollStartNotification:
              break;
            case ScrollEndNotification:
              break;
            case ScrollUpdateNotification:
              if(_scrollController.position.pixels > _headerHeight){
                if(controller.headerNotifier.value) {
                  controller.headerNotifier.value = false;
                }
              }else{
                if(!controller.headerNotifier.value) {
                  controller.headerNotifier.value = true;
                }
              }
              break;
          }
          return false;
        },
        child: RefreshWidget(
          controller: controller.refreshController,
          loadHeader: const MaterialClassicHeader(),
          onRefresh: (_c) async {
            await controller.queryFriendCircle(refresh: true);
            return true;
          },
          onLoading: (_c) async {
            await controller.queryFriendCircle();
            return true;
          },
          child: ListView.builder(
            controller:_scrollController ,
             itemBuilder: (context , index){
              if (index == 0) {
                return _buildHeader(context);
              }
              var lcObject = controller.list[index - 1];
              return FriendCircleItem(
                lcObject: lcObject,
                controller: controller,
              );
             },itemCount: 1 + controller.list.length,),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    var friendCircilBg = UserController.instance.user?.friendCircilBg;
    return Container(
      height: _headerHeight,
      color: Colours.c_666666,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Colours.white.toLine(80.w),
          ),
          TapWidget(
            onTap: () async {
              var file = await DialogUtil.choosePhotoDialog(context, crop: true, aspectRatio: 1.25);
              if (file != null) {
                await UserController.instance.updateFriendCircilBg(file);
                update();
              }
            },
            child: Container(
                margin: EdgeInsets.only(bottom: 80.w),
                child: (friendCircilBg != null)
                    ? CachedNetworkImage(
                        imageUrl: friendCircilBg,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                        Ids.change_cover.str(),
                        style: TextStyle(color: Colours.white, fontSize: 32.sp),
                      ))),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 50.w, right: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    UserController.instance.user?.nickname ?? '',
                    style: TextStyle(color: Colours.white, fontSize: 32.sp),
                  ),
                  10.sizedBoxW,
                  AvatarWidget(avatar: UserController.instance.user?.avatar, weightWidth: 150.w)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
