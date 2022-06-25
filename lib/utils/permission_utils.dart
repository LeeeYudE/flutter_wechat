import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dialog_util.dart';

class PermissionUtils {

  ///基础权限申请
  static Future<bool> requestPermission(Permission permission) async {
    final permissionStorage = await permission.status;
    if (permissionStorage == PermissionStatus.granted) {
      return true;
    }
     PermissionStatus status = await permission.request();

    return status == PermissionStatus.granted;
  }

  ///基础权限申请
  static Future<bool> requestPermissions(List<Permission> permissions) async {
    List<Permission> requset = [];
    Future.forEach<Permission>(permissions, (element) async {
      if( await element.status != PermissionStatus.granted){
        requset.add(element);
      }
    });
    if (requset.isEmpty) {
      return true;
    }
    // 申请权限
    final Map<Permission, PermissionStatus> results = await requset.request();
    bool success = true;
    results.forEach((key, value) {
      if(value != PermissionStatus.granted){
        success = false;
      }
    });
    return success;
  }

  ///基础手机imei权限等
  static Future<bool> requestPhoneStatus() async {
    final permissionStorage = await Permission.phone.status;
    if (Platform.isIOS) {
      if (permissionStorage == PermissionStatus.granted) {
        return true;
      }
    } else {
      if (permissionStorage == PermissionStatus.granted) {
        return true;
      }
    }
    // 申请权限
    final Map<Permission, PermissionStatus> permissions = await [
      Permission.phone,
    ].request();
    return permissions[Permission.phone] == PermissionStatus.granted;
  }

  ///申请访问照片权限
  static Future<bool> requestPermissionPhotos() async {
    final permissionPhotos = await Permission.photos.status;
    if (permissionPhotos == PermissionStatus.granted) {
      return true;
    }
    // 申请权限
    final Map<Permission, PermissionStatus> permissions = await [
      Permission.photos,
    ].request();
    return permissions[Permission.photos] == PermissionStatus.granted;
  }

  ///申请访问照片权限
  static Future<bool> requestPermissionStorage() async {
    final permissionStorage = await Permission.storage.status;
    if (permissionStorage == PermissionStatus.granted) {
      return true;
    }
    // 申请权限
    final Map<Permission, PermissionStatus> permissions =
        await [Permission.storage].request();
    return permissions[Permission.storage] == PermissionStatus.granted;
  }

  ///申请安装apk权限
  static Future<bool> requestPermissionInstall() async {
    final permissionStorage = await Permission.requestInstallPackages.status;
    if (permissionStorage == PermissionStatus.granted) {
      return true;
    }
    // 申请权限
    final Map<Permission, PermissionStatus> permissions =
        await [Permission.requestInstallPackages].request();
    return permissions[Permission.requestInstallPackages] ==
        PermissionStatus.granted;
  }

  ///申请定位权限
  static Future<bool> requestPermissionLocation() async {
    final permissionLocation = await Permission.location.status;
    if (permissionLocation == PermissionStatus.granted) {
      return true;
    }
    // 申请权限
    final Map<Permission, PermissionStatus> permissions = await [
      Permission.location,
    ].request();
    return permissions[Permission.location] == PermissionStatus.granted;
  }

  ///申请拍照权限
  static Future<bool> requestPermissionCamera() async {
    final permissionCamera = await Permission.camera.status;
    if (permissionCamera == PermissionStatus.granted) {
      return true;
    }
    // 申请权限
    final Map<Permission, PermissionStatus> permissions = await [
      Permission.camera,
    ].request();
    return permissions[Permission.camera] == PermissionStatus.granted;
  }

  ///是否需要申请权限
  static Future<bool> needRequestPermissionMicrophone() async {
    final permissionMicrophone = await Permission.microphone.status;
    if (permissionMicrophone == PermissionStatus.granted) {
      return false;
    }
    return true;
  }

  ///申请权限麦克风
  static Future<bool> requestPermissionMicrophone() async {
    final permissionMicrophone = await Permission.microphone.status;
    if (permissionMicrophone == PermissionStatus.granted) {
      return true;
    }
    // 申请权限
    final Map<Permission, PermissionStatus> permissions = await [
      Permission.microphone,
    ].request();
    return permissions[Permission.microphone] == PermissionStatus.granted;
  }

  //申请拍照权限
  static Future<bool> requestCameraPermission() async {
    final permissionMicrophone = await Permission.camera.status;
    if (permissionMicrophone == PermissionStatus.granted) {
      return true;
    }
    // 申请权限
    final Map<Permission, PermissionStatus> permissions = await [
      Permission.camera,
    ].request();
    return permissions[Permission.camera] == PermissionStatus.granted;
  }

  ///询问是否开启权限
  static Future<bool> askOpenAppSettings(BuildContext context, String text) async {

    final bool? result = await DialogUtil.showConfimDialog(context, text);
    if (true == result) {
      return await openAppSettings();
    }
    return false;
  }

}
