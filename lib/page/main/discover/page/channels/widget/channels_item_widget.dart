import 'package:easy_refresh/easy_refresh.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:like_button/like_button.dart';
import 'package:uuid/uuid.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/core.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wechat/widget/load_widget.dart';
import 'package:wechat/widget/remove_top_widget.dart';
import '../../../../../../base/common_state_widget_x.dart';
import '../../../../../../controller/user_controller.dart';
import '../../../../../../language/strings.dart';
import '../../../../../../utils/navigator_utils.dart';
import '../../../../../../widget/avatar_widget.dart';
import '../../../../../../widget/common_btn.dart';
import '../../../../../../widget/input_field.dart';
import '../../../../../../widget/keyboard_observer_layout.dart';
import '../../../../../../widget/listview/panel_scroll_view.dart';
import '../../../../../../widget/lottie_widget.dart';
import '../../../../../../widget/refresh/refresh_header.dart';
import '../../../../../../widget/refresh/refresh_widget.dart';
import '../../../../../../widget/sliding_up_panel.dart';
import '../../../../../../widget/tap_widget.dart';
import '../../../../../../widget/video_play_widget.dart';
import '../../../../map/preview_loctaion_page.dart';
import '../controller/channels_controller.dart';
import '../controller/channles_comments_controller.dart';
import 'channels_comment_item.dart';

class ChannelItemWidget extends BaseGetBuilder<ChannelsCommentsController> {

  LCObject channel;
  ChannelsController? channelsController;

  ChannelItemWidget({required this.channel,this.channelsController,Key? key}) : super(key: key);

  final double _panelHeight = 800.w;
  double _pos = 0;
  double _keyboardHeight = 0;
  bool _isDraggable = true;
  bool _isStartDraggable = false;
  final GlobalKey<SlidingUpPanelState> _panelKey = GlobalKey();

  @override
  Widget controllerBuilder(BuildContext context, ChannelsCommentsController controller) {
    return SlidingUpPanel(
      key: _panelKey,
      maxHeight: _panelHeight,
      minHeight: 0,
      backdropTapClosesPanel:true,
      parallaxEnabled:false,
      parallaxOffset: 1,
      backdropOpacity: 0,
      color: Colours.black,
      isDraggable: true,
      body: Container(
        padding: EdgeInsets.only(bottom: _panelHeight * _pos ),
        child: Column(
          children: [
            Expanded(child: _buildVideo(controller)),
            _buildBottomBar(controller)
          ],
        ),
      ),
      panel: _buildCommentsPanel(controller),
      // panelBuilder:(sc)=> _buildCommentsPanel(controller),
      backdropEnabled: true,
      onPanelSlide: (double pos) {
        _pos = pos;
        controller.update();
      },
      controller: controller.panelController,
    );
  }
  
  _buildVideo(ChannelsCommentsController controller){
    return Stack(
      children: [
        VidwoPlayWidget(path: channel['video']['url'],isShowOptions: false,autoPlay: true),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom: 80.w,left: 20.w,right: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(channel['text'] != null)
                ExpandableText(
                  channel['text'],
                  expandText: Ids.full_text.str(),
                  collapseText: Ids.expandable_text.str(),
                  maxLines: 2,
                  linkColor: Colours.c_EEEEEE,
                  style: TextStyle(color: Colours.white,fontSize: 28.sp),
                ),
                _buildLocation()
              ],
            ),
          ),
        ),
      ],
    );
  }

  _buildLocation(){
    if(channel['poiInfo'] == null){
      return Container();
    }
    BMFPoiInfo poiInfo = BMFPoiInfo.fromMap(channel['poiInfo']);
    return Container(
      margin: EdgeInsets.only(top: 10.w),
      child: TapWidget(onTap: () {
        NavigatorUtils.toNamed(PreviewLocationPage.routeName,arguments: poiInfo.pt);
      }, child: Row(
        children: [
          Icon(Icons.location_on_outlined,color:Colours.theme_color,size: 35.w,),
          5.sizedBoxW,
          Text(poiInfo.city??'',style: TextStyle(color: Colours.white,fontSize: 28.sp),),
        ],
      )),
    );
  }

  _buildBottomBar(ChannelsCommentsController controller){
    List liked = channel['liked'] ?? [];
    List favorited = channel['favorited'] ?? [];
    bool _liked = liked.hasIndex((element) => element['username'] == UserController.instance.username);
    bool _favorited = favorited.hasIndex((element) => element['username'] == UserController.instance.username);
    int _commentsCount = channel['commentsCount']??0;
    return Container(
      color: Colours.black,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      height: 120.w,
      child: Row(
        children: [
          AvatarWidget(avatar: channel['user']['avatar'], weightWidth: 80.w,circle: true,),
          10.sizedBoxW,
          Expanded(child: Text(channel['user']['nickname'],style: TextStyle(color: Colours.white,fontSize: 28.sp),)),
          _buildOperateItem(_liked?'icon_channels_liked':'icon_channels_like',liked.length,() async {
            await controller.likeChannels(channel);
            controller.update();
          },true),
          _buildOperateItem('icon_channels_forword',0,(){
            Share.share('${channel['video']['url']}',subject:Ids.channels.str());
          },false),
          _buildOperateItem(_favorited?'icon_channels_favorited':'icon_channels_favorite',favorited.length,() async {
            await controller.favoritedChannels(channel);
            controller.update();
          },true),
          _buildOperateItem('icon_channels_comment',_commentsCount,(){
            controller.panelController.open();
            if(controller.state == ViewState.Init){
              controller.queryComments(channel, true);
            }
          },false),
        ],
      ),
    );
  }

  _buildOperateItem(String icon , int num,GestureTapCallback onTap , bool aminationLike){
    if(aminationLike){
      return Container(
        margin: EdgeInsets.only(left: 20.w),
        child: LikeButton(
          size: 40.w,
          isLiked: num > 0,
          circleColor:
          const CircleColor(start: Colours.c_E9465D, end: Colours.c_E9465D),
          bubblesColor: const BubblesColor(
            dotPrimaryColor: Colours.c_E9465D,
            dotSecondaryColor: Colours.c_E9465D,
          ),
          likeBuilder: (bool isLiked) {
            return Image.asset(Utils.getImgPath(icon,dir:Utils.dir_discover,),width: 40.w,height: 40.w,);
          },
          likeCount: num,
          countBuilder: (int? count, bool isLiked, String text) {
            return Container(
                margin: EdgeInsets.only(top: 5.w),
                child: Text('${count??0}',style: TextStyle(color: Colours.white,fontSize: 28.sp),));
          },
          countPostion: CountPostion.bottom,
          onTap: (bool liked) async {
            onTap.call();
            return !liked;
          },
        ),
      );
    }

    return TapWidget(
      onTap:onTap,
      child: Container(
        margin: EdgeInsets.only(left: 20.w),
        width: 60.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Utils.getImgPath(icon,dir:Utils.dir_discover,),width: 40.w,height: 40.w,),
            10.sizedBoxH,
            Text('$num',style: TextStyle(color: Colours.white,fontSize: 28.sp),),
          ],
        ),
      ),
    );
  }

  _buildCommentsPanel(ChannelsCommentsController controller){
    int _commentsCount = channel['commentsCount']??0;
    return Container(
      height: 800.w,
      decoration: Colours.white.radiusDecoration(topRight: 12.w,topLeft: 12.w),
      child: Column(
        children: [
          SizedBox(
            height: 100.w,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TapWidget(onTap: () {
                    controller.panelController.close();
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 20.w),
                      child: Icon(Icons.arrow_drop_down_circle_rounded,color: Colours.c_999999,size: 30.w,))),
                ),
                Center(
                  child: Text('$_commentsCount条评论',style: TextStyle(color: Colours.black,fontSize: 28.sp),),
                )
              ],
            ),
          ),
          Expanded(child: Container(
            color: Colours.white,
            child:   CommonStateWidgetX(
              controller: controller,
              widgetBuilder: (BuildContext context) {
                return Obx(
                      () => RemoveTopPaddingWidget(
                    child:EasyRefresh(
                      controller: controller.refreshController,
                      onLoad:controller.list.isNotEmpty? (){
                        controller.queryComments(channel,false);
                      }:null,
                      child: PanelListView.builder(itemBuilder: (context , index){
                        return ChannelsCommentItem(comment: controller.list[index],);
                      },itemCount: controller.list.length,controller: controller.scrollController,
                        onGestureStart: (details){
                          _isDraggable = (controller.scrollController.position.pixels == 0);
                          return _isDraggable;
                        },
                        onGestureSlide: (details){
                          if(_isDraggable){
                            if(details.delta.dy > 0){///向下滑动
                              if(controller.scrollController.position.pixels == 0){///列表处于最顶部，可以拖动面板
                                _isStartDraggable = true;
                                _panelKey.state?.onGestureSlide(details.delta.dy);
                                return true;
                              }
                            }else{///向上滑动
                              if(controller.scrollController.position.pixels == 0){
                                return false;
                              }else if(_isStartDraggable){
                                _panelKey.state?.onGestureSlide(details.delta.dy);
                                return true;
                              }
                            }
                          }
                          return false;
                        },
                        onGestureEnd: (details){
                          if(_isStartDraggable){
                            _panelKey.state?.onGestureEnd(details.velocity);
                            _isStartDraggable = false;
                            return true;
                          }
                          return false;
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
          _buildCommentBar(controller),
        ],
      ),
    );
  }

  _buildCommentBar(ChannelsCommentsController controller){
    return KeyboardObserverLayout(
      onKeyboardChange: (double value) {
        _keyboardHeight = value;
        controller.update();
      },
      child: Container(
        color: Colours.c_EEEEEE,
        height: 100.w,
        margin: EdgeInsets.only(bottom: _keyboardHeight),
        child: Row(
          children: [
            AvatarWidget(avatar: UserController.instance.user?.avatar, weightWidth: 80.w),
            20.sizedBoxW,
            Expanded(child: InputField(hint: Ids.publish_comment.str(),controller: controller.textEditingController,autofocus: false,)),
            20.sizedBoxW,
            CommonBtn(onTap: () async {
              controller.publishComments(channel, controller.textEditingController.text.trim());
            }, text: Ids.published.str(),enable: controller.textEditingController.text.isNotEmpty,),
            20.sizedBoxW,
          ],
        ),
      ),
    );
  }

  @override
  ChannelsCommentsController? getController()  => ChannelsCommentsController();

  @override
  String? getTag() => const Uuid().v4();

}
