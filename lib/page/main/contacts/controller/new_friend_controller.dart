
import 'package:flutter/cupertino.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/controller/user_controller.dart';

class NewFriendController extends BaseXController{

  List<LCFriendshipRequest> requests = [];

  @override
  onReady(){
    friendshipRequest();
  }

  friendshipRequest({bool changeState = true}){
    lcPost(() async {
      LCQuery<LCFriendshipRequest>? query =  LCQuery<LCFriendshipRequest>('_FriendshipRequest');
      query.whereEqualTo('friend', UserController.instance.user)
          .whereEqualTo('status','pending')
          .include('user');
      List<LCFriendshipRequest>? result = await query.find();
      requests.clear();
      if(result?.isNotEmpty??false){
        requests.addAll(result!);
      }
    },changeState: changeState);
  }

  acceptRequest(LCFriendshipRequest request){
    lcPost(() async {
      await LCFriendship.acceptRequest(request);
      friendshipRequest(changeState:false);
    });
  }

}