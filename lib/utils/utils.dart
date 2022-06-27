
class Utils {

  static const String PNG = 'png';
  static const String WEBP = 'webp';
  static const String SVG = 'svg';


  static const String DIR_ICON = 'icon';
  static const String DIR_CHAT = 'chat';
  static const String DIR_CONTACT = 'contact';
  static const String DIR_DICOVER = 'dicover';
  static const String DIR_MINE = 'mine';

  //获取图片位置
  static String getImgPath(String name, {String format = PNG, String? dir}) {
    return 'assets/images/${dir != null ?dir+'/':''}$name.$format';
  }

  //获取图片位置
  static String getJsonPath(String name) {
    return 'assets/json/$name.json';
  }

}