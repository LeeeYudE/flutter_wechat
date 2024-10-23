import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/widget/chat_avatar.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../color/colors.dart';
import '../../../controller/user_controller.dart';
import '../../../language/strings.dart';
import '../../../utils/utils.dart';
import '../../../widget/avatar_widget.dart';
import '../../../widget/dialog/dialog_bottom_widget.dart';

///群聊二维码
class QrcodeGroupChatPage extends StatefulWidget {
  static const String routeName = '/QrcodeGroupChatPage';

  const QrcodeGroupChatPage({Key? key}) : super(key: key);

  @override
  State<QrcodeGroupChatPage> createState() => _QrcodeGroupChatPageState();
}

class _QrcodeGroupChatPageState extends State<QrcodeGroupChatPage> {
  final GlobalKey _repaintKey = GlobalKey(); // 可以获取到被截图组件状态的 GlobalKey
  late String _qrcode;
  late Conversation _conversation;

  @override
  void initState() {
    _conversation = Get.arguments;
    _qrcode = jsonEncode({
      'qecode_type': Constant.QRCODE_TYPE_BUSINESS_CHAT,
      'chat_id': _conversation.id
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: Ids.qrcode_business_card.str(),
      appbarColor: Colours.c_EEEEEE,
      body: _buildBody(context),
      actions: [
        TapWidget(
            onTap: () async {
              var result = await NavigatorUtils.showBottomItemsDialog(
                  [DialogBottomWidgetItem(Ids.save_to_phone.str(), 0)]);
              if (result == 0) {
                _repaintKey.doSaveImage();
              }
            },
            child: Image.asset(
              Utils.getImgPath(
                'ic_more_black',
                dir: Utils.DIR_ICON,
              ),
              width: 40.w,
              height: 40.w,
            ))
      ],
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      color: Colours.c_EEEEEE,
      padding: EdgeInsets.only(left: 40.w, right: 40.w),
      child: Center(
        child: RepaintBoundary(
          key: _repaintKey,
          child: Container(
            decoration: Colours.white.boxDecoration(borderRadius: 12.w),
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ChatAvatar(
                      conversation: _conversation,
                    ),
                    20.sizedBoxW,
                    Text(
                      _conversation.title(),
                      style: TextStyle(color: Colours.black, fontSize: 48.sp),
                    ),
                  ],
                ),
                40.sizedBoxH,
                Container(
                  width: 600.w,
                  height: 600.w,
                  color: Colours.white,
                  child: Stack(
                    children: [
                      QrImageView(
                        data: _qrcode,
                        version: QrVersions.auto,
                        size: 600.w,
                      ),
                    ],
                  ),
                ),
                40.sizedBoxH,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
