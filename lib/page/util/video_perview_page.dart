import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../widget/video_play_widget.dart';

class VideoArguments{

  static const int actionTypeMore = 1;
  static const int actionTypeDelete = 2;

  String url;
  int? actionType;///1更多 2删除

  VideoArguments({required this.url, this.actionType});
}

class VideoPerviewPage extends StatefulWidget {

  static const String routeName = '/VideoPerviewPage';

  const VideoPerviewPage({Key? key}) : super(key: key);

  @override
  State<VideoPerviewPage> createState() => _VideoPerviewPageState();
}

class _VideoPerviewPageState extends State<VideoPerviewPage> {

  late VideoArguments _arguments;

  @override
  void initState() {
    _arguments = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: VidwoPlayWidget(path: _arguments.url,),
      actions: [
        if(_arguments.actionType == VideoArguments.actionTypeDelete)
          TapWidget(onTap: () {
            NavigatorUtils.pop(VideoArguments.actionTypeDelete);
          },
          child: const Icon(Icons.delete,color: Colours.black,))
      ],
    );
  }
}
