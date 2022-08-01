import 'package:flutter/cupertino.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../color/colors.dart';

class DialogBottomLayout extends StatelessWidget {

  Widget child;
  bool opaque;

  DialogBottomLayout(this.child,{Key? key,this.opaque = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showAppbar: false,
      backgroundColor: Colours.transparent,
      resizeToAvoidBottomInset: true,
      body: TapWidget(
        onTap: () {
          NavigatorUtils.pop();
        },
        child: Container(
          color: opaque?Colours.transparent:Colours.black_transparent,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: child,
              )
            ],
          ),
        ),
      ),
    );
  }
}
