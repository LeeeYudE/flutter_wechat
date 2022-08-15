import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/base_scaffold.dart';

class WebviewArguments{
  String? title;
  String? url;

  WebviewArguments({this.title,this.url});
}

class WebViewPage extends StatefulWidget {

  static const String routeName = '/WebViewPage';

  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {

  late WebviewArguments _webviewArguments;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _webviewArguments = Get.arguments;
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appbarColor: Colours.c_EEEEEE,
      title: _webviewArguments.title,
      body: WebView(
        initialUrl: _webviewArguments.url,
        onWebViewCreated: (controller){
          _controller = controller;
        },
        onPageFinished: (String url){
          _initTitle(_controller);
        },
      ),
    );
  }

  _initTitle(WebViewController controller) async {
    if(TextUtil.isEmpty(_webviewArguments.title)){
      _webviewArguments.title = await controller.getTitle();
      print('controller.getTitle() ${_webviewArguments.title}');
      setState((){});
    }
  }

}
