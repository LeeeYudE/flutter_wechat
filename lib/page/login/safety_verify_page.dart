import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/login/verify_machine_page.dart';
import 'package:wechat/page/login/widget/verify_machine_widget.dart';
import 'package:wechat/widget/common_btn.dart';
import '../../color/colors.dart';
import '../../language/strings.dart';
import '../../utils/navigator_utils.dart';
import '../../widget/base_scaffold.dart';

class SafetyVerifyPage extends StatelessWidget {

  static const String routeName = '/SafetyVerifyPage';

  const SafetyVerifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appbarColor: Colours.white,
      backIcon: Icons.close,
      body: _buildBody(context),
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
          Text(Ids.safety_verify.str(),style: TextStyle(color: Colours.c_212129,fontSize: 48.sp,fontWeight: FontWeight.bold),),
          20.sizedBoxH,
          Text(Ids.register_safety_verify.str(),style: TextStyle(color: Colours.c_212129,fontSize: 32.sp),),
          const Spacer(),
          CommonBtn(text: Ids.start.str(), width: 300.w, height: 80.w, onTap: () async {
           var result = await NavigatorUtils.toNamed(VerifyMachinePage.routeName);
           if(result != null){
             NavigatorUtils.pop(result);
           }
          },backgroundColor: Colours.theme_color,),
          40.sizedBoxH,
        ],
      ),
    );
  }
}
