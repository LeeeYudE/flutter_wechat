
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';

class FriendCircleController extends BaseXController{

  final RefreshController refreshController = RefreshController();

  RxList<LCObject> list = <LCObject>[].obs;
  ValueNotifier<bool> headerNotifier = ValueNotifier<bool>(true);
  int _page = 0;

  @override
  onReady(){
    queryFriendCircle(refresh: true);
  }

  queryFriendCircle({bool refresh = false}){
    lcPost(() async {
      var lcQuery = LCQuery(Constant.OBJECT_NAME_FRIEND_CIRCLE);
      lcQuery.limit(Constant.PAGE_SIZE);
      lcQuery.skip(refresh?0:Constant.PAGE_SIZE * _page);
      lcQuery.orderByDescending('createdAt');
      lcQuery.include('user');
      List<LCObject>? find = await lcQuery.find(cachePolicy: CachePolicy.networkElseCache);
      if(refresh){
        list.clear();
      }
      list.addAll(find??[]);
      if(refresh){
        _page = 1;
      }else{
        _page ++ ;
      }
    },showloading: false,updated: false);
  }

  void deleteFriendCircle(LCObject lcObject) {
    lcPost(() async {
      await lcObject.delete();
      list.remove(lcObject);
    },updated: false);
  }

   likeFriendCircle(LCObject lcObject) async {
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
      await lcObject.save();
    },updated: false);
  }

   comment(LCObject lcObject, String comment) async {
      await lcPost(() async {
        List comments = lcObject['comments']??[];
        Map<String,dynamic> _comment = {};
        _comment['comment'] = comment;
        _comment['sender'] = {
          'username':UserController.instance.username,
          'nickname':UserController.instance.user?.nickname
        };
        comments.add(_comment);
        lcObject['comments'] = comments;
        await  lcObject.save();
      },updated: false);
  }

   deleteComment(LCObject lcObject,Map comment) async {
   await lcPost(() async {
     List comments = lcObject['comments']??[];
     comments.remove(comment);
     lcObject['comments'] = comments;
     await  lcObject.save();
    });
  }

}