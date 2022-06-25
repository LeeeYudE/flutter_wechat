import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../color/colors.dart';
import '../language/strings.dart';
import '../widget/load_widget.dart';
import 'package:wechat/core.dart';

/// @author Barry
/// @date 2020/11/17
/// describe:需要复写的一些AppUi相关基类
abstract class AbstractAppUI {
  //错误页面
  Widget errorPage(BuildContext context,VoidCallback refreshCallback);

  //加载页面
  Widget loadingPage(BuildContext context);

  //空页面
  Widget emptyPage(BuildContext context,VoidCallback refreshCallback);

}

class AppUI extends AbstractAppUI {
  static final AppUI _instance = AppUI();

  static AppUI get instance => _instance;

  @override
  Widget emptyPage(BuildContext context,VoidCallback refreshCallback) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: refreshCallback,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children:  <Widget>[
            const Spacer(flex: 1),
            Icon(FontAwesomeIcons.list,size: 100.w,color: Colours.primaryColor(context),),
            Container(height: 20.w,),
            Text(Ids.no_data.str(),style: TextStyle(color: Colours.primaryColor(context),fontSize: 32.sp),),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }



  @override
  Widget errorPage(BuildContext context,VoidCallback refreshCallback) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Text('网络异常',style: TextStyle(color:Colours.primaryColor(context),fontSize: 32.sp),),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  @override
  Widget loadingPage(BuildContext context) {
    return Column(
      children:  [
        const Spacer(flex: 1),
        LoadWidget(size: 100.w,color: Colours.primaryColor(context)),
        const Spacer(flex: 2),
      ],
    );
  }



}
