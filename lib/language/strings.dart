// ignore_for_file: constant_identifier_names



import 'package:wechat/language/string_cn.dart';
import 'package:wechat/language/string_en.dart';

///获取资源
///IntlUtil.getString(context, Ids.appName)
class Ids {
  static const String appName = 'app_name';
  static const String confirm = 'confirm';
  static const String cancel = 'cancel';
  static const String languageSelect = 'language_select';
  static const String languageZH = 'language_zh';
  static const String languageSimpleZH = 'languageSimpleZH';
  static const String languageEN = 'language_en';
  static const String language = 'language';
  static const String themeColor = 'themeColor';
  static const String setting = 'setting';
  static const String no_data = 'no_data';
  static const String psw_lable = 'psw_lable';
  static const String account = 'account';
  static const String password = 'password';
  static const String input_account = 'input_account';
  static const String input_password = 'input_password';
  static const String set_gesture_password_hint = 'set_gesture_password_hint';
  static const String set_gesture_password = 'set_gesture_password';
  static const String confim_gesture_password = 'confim_gesture_password';
  static const String check_gesture_password = 'check_gesture_password';
  static const String reset_gesture_password = 'reset_gesture_password';
  static const String set_fingerprint_password = 'set_fingerprint_password';
  static const String close_fingerprint_password = 'close_fingerprint_password';
  static const String check_fingerprint = 'check_fingerprint';
  static const String reset_fingerprint = 'reset_fingerprint';
  static const String check_fingerprint_error = 'check_fingerprint_error';
  static const String enter_home = 'enter_home';
  static const String copy_success = 'copy_success';
  static const String change_theme_color = 'change_theme_color';
  static const String select_unlock_method = 'select_unlock_method';
  static const String unlock_method = 'unlock_method';
  static const String fingerprint_unlock = 'fingerprint_unlock';
  static const String gesture_unlock = 'gesture_unlock';
  static const String retry = 'retry';
  static const String tips = 'tips';
  static const String password_error = 'password_error';

  static const String phone_register = 'phone_register';
  static const String nickname = 'nickname';
  static const String nickname_example = 'nickname_example';
  static const String country_and_area = 'con_and_area';
  static const String phone = 'phone';
  static const String phone_input_hint = 'phone_input_hint';
  static const String title_country_and_area = 'title_country_and_area';
  static const String software_licensing_and_services_ordinance_1 = 'software_licensing_and_services_ordinance_1';
  static const String software_licensing_and_services_ordinance_2 = 'software_licensing_and_services_ordinance_2';
  static const String software_licensing_and_services_ordinance_3 = 'software_licensing_and_services_ordinance_3';
  static const String agree_and_continue = 'agree_and_continue';
  static const String wachat_safety = 'wachat_safety';
  static const String drag_the_lower_slider_to_complete_the_puzzle = 'drag_the_lower_slider_to_complete_the_puzzle';
  static const String control_jigsaw_sliders = 'control_jigsaw_sliders';
  static const String register = 'register';
  static const String login = 'login';
  static const String check_machine_success = 'check_machine_success';
  static const String check_machine_error = 'check_machine_error';
  static const String loading = 'loading';
  static const String waiting = 'waiting';
  static const String safety_verify = 'safety_verify';
  static const String register_safety_verify = 'register_safety_verify';
  static const String start = 'start';
  static const String registering = 'registering';
  static const String register_success = 'register_success';
  static const String goto_login = 'goto_login';
  static const String phone_login = 'phone_login';
  static const String phone_only_use_check = 'phone_only_use_check';
  static const String user_no_exist = 'user_no_exist';
  static const String passowrd_too_short = 'passowrd_too_short';

  static const String wachat = 'wachat';
  static const String contacts = 'contacts';
  static const String discover = 'discover';
  static const String mine = 'mine';

  static const String create_chat = 'create_chat';
  static const String add_friend = 'add_friend';
  static const String scan = 'scan';
  static const String receive_payment  = 'receive_payment';

  static const String qrcode_business_card  = 'qrcode_business_card';
  static const String scan_qrcode_business_card  = 'scan_qrcode_business_card';
  static const String save_to_phone  = 'save_to_phone';
  static const String save_success  = 'save_success';
  static const String save_fail  = 'save_fail';
  static const String no_permission  = 'no_permission';
  static const String new_friend  = 'new_friend';
  static const String group_chat  = 'group_chat';
  static const String lable  = 'lable';
  static const String accound_and_phone  = 'accound_and_phone';
  static const String my_wechat_id  = 'my_wechat_id';
  static const String search  = 'search';


}

///不需要翻译的文案
const Map<String, String> noTranslate = {
  Ids.languageZH: '简体中文',
  Ids.languageEN: 'English',
  Ids.languageSimpleZH: '中文',
};

const Map<String, Map<String, String>> localizedSimpleValues = {
  //简体中文
  'zh_CN': languageChinese,
  //英文
  'en_US': languageEnglish,
};
