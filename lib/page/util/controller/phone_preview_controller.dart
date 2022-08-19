import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat/base/base_getx.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/permission_utils.dart';
import 'package:wechat/utils/range_download_manage.dart';
import '../../../language/strings.dart';
import '../../../utils/file_utils.dart';

class PhonePreviewController extends BaseXController{

  Future<bool> saveMedia(String? url) async {
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

        await DownLoadManage().download(url, savePath,done: (path) async {
          disimssLoading();
          await ImageGallerySaver.saveFile(savePath);
          Ids.save_success.str().toast();

        },failed: (e){
          disimssLoading();
          Ids.save_fail.str().toast();
        });

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