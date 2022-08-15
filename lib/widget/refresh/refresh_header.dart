import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../color/colors.dart';
import '../../utils/utils.dart';
import '../load_widget.dart';
import '../lottie_widget.dart';

class RefreshHeader extends StatelessWidget {

  final RefreshStatus? status;
  final Color? color;

  const RefreshHeader({this.status,this.color});

  @override
  Widget build(BuildContext context) {
    if(status == RefreshStatus.idle){
      return Container();
    }

    return SizedBox(
      height: ScreenUtilExt.setHeight(200),
      child: Center(
        child: LottieWidget(assetPath: Utils.getLottiePath('loading'), height: 200.w,width: 200.w,),
        // child: LoadWidget(
        //   color: color??Colours.c_EEEEEE,
        //   size: ScreenUtilExt.setHeight(200),
        // ),
      ),
    );
  }

}
