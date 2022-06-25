package com.example.charco.wechat

import cn.leancloud.LCLogger
import cn.leancloud.LeanCloud
import cn.leancloud.im.LCIMOptions
import com.baidu.mapapi.base.BmfMapApplication

/**
 * Created 2022/4/27 17:48
 * Author:charcolee
 * Version:V1.0
 * ----------------------------------------------------
 * 文件描述：
 * ----------------------------------------------------
 */
class MyApplication : BmfMapApplication()  {

    override fun onCreate() {
        super.onCreate()
        //开启未读消息数更新通知
        LCIMOptions.getGlobalOptions().setUnreadNotificationEnabled(true)
        //开启调试日志
        LeanCloud.setLogLevel(LCLogger.Level.DEBUG)
        // 提供 this、App ID、App Key、Server Host 作为参数
        // 请将 xxx.example.com 替换为你的应用绑定的 API 域名
        LeanCloud.initialize(this, "JN2Q4XReVkr7sQYEmma3bT6R-MdYXbMMI", "pgktbsL98hKS2hzdi3OeJ8Pe", null)
    }
}