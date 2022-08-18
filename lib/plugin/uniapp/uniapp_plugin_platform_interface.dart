import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'uniapp_plugin_method_channel.dart';


abstract class UniappPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterPluginPlatform.
  UniappPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static UniappPluginPlatform _instance = MethodChannelUniappPlugin();

  /// The default instance of [UniappPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelUniappPlugin].
  static UniappPluginPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [UniappPluginPlatform] when
  /// they register themselves.
  static set instance(UniappPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future releaseWgtToRunPath(String path,String appid,{String? password}) {
    throw UnimplementedError('releaseWgtToRunPath() has not been implemented.');
  }

}
