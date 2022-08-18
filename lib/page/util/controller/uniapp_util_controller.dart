import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/navigator_utils.dart';

import '../../main/chat/controller/uniapp_controller.dart';

class UniappUtilController extends BaseXController{

  File? wgtFile;
  File? avatarFile;
  TextEditingController appIdController = TextEditingController();
  TextEditingController appNameController  = TextEditingController();
  TextEditingController appPasswordController  = TextEditingController();

  @override
  void onInit() {
    appIdController.addListener(() {
      update();
    });
    appNameController.addListener(() {
      update();
    });
    super.onInit();
  }

  void setWgt(File file) {
    wgtFile = file;
    appIdController.newValue(file.filename.replaceAll('.wgt', ''));
    update();
  }

  void setAvatar(File file) {
    avatarFile = file;
    update();
  }

  updateWgt() async {
    lcPost(() async {
      var _wgtPath = await LCFile.fromPath(wgtFile!.filename, wgtFile!.path);
      await _wgtPath.save();
      var _avatarPath = await LCFile.fromPath(avatarFile!.filename, avatarFile!.path);
      await _avatarPath.save();
      var lcObject = LCObject(Constant.OBJECT_NAME_UNIAPP);
      lcObject['avatar'] = _avatarPath.url;
      lcObject['wgtFile'] = _wgtPath;
      lcObject['appId'] = appIdController.text.trim();
      lcObject['appName'] = appNameController.text.trim();
      lcObject['appPassword'] = appNameController.text.trim();
      await lcObject.save();
      UniappController controller = Get.find();
      controller.getUniappList();
      NavigatorUtils.pop();
    });
  }

  @override
  void onClose() {
    super.onClose();
    appIdController.dispose();
    appNameController.dispose();
    appPasswordController.dispose();
  }

}