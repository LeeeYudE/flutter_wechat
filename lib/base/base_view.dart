import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_getx.dart';
import 'common_state_widget_x.dart';

///获取controller的 baseView, 这里要在路由里声明 controller
abstract class BaseView<T> extends GetView<T> {
  const BaseView({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    debugPrint('charco, createElement=> build-$this');
    onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint('charco, createElement=> onReady-$this');
      onReady();
    });
    return super.createElement();
  }

  ///ui build之前，可以设置数据
  void onInit() {}

  ///初始化数据
  void onReady() {}
}

///获取controller的 baseView, 这里要在路由里声明 controller
abstract class BaseGetBuilder<T extends GetxController> extends GetView<T> {

  BaseGetBuilder({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    debugPrint('charco, createElement=> build-$this');
    onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint('charco, createElement=> onReady-$this');
      onReady();
    });
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
        init: getController()??controller,
        builder: (controller) {
         return controllerBuilder(context,controller);
        });
  }

  Widget controllerBuilder(BuildContext context, T controller);

  ///获取控制器，为null会直接使用默认的
  T? getController();

  ///ui build之前，可以设置数据
  void onInit() {}

  ///初始化数据
  void onReady() {}

}

