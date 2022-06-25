import 'package:flutter/material.dart';
import 'package:wechat/core.dart';

import '../../color/colors.dart';
import '../../language/strings.dart';
import '../../utils/navigator_utils.dart';
import '../../widget/base_scaffold.dart';
import '../../widget/common_btn.dart';

class RegisterSuccessPage extends StatelessWidget {

  static const String routeName = '/RegisterSuccessPage';

  const RegisterSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: _buildBody(context),
      showLeading: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colours.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.w,horizontal: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Icon(Icons.info,size: 100.w,color: Colours.c_4486F4,),
          40.sizedBoxH,
          Text(Ids.register_success.str(),style: TextStyle(color: Colours.c_212129,fontSize: 48.sp,fontWeight: FontWeight.bold),),
          const Spacer(),
          CommonBtn(text: Ids.goto_login.str(), width: 300.w, height: 80.w, onTap: () async {
            NavigatorUtils.pop();
          },backgroundColor: Colours.theme_color,),
          40.sizedBoxH,
        ],
      ),
    );
  }
}
