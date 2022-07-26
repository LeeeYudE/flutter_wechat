import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/page/main/chat/widget/chat_avatar.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';

import '../../../language/strings.dart';
import '../../../widget/common_btn.dart';
import '../../../widget/input_field.dart';

class ChatGroupEditNamePage extends StatefulWidget {

  static const String routeName = '/ChatGroupEditNamePage';

  const ChatGroupEditNamePage({Key? key}) : super(key: key);

  @override
  State<ChatGroupEditNamePage> createState() => _ChatGroupEditNamePageState();
}

class _ChatGroupEditNamePageState extends State<ChatGroupEditNamePage> {

  late Conversation _conversation;
  final _controller =  TextEditingController();

  @override
  initState(){
    _conversation = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Container(
        padding: EdgeInsets.only(top: 100.w,left: 40.w,right: 40.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Ids.edit_group_chat_name.str(),style: TextStyle(color: Colours.black,fontSize: 48.sp),),
            40.sizedBoxH,
            Colours.c_CCCCCC.toLine(1.w),
            20.sizedBoxH,
            Row(
              children: [
                ChatAvatar(conversation: _conversation,size: 80.w,),
                20.sizedBoxW,
                Expanded(child: InputField(controller: _controller,showClean: true,showDecoration: false,lengthLimiting:15 ,))
              ],
            ),
            20.sizedBoxH,
            Colours.c_CCCCCC.toLine(1.w),
            100.sizedBoxH,
            CommonBtn(height: 80.w,width: 250.w, onTap: () {
              NavigatorUtils.pop(_controller.text.trim());
            }, text: Ids.confirm.str(),enable: _controller.text.trim().isNotEmpty,)
          ],
        ),
      ),
    );
  }
}
