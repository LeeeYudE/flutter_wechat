import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import '../../../../../../base/base_getx_refresh.dart';
import '../../../../../../widget/sliding_up_panel.dart';

class ChannelsCommentsController extends BaseXRefreshController{

  final TextEditingController textEditingController = TextEditingController();
  final PanelController panelController = PanelController();
  final ScrollController scrollController = ScrollController();
  final EasyRefreshController refreshController = EasyRefreshController(controlFinishLoad: true);

  @override
  void onInit() {
    textEditingController.addListener(() {
      update();
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  queryComments(LCObject channel,bool refresh) async {
    var lcQuery = LCQuery(Constant.OBJECT_NAME_CHANNLES_COMMENTS);
    lcQuery.whereEqualTo('channel', channel);
    lcQuery.orderByDescending('createdAt');
    lcQuery.include('user');
    await queryList(lcQuery,refresh:refresh);
    if(!refresh){
      refreshController.finishLoad(canLoad?IndicatorResult.success:IndicatorResult.noMore);
    }
  }

  Future<bool> publishComments(LCObject channle,String comment) async {
    var bool = await lcPost(() async {
      var lcObject = LCObject(Constant.OBJECT_NAME_CHANNLES_COMMENTS);
      lcObject['comment'] = comment;
      lcObject['user'] = UserController.instance.user;
      lcObject['channel'] = channle;
      await lcObject.save();
      list.insert(0, lcObject);
    },updated: false);
    if(bool){
      textEditingController.clear();
    }
    return bool;
  }

  likeChannels(LCObject lcObject) async {
    await lcPost(() async {
      List liked = lcObject['liked']??[];
      bool hasIndex = liked.hasIndex((element) => element['username'] == UserController.instance.username);
      if(hasIndex){
        liked.removeWhere((element) => element['username'] == UserController.instance.username);
      }else{
        Map<String,dynamic> _map = {};
        _map['username'] = UserController.instance.username;
        _map['nickname'] = UserController.instance.user?.nickname;
        _map['avatar'] = UserController.instance.user?.avatar;
        liked.add(_map);
      }
      lcObject['liked'] = liked;
      lcObject.save();
    },updated: false,showloading: false);
  }

  favoritedChannels(LCObject lcObject) async {
    await lcPost(() async {
      List liked = lcObject['favorited']??[];
      bool hasIndex = liked.hasIndex((element) => element['username'] == UserController.instance.username);
      if(hasIndex){
        liked.removeWhere((element) => element['username'] == UserController.instance.username);
      }else{
        Map<String,dynamic> _map = {};
        _map['username'] = UserController.instance.username;
        _map['nickname'] = UserController.instance.user?.nickname;
        _map['avatar'] = UserController.instance.user?.avatar;
        liked.add(_map);
      }
      lcObject['favorited'] = liked;
      lcObject.save();
    },updated: false,showloading: false);
  }

  @override
  void onClose() {
    textEditingController.dispose();
    refreshController.dispose();
    super.onClose();
  }

}