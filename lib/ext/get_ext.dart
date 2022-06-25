import 'package:flutter/material.dart';
import 'package:get/get.dart';

///用了路由才能用
extension GetExt on GetInterface {
  dismiss() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  loading({String tip = '', bool canBack = true}) {
    if (Get.isDialogOpen!) {
      Get.back();
    }
    Get.dialog(_LoadingDialog(
      tip: tip,
      canBack: canBack,
    ));
  }
}

class _LoadingDialog extends StatelessWidget {
  final String tip;
  final bool canBack;

  const _LoadingDialog({this.tip = '', this.canBack = false});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => canBack,
        child: SimpleDialog(
          key: key,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(backgroundColor: Color(0xFF999999),),
                  if (tip.isNotEmpty)
                    Text(
                      tip,
                    )
                ],
              ),
            )
          ],
        ));
  }
}
