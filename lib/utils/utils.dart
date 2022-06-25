
class Utils {

  static const String PNG = 'png';
  static const String WEBP = 'webp';
  static const String SVG = 'svg';

  //获取图片位置
  static String getImgPath(String name, {String format = PNG, String? dir}) {
    return 'assets/images/${dir != null ?dir+'/':''}$name.$format';
  }

  //获取图片位置
  static String getJsonPath(String name) {
    return 'assets/json/$name.json';
  }

}