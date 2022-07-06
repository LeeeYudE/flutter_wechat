import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/permission_utils.dart';
import '../../../language/strings.dart';
import '../../../utils/file_utils.dart';

class PhonePreviewController extends BaseXController{

  Future<bool> saveImage(String? url) async {
    if(url == null){
      return  false;
    }
   bool requestPermission = await PermissionUtils.requestPermission(Permission.storage);

    if (requestPermission) {
      if (url.startsWith('http')) {
        final appDocDir = await FileUtils.getImageTemporaryDirectory();

        final String suffix = url.suffix;
        final String savePath =
            appDocDir.path + '/' + DateUtil.getNowDateMs().toString() + suffix;
        debugPrint('savePath = $savePath');

        showLoading();

        final response = await Dio().download(url, savePath,
            onReceiveProgress: (count, total) {
              debugPrint('saveMessageMeida count = $count  ## total = $total ');
            });
        disimssLoading();
        if (response.statusCode == 200) {
          await ImageGallerySaver.saveFile(savePath);
          Ids.save_success.str().toast();
          return true;
        } else {
          Ids.save_success.str().toast();
          return true;
        }
      } else {
        await ImageGallerySaver.saveFile(url);
        Ids.save_success.str().toast();
      }
    } else{
      Ids.no_permission.str().toast();
    }
    return false;
  }

}