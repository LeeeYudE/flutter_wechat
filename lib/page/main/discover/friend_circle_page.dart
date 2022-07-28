import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/discover/create_friend_circle_page.dart';
import 'package:wechat/utils/dialog_util.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/refresh/refresh_widget.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../language/strings.dart';
import 'controller/friend_circle_controller.dart';

class FriendCirclePage extends BaseGetBuilder<FriendCircleController> {

  static const String routeName='/FriendCirclePage';

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

  _buildBar(){
    return Container(
      margin: EdgeInsets.only(top: 100.w,left: 20.w,right: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TapWidget(
            onTap: () {
              NavigatorUtils.pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colours.white,
            ),
          ),
          TapWidget(
            onTap: () {
              NavigatorUtils.toNamed(CreateFriendCirclePage.routeName);
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colours.white,
            ),
          )
        ],
      ),
    );
  }

  _buildList(BuildContext context){
    return RefreshWidget(
      controller: controller.controller,
      loadHeader: const MaterialClassicHeader(),
      onRefresh: (_c) async {
        return true;
      },
      onLoading: (_c) async {
        return true;
      },
      child: ListView.builder(itemBuilder: (context , index){
        if(index == 0){
          return _buildHeader(context);
        }
        return Container(height: 100.w,color: Colours.black,);
      },itemCount: 1,),
    );
  }

  Widget _buildHeader(BuildContext context){
    var friendCircilBg = UserController.instance.user?.friendCircilBg;
    return Container(
      height: 600.w,
      color: Colours.c_666666,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Colours.white.toLine(80.w),
          ),
          TapWidget(
              onTap: () async {
                var file = await DialogUtil.choosePhotoDialog(context,crop: true,aspectRatio: 1.25);
                if(file != null){
                  await UserController.instance.updateFriendCircilBg(file);
                  update();
                }
              },
              child: Container(
                  margin: EdgeInsets.only(bottom: 80.w),
                  child: (friendCircilBg != null)?
                  CachedNetworkImage(imageUrl: friendCircilBg,width: double.infinity,height: double.infinity,fit: BoxFit.cover,):
                  Center(child: Text(Ids.change_cover.str(),style: TextStyle(color: Colours.white,fontSize: 32.sp),))),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.only(bottom: 50.w,right: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(UserController.instance.user?.nickname??'',style: TextStyle(color: Colours.white,fontSize: 32.sp),),
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
