import 'package:flutter/material.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:open_file/open_file.dart';
import 'package:wechat/utils/dialog_util.dart';
import 'package:wechat/utils/file_utils.dart';
import 'package:wechat/utils/range_download_manage.dart';
import '../../../../../widget/tap_widget.dart';
import 'package:filesize/filesize.dart';

class MessageFileItem extends StatelessWidget {

  FileMessage message;

  MessageFileItem({required this.message,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapWidget(
      onTap: () async {
        var director = await FileUtils.getFileTemporaryDirectory();
        String saveFile = director.path+'/'+message.filename;
        DialogUtil.showLoading();
        DownLoadManage().download(message.url, saveFile,done: (path){
          OpenFile.open(path);
          DialogUtil.disimssLoading();
        },failed: (e){
          DialogUtil.disimssLoading();
        });
      },
      child: Container(
        width: 400.w,
        padding: EdgeInsets.symmetric(vertical: 20.w,horizontal: 20.w),
        decoration: (Colours.white).boxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.filename,style: TextStyle(color: Colours.black,fontSize: 24.sp),),
                10.sizedBoxH,
                Text(filesize(message.fileSize),style: TextStyle(color: Colours.c_999999,fontSize: 24.sp),),
              ],
            )),
            20.sizedBoxW,
            Icon(Icons.file_copy,color: Colours.c_999999,size: 50.w,)
          ],
        ),
      ),
    );
  }
}
