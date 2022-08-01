
class Utils {

  Utils._();

  static const String PNG = 'png';
  static const String WEBP = 'webp';
  static const String SVG = 'svg';


  static const String DIR_ICON = 'icon';
  static const String DIR_CHAT = 'chat';
  static const String DIR_CONTACT = 'contact';
  static const String dir_discover = 'discover';
  static const String DIR_MINE = 'mine';
  static const String DIR_EMOJI = 'emoji';

  //获取图片位置
  static String getImgPath(String name, {String format = PNG, String? dir}) {
    return 'assets/images/${dir != null ?dir+'/':''}$name.$format';
  }

  static String getIconImgPath(String name, {String format = PNG,}) {
    return 'assets/images/icon/$name.$format';
  }

  static String getChatImgPath(String name, {String format = PNG,}) {
    return 'assets/images/chat/$name.$format';
  }

  static String getJsonPath(String name) {
    return 'assets/json/$name.json';
  }

  static String getLottiePath(String name) {
    return 'assets/lottie/$name.json';
  }

}