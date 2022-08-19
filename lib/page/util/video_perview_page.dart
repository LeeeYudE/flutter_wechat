import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/dialog_util.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../language/strings.dart';
import '../../widget/dialog/dialog_bottom_widget.dart';
import '../../widget/video_play_widget.dart';
import 'controller/phone_preview_controller.dart';

class VideoArguments{

  static const int actionTypeMore = 1;
  static const int actionTypeDelete = 2;

  String url;
  int? actionType;///1更多 2删除
  bool hero;
  bool autoPlay;
  String? cacheId;

  VideoArguments({required this.url, this.actionType = actionTypeMore,this.hero = false,this.autoPlay = false,this.cacheId});
}

class VideoPerviewPage extends BaseGetBuilder<PhonePreviewController> {

  static const String routeName = '/VideoPerviewPage';

  VideoPerviewPage({Key? key}) : super(key: key);

  late VideoArguments _arguments;

  @override
  void onInit() {
    _arguments = Get.arguments;
    super.onInit();
  }

  @override
  Widget controllerBuilder(BuildContext context, PhonePreviewController controller) {
    return MyScaffold(
      body: VidwoPlayWidget(path: _arguments.url,hero: _arguments.hero,autoPlay: _arguments.autoPlay,cacheId: _arguments.cacheId,),
      actions: [
        if(_arguments.actionType == VideoArguments.actionTypeDelete)
          TapWidget(onTap: () {
            NavigatorUtils.pop(VideoArguments.actionTypeDelete);
          },
              child: const Icon(Icons.delete,color: Colours.black,)),
        if(_arguments.actionType == VideoArguments.actionTypeMore)
          TapWidget(onTap: () async {
            var result = await NavigatorUtils.showBottomItemsDialog([DialogBottomWidgetItem(Ids.save_to_phone.str(),0)]);
            if(result == 0){
              controller.saveMedia(_arguments.url);
            }
          }, child: const Icon(Icons.more_horiz_outlined,color: Colours.black,)),
      ],
    );
  }

  @override
  PhonePreviewController? getController() => PhonePreviewController();

}
