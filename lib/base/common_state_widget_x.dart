import 'package:flutter/material.dart';

import 'app_ui.dart';
import 'base_getx.dart';

class CommonStateWidgetX extends StatelessWidget {

  BaseXController controller;
  WidgetBuilder widgetBuilder;
  VoidCallback? errorCallback;

  CommonStateWidgetX({required this.controller,required this.widgetBuilder,this.errorCallback});

  @override
  Widget build(BuildContext context) {
    return controller.state == ViewState.Idle ?
    widgetBuilder(context) : controller.state == ViewState.Error ? AppUI.instance.errorPage(context,() {
      errorCallback?.call();
    }):controller.state == ViewState.Empty ? AppUI.instance.emptyPage(context,() { }) :AppUI.instance.loadingPage(context);

  }
}
