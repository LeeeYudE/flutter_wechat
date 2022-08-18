package com.example.charco.wechat

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.example.charco.wechat.UniappPlugin

class MainActivity: FlutterFragmentActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        flutterEngine.getPlugins().add(UniappPlugin())
    }



}