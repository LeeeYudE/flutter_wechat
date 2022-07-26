import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/language_util_v2.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../language/language_model.dart';
import '../../../language/strings.dart';

class LanguageSettingPage extends StatefulWidget {

  static const String routeName = '/LanguageSettingPage';

  const LanguageSettingPage({Key? key}) : super(key: key);

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {

  LanguageModel? _selectLanguage;

  @override
  void initState() {
    _selectLanguage = LanguageUtilV2.getCurrentLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: Ids.language.str(),
      body:Column(
        children: LanguageUtilV2.getLanguages().map((e) => _buildLanguageItem(e)).toList(),
      ),
      actions: [
        CommonBtn(text: Ids.confirm.str(), width: 150.w, height:70.w , onTap: (){
          if(_selectLanguage != null) {
            LanguageUtilV2.setLocalModel(_selectLanguage!);
            NavigatorUtils.pop();
          }
        })
      ],
    );
  }

  Widget _buildLanguageItem(LanguageModel model){
    return TapWidget(
      onTap: () {
        setState(() {
          _selectLanguage = model;
        });
      },
      child: Container(
        height: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: Colours.c_CCCCCC.bottomBorder(
          bgColor: Colours.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(model.titleId?.str()??'',style: TextStyle(color: Colours.black,fontSize: 32.sp),),
            if(model == _selectLanguage)
              Image.asset(Utils.getIconImgPath('ic_selected'),width: 40.w,height: 40.w,)
          ],
        ),
      ),
    );

  }


}
