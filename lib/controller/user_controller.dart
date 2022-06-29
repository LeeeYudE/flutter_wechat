import 'dart:async';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:wechat/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/page/main/main_page.dart';

import '../base/base_getx.dart';
import '../utils/navigator_utils.dart';

class UserController extends BaseXController {

  static UserController get instance => Get.find();
  ViewState _initState = ViewState.Init;

  LCUser? user;

  bool get isLogin => user != null;

  bool get isInited => _initState == ViewState.Idle;
  String get username => user?.username??'';

  @override
  onReady(){
    _init();
  }

  _init() async {
    user = await LCUser.getCurrent();
    _initState = ViewState.Idle;
    if(user == null){
      update();
    }else{
      Future.delayed(1000.toMilliSeconds,(){
        NavigatorUtils.offNamed(MainPage.routeName);
      });
    }
  }

  checkLogin({required VoidCallback callback , bool needCallback = false}) async {
    if(isLogin){
      callback();
    }else{
     // var result =  await GetxUtils.toNamed(LoginPage.routeName);
     // if((result??false) && needCallback){
     //   callback();
     // }
    }
  }

  Future<bool> login(String phone , String password) async {
   await lcPost(() async {
      user = await LCUser.login(phone, password);
    });
   return user != null;
  }

  Future<bool> updateAvatar(File file) async {
    try {
      showLoading();
      LCFile _file = await LCFile.fromPath(file.filename, file.path);
       await _file.save(onProgress: (int count, int total){
        print('count $count total $total ');
      });
      disimssLoading();
      user!['avatar'] = _file.url;
      user?.save();
      update();
      return true;
    } on LCException catch (e) {
      e.message.toast();
      print('${e.code} : ${e.message}');
      disimssLoading();
      return false;
    }
  }

  logout() async {
   await LCUser.logout();
   user = null;
   update();
  }

}