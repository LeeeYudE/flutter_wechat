
import 'uniapp_plugin_platform_interface.dart';

class UniappPlugin {

  Future<String?> getPlatformVersion() {
    return UniappPluginPlatform.instance.getPlatformVersion();
  }

  releaseWgtToRunPath(String path,String appid,{String? password}) {
    UniappPluginPlatform.instance.releaseWgtToRunPath(path,appid,password: password);
  }

}
