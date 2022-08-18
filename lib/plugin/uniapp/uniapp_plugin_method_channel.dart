import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'uniapp_plugin_platform_interface.dart';


/// An implementation of [UniappPluginPlatform] that uses method channels.
class MethodChannelUniappPlugin extends UniappPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('uniapp_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    if(Platform.isAndroid){
      final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
      return version;
    }else{
      return null;
    }
  }

  @override
  Future releaseWgtToRunPath(String filePath,String appid,{String? password}) async {
    if(Platform.isAndroid){
      var file = File(filePath);
      if(!file.existsSync()){
        return;
      }
      Map<String,String?> map = {};
      map['filePath'] = filePath;
      map['appid'] = appid;
      map['password'] = password;
      await methodChannel.invokeMethod('releaseWgtToRunPath',{'argument': map});

    }
  }



}
