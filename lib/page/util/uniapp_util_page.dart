import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/language/strings.dart';
import 'package:wechat/utils/permission_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/input_field.dart';
import '../../utils/dialog_util.dart';
import '../../utils/utils.dart';
import '../../widget/common_btn.dart';
import '../../widget/tap_widget.dart';
import 'controller/uniapp_util_controller.dart';

class UniappUtilPage extends BaseGetBuilder<UniappUtilController>{

  static const String routeName = '/UniappUtilPage';

  @override
  Widget controllerBuilder(BuildContext context, UniappUtilController controller) {
    return MyScaffold(
        title: Ids.mini_program_update_util.str(),
        body: _buildBody(context),
        actions: [
          CommonBtn(text: Ids.update.str(), onTap: () {
            controller.updateWgt();
          },enable: controller.wgtFile != null && controller.avatarFile != null && controller.appIdController.text.trim().isNotEmpty && controller.appNameController.text.trim().isNotEmpty,)
        ],
    );
  }

  @override
  UniappUtilController? getController() => UniappUtilController();

  _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(controller.wgtFile?.path??'',)),
              IconButton(onPressed: () async {
                if(await PermissionUtils.requestPermissionStorage()){
                  FilePickerResult? result = await FilePicker.platform.pickFiles();
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    if(!file.path.endsWith('wgt')){
                      Ids.file_format_error.str().toast();
                      return;
                    }
                    controller.setWgt(file);
                  }
                }

              }, icon: const Icon(Icons.create_new_folder,color: Colours.black,))
            ],
          ),
          20.sizedBoxH,
          InputField(
            hint: '小程序Appid',
            controller: controller.appIdController,
            showClean: true,
          ),
          20.sizedBoxH,
          InputField(
            hint: '小程序名称',
            controller: controller.appNameController,
            lengthLimiting: 10,
            showClean: true,
          ),
          20.sizedBoxH,
          InputField(
            hint: '小程序密码(非必要)',
            controller: controller.appPasswordController,
            showClean: true,
          ),
          20.sizedBoxH,
          _buildAvatar(context),
          20.sizedBoxH,
          _buildHint()
        ],
      ),
    );
  }

  _buildAvatar(BuildContext context){
    return TapWidget(
      onTap: () async {
        var file = await DialogUtil.choosePhotoDialog(context,crop: true);
        if(file != null){
          controller.setAvatar(file);
        }
      },
      child: (controller.avatarFile == null)? Image.asset(
        Utils.getImgPath('select_avatar',dir: 'avatar',format: Utils.WEBP),
        width: 150.w,
        height: 150.w,
      ):Image.file(controller.avatarFile!,width: 150.w,height: 150.w,fit:BoxFit.cover,),
    );
  }

  _buildHint(){
    return Text('首先您需要了解什么是uni-app，uni-app 是一个使用 Vue.js 开发所有前端应用的框架，开发者编写一套代码，可发布到 H5、以及各种小程序（微信/支付宝/百度/头条/QQ/钉钉/淘宝）、快应用等多个平台，并且在 HBuilderX 中可直接打包生成 Android、iOS App。了解更多关于 uni-app 请点击查看 uni-app 官网。',style: TextStyle(color: Colours.c_999999,fontSize: 24.sp),);
  }

}
