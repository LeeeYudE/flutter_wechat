import 'dart:io';

import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../color/colors.dart';
import '../page/util/crop_image_page.dart';
import '../utils/navigator_utils.dart';
import '../utils/permission_utils.dart';

/// 弹窗让用户选择是拍照还是相册选择
class ChoosePhotoMethodsDialog extends Dialog {
  final String title;
  final bool crop;

  ChoosePhotoMethodsDialog({Key? key, this.title = '修改头像',this.crop = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildContainer(context);
  }

  Container _buildContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(39.6.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colours.c_6C4D30,
                    fontSize: ScreenUtilExt.setSp(31.68),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                  top: -ScreenUtilExt.setHeight(19.8),
                  left: -ScreenUtilExt.setWidth(19.8),
                  child: IconButton(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: ScreenUtilExt.setHeight(26.4),
                        color: Colours.c_212129,
                      ),
                      onPressed: () {
                        _dismiss(context);
                      })),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenUtilExt.setWidth(26.4),
                ScreenUtilExt.setHeight(39.6),
                ScreenUtilExt.setWidth(26.4),
                ScreenUtilExt.setHeight(52.8)),
            child: Row(
              children: <Widget>[
                _buildItem(0, '拍照', () async {
                  await toCamera(context);
                }),
                SizedBox(
                  width: ScreenUtilExt.setWidth(46.2),
                ),
                _buildItem(1, '相册', () async {
                  await toPhoto(context);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  toPhoto(BuildContext context) async {
    final bool result = await PermissionUtils.requestPermissionPhotos();
    if (result) {
      _pickPhoto(context, false);
    } else {
      final bool isOpen =
          await PermissionUtils.askOpenAppSettings(context, '存储权限已被禁止，去开启');
      if (isOpen) {
        toCamera(context);
      }
    }
  }

  toCamera(BuildContext context) async {
    final bool result = await PermissionUtils.requestPermissionCamera();
    if (result) {
      _pickPhoto(context, true);
    } else {
      final bool? isOpen = await PermissionUtils.askOpenAppSettings(context, '相机权限已被禁止，去开启');
      if (isOpen ?? true) {
        toCamera(context);
      }
    }
  }

  Expanded _buildItem(int icon, String name, VoidCallback callback) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(
          ScreenUtilExt.setWidth(31.68),
        ),
        onTap: callback,
        child: Ink(
          padding: EdgeInsets.symmetric(vertical: 32.w),
          decoration: BoxDecoration(
            color: const Color(0xff8C6238),
            borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtilExt.setWidth(31.68)),
            ),
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                Icon(
                  icon == 0 ? Icons.camera : Icons.photo,
                  size: ScreenUtilExt.setWidth(73.92),
                  color: Colours.white,
                ),
                SizedBox(height: ScreenUtilExt.setHeight(26.4)),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: ScreenUtilExt.setSp(31.68),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final picker = ImagePicker();

  ///
  /// 拍照或者从相册选择照片
  ///
  Future<void> _pickPhoto(context, bool camera) async {

    final pickedFile = await ImagePicker.platform.pickImage(
        source: camera ? ImageSource.camera : ImageSource.gallery);
    if(pickedFile != null){
      final File imageFile = File(pickedFile.path);
      debugPrint('imageFile is null $imageFile');
      if(crop){
        _crop(context,imageFile);
      }else{
        Navigator.of(context).pop(imageFile);
      }
    }else{
      _dismiss(context);
    }
  }

   _crop(BuildContext context,File file) async {
    NavigatorUtils.offPage(CropImagePage());
  }

  _dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
