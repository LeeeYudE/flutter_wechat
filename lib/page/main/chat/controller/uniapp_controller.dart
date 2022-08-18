import 'dart:io';

import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/base/base_getx_refresh.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/utils/file_utils.dart';

import '../../../../plugin/uniapp/uniapp_plugin.dart';
import '../../../../utils/range_download_manage.dart';
import '../../../../widget/sliding_up_panel.dart';

class UniappController extends BaseXRefreshController{

  PanelController panelController;

  UniappController(this.panelController);


  @override
  onReady(){
    getUniappList();
  }

  getUniappList(){
    var lcQuery = LCQuery(Constant.OBJECT_NAME_UNIAPP);
    lcQuery.include('wgtFile');
    queryList(lcQuery,refresh: true);
  }

  void releaseWgtToRunPath(LCObject object) {
    LCFile file = object['wgtFile'];
    lcPost(() async {
      var name = file.name;
      var uniappTemporaryDirectory = await FileUtils.getUniappTemporaryDirectory();
      var wgtFileName = uniappTemporaryDirectory.path+'/'+name;
      var wgtFile = File(wgtFileName);
      if(wgtFile.existsSync()){
        await panelController.open();
        UniappPlugin().releaseWgtToRunPath(wgtFileName, object['appId']);
        return;
      }
      await DownLoadManage().download(file.url, wgtFileName,done: (path) async {
        await panelController.open();
        UniappPlugin().releaseWgtToRunPath(path, object['appId']);
      });
    });

  }

}