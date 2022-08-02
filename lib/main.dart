import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/base/constant.dart';
import 'package:wechat/controller/friend_controller.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/page/main/chat/model/red_packet_message.dart';
import 'package:wechat/utils/language_util_v2.dart';

import 'app_pages.dart';
import 'color/colors.dart';
import 'controller/chat_manager_controller.dart';
import 'controller/user_controller.dart';
import 'language/translation_service.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(Platform.isIOS){
    BMFMapSDK.setApiKeyAndCoordType('请输入百度开放平台申请的iOS端API KEY', BMF_COORD_TYPE.BD09LL);
  }else if(Platform.isAndroid){// Android 目前不支持接口设置Apikey,
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
  }
  // LeanCloud.initialize('ugJfJQ7FWkwaPfex5af1R5Pb-gzGzoHsz', 'qHQJqjsXzj5XK9gwGLB59OYI',server: 'https://www.douyin.com', queryCache: LCQueryCache());
  // LeanCloud.initialize('JN2Q4XReVkr7sQYEmma3bT6R-MdYXbMMI', 'pgktbsL98hKS2hzdi3OeJ8Pe', queryCache: LCQueryCache());
  LeanCloud.initialize('jjdYaY3R8guscltQUDvkKnrt-gzGzoHsz', 'Sh3f3Pw9E7wDdRnEW7ik3dIU',server: 'https://jjdyay3r.lc-cn-n1-shared.com', queryCache: LCQueryCache());
  JmessageFlutter().init(isOpenMessageRoaming: true, appkey: Constant.JMESSAGE_APP_KEY);
  await SpUtil.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
  if(Platform.isAndroid) {
    initAndroid();
  }
}

void initAndroid(){
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarBrightness: Brightness.dark));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    Get.put(UserController.create(),permanent: true);
    Get.put(ChatManagerController.create(),permanent: true);
    Get.put(MemberController.create(),permanent: true);
    Get.put(FriendController.create(),permanent: true);
    ///状态栏字体颜色
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _initTypeMessage();
  }

  ///初始化自定义消息
  _initTypeMessage(){
    TypedMessage.register(() => RedPacketMessage());
  }

  @override
  Widget build(BuildContext context) {
    setDesignWHD(750.0, 1624);
    return GetMaterialApp(
      title: '微信',
      debugShowCheckedModeBanner: false,
      theme: Colours.themeData(),
      darkTheme: Colours.themeData(),
      initialRoute: '/',
      getPages: AppPages.routes,
      onGenerateRoute: (settings){
        debugPrint('onGenerateRoute ${settings.name}');
        return null;
      },
      supportedLocales: const [
        Locale('zh', 'CN'),
      ],
      navigatorObservers: [FlutterSmartDialog.observer,routeObserver],
      builder: FlutterSmartDialog.init(
        // loadingBuilder: (context,child){
        //   return Container(
        //     decoration: Colours.c_212129.boxDecoration(borderRadius: 12.w),
        //     width: 200.w,
        //     height: 200.w
        //     child: Column(
        //       children: [
        //         Text('')
        //     ],
        //   ),
        //   );
        // }
      ),
      translations: TranslationService(),
      locale: LanguageUtilV2.initLanguage().toLocale(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
