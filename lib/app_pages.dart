import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wechat/page/login/login_phone_check_page.dart';
import 'package:wechat/page/login/login_phone_page.dart';
import 'package:wechat/page/login/register_page.dart';
import 'package:wechat/page/login/register_success_page.dart';
import 'package:wechat/page/login/safety_verify_page.dart';
import 'package:wechat/page/login/splash_page.dart';
import 'package:wechat/page/login/verify_machine_page.dart';
import 'package:wechat/page/login/zone_code_page.dart';
import 'package:wechat/page/main/chat/chat_detail_page.dart';
import 'package:wechat/page/main/chat/chat_group_edit_name_page.dart';
import 'package:wechat/page/main/chat/chat_page.dart';
import 'package:wechat/page/main/chat/page/pay_password/pay_password_page.dart';
import 'package:wechat/page/main/chat/page/red_packet/red_packet_preview_page.dart';
import 'package:wechat/page/main/chat/page/red_packet/send_red_packet_page.dart';
import 'package:wechat/page/main/chat/qrcode_group_chat_page.dart';
import 'package:wechat/page/main/contacts/select_friend_page.dart';
import 'package:wechat/page/main/contacts/add_friend_page.dart';
import 'package:wechat/page/main/contacts/friend_detail_page.dart';
import 'package:wechat/page/main/contacts/new_friend_page.dart';
import 'package:wechat/page/main/contacts/search_friend_page.dart';
import 'package:wechat/page/main/map/preview_loctaion_page.dart';
import 'package:wechat/page/main/map/select_location_page.dart';
import 'package:wechat/page/main/mine/language_setting_page.dart';
import 'package:wechat/page/main/mine/setting_page.dart';
import 'package:wechat/page/main/discover/scan_qrcode_page.dart';
import 'package:wechat/page/main/main_page.dart';
import 'package:wechat/page/main/mine/qrcode_business_card_page.dart';
import 'package:wechat/page/main/mine/user_info_page.dart';
import 'package:wechat/page/util/crop_image_page.dart';
import 'package:wechat/page/util/photo_preview_page.dart';
import 'package:wechat/page/util/webview_page.dart';

class AppPages {

  static final List<GetPage> routes = [

    _getPage(
      name: '/',
      page: () => SplashPage(),
    ),
    _getPage(
      name: RegisterPage.routeName,
      page: () => RegisterPage(),
    ),
    _getPage(
      name: CropImagePage.routeName,
      page: () => CropImagePage(),
    ),
    _getPage(
      name: ZoneCodePage.routeName,
      page: () => ZoneCodePage(),
    ),
    _getPage(
      name: WebViewPage.routeName,
      page: () => const WebViewPage(),
    ),
    _getPage(
      name: VerifyMachinePage.routeName,
      page: () => const VerifyMachinePage(),
    ),
    _getPage(
      name: SafetyVerifyPage.routeName,
      page: () => const SafetyVerifyPage(),
    ),
    _getPage(
      name: RegisterSuccessPage.routeName,
      page: () => const RegisterSuccessPage(),
    ),
    _getPage(
      name: LoginPhoneCheckPage.routeName,
      page: () => LoginPhoneCheckPage(),
    ),
    _getPage(
      name: LoginPhonePage.routeName,
      page: () => LoginPhonePage(),
    ),
    _getPage(
      name: MainPage.routeName,
      page: () => const MainPage(),
    ),
    _getPage(
      name: ScanQrcodePage.routeName,
      page: () => const ScanQrcodePage(),
    ),
    _getPage(
      name: QrcodeBusinessCardPage.routeName,
      page: () => const QrcodeBusinessCardPage(),
    ),
    _getPage(
      name: AddFriendPage.routeName,
      page: () => const AddFriendPage(),
    ),
    _getPage(
      name: SearchFriendPage.routeName,
      page: () => SearchFriendPage(),
    ),
    _getPage(
      name: FriendDetailPage.routeName,
      page: () => FriendDetailPage(),
    ),
    _getPage(
      name: SettingPage.routeName,
      page: () => const SettingPage(),
    ),
    _getPage(
      name: NewFriendPage.routeName,
      page: () => NewFriendPage(),
    ),
    _getPage(
      name: ChatPage.routeName,
      page: () => ChatPage(),
    ),
    _getPage(
      name: SelectLocationPage.routeName,
      page: () => SelectLocationPage(),
    ),
    _getPage(
      name: PreviewLocationPage.routeName,
      page: () => PreviewLocationPage(),
    ),
    _getPage(
      name: PhotoPreviewPage.routeName,
      page: () => PhotoPreviewPage(),
      opaque: false,
      fullscreenDialog:true,
    ),
    _getPage(
      name: SendRedPacketPage.routeName,
      page: () => SendRedPacketPage(),
    ),
    _getPage(
      name: RedPacketPreviewPage.routeName,
      page: () => RedPacketPreviewPage(),
      opaque: false,
      transition: Transition.fade,
      fullscreenDialog:true
    ),
    _getPage(
      name: PayPasswordPage.routeName,
      page: () => const PayPasswordPage(),
      transition: Transition.fade,
      opaque: false,
      fullscreenDialog:true
    ),
    _getPage(
      name: SelectFriendPage.routeName,
      page: () => const SelectFriendPage(),
    ),
    _getPage(
      name: UserCenterPage.routeName,
      page: () => const UserCenterPage(),
    ),
    _getPage(
      name: ChatDetailPage.routeName,
      page: () => ChatDetailPage(),
    ),
    _getPage(
      name: QrcodeGroupChatPage.routeName,
      page: () => const QrcodeGroupChatPage(),
    ),
    _getPage(
      name: ChatGroupEditNamePage.routeName,
      page: () => const ChatGroupEditNamePage(),
    ),
    _getPage(
      name: LanguageSettingPage.routeName,
      page: () => const LanguageSettingPage(),
    ),
  ];

  static GetPage _getPage({
    required String name,
    required GetPageBuilder page,
    Bindings? binding,
    Transition? transition,
    bool opaque = true,
    bool fullscreenDialog = false
  }) {
    return GetPage(
      name: name,
      binding: binding,
      opaque: opaque,///是否透明页面
      transition: transition,///页面过度效果
      fullscreenDialog: fullscreenDialog,
      page: () {
        debugPrint('pageName=$name');
        return page();
      },
    );
  }
}

class CommonBinding<S> extends Bindings {
  final InstanceBuilderCallback<S> builder;

  CommonBinding(this.builder);

  @override
  void dependencies() {
    Get.lazyPut<S>(builder);
  }
}
