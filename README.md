# wechat

A new Wechat project.

# 介绍
wechat_flutter是flutter版微信，目前只支持Android端，功能还在持续迭代，尽量还原原版微信功能。
Flutter版本：3.0.0 


#测试账号 18202003769 密码 Bb123456

下载体验(Android)
[https://github.com/LeeeYudE/flutter_wechat/releases/download/v1.0.4/app-release.apk](https://github.com/LeeeYudE/flutter_wechat/releases/download/v1.0.4/app-release.apk)

<img src="screenshot/qrcode.png" style="zoom:30%;" />

# 效果图

| ![1.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master/screenshot/screenshot0.gif)            | ![2.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master/screenshot/screenshot1.gif)           | ![3.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master/screenshot/screenshot9.gif)          |
|--------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| ![4.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master/screenshot/screenshot3.gif)            | ![5.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master/screenshot/screenshot4.gif)           | ![6.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master/screenshot/screenshot5.gif)          |
|--------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------|
| ![7.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master/screenshot/screenshot6.gif)            | ![8.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master//screenshot/screenshot7.gif)          | ![9.gif](https://github.com/LeeeYudE/flutter_wechat/blob/master/screenshot/screenshot8.gif)          |


#Api方案采用Leancloud
* 数据存储文档：https://zh-docs.leancloud.app/leanstorage_guide-flutter.html
* IM聊天文档：https://zh-docs.leancloud.app/realtime-guide-beginner.html

# log
* 2022.08.22 增加聊天通知栏弹出，增加修改昵称。
* 2022.08.19 聊天页增加（录音/图片/视频/文件）消息发送流程。
* 2022.08.18 首页增加Uniapp小程序跳转，设置页增加小程序wgt文件上传。
* 2022.08.15 增加视频号流程，支持上传视频。
* 2022.08.02 创建朋友圈增加定位选择流程。
* 2022.08.01 完成摇一摇页面,增加朋友圈点赞/评论流程。
* 2022.07.30 增加朋友圈列表数据显示。
* 2022.07.26 创建朋友圈页面，完成朋友圈创建流程。
* 2022.07.26 增加聊天详情页面，增加多语言设置。
* 2022.07.20 增加会话已读/置顶/删除功能。
* 2022.07.20 增加创建群聊流程，增加修改头像功能。
* 2022.07.13 发送红包增加支付流程（支持密码支付和指纹支付）,聊天记录支持加载更多。
* 2022.07.12 聊天增加发送红包流程。
* 2022.07.06 增加会话未读数量显示，增加消息接收流程，扫一扫增加文件选择流程。
* 2022.07.05 增加发送文本消息流程，增加发送位置信息流程。
* 2022.07.02 创建聊天页面，完成聊天页面底部输入交互。 
* 2022.06.30 好友详情增加创建会话流程，聊天TAB增加会话数据显示。
* 2022.06.29 创建设置页面（支持退出登录），创建好友详情页面（支持发送好友申请），创建好友申请列表页面，联系人TAB增加好友列表显示。
* 2022.06.27 创建主页面，创建二维码名片页面（支持名片二维码保存到本地），创建好友搜索页面。
* 2022.06.25 完成登录和注册流程

# todo
* 视频播放器增加缓存
* 寻找好心人适配iOS平台。

# git type用于说明 commit 的类别，只允许使用下面7个标识
* feat：新功能（feature）
* fix：修补bug
* docs：文档（documentation）
* style： 格式（不影响代码运行的变动）
* refactor：重构（即不是新增功能，也不是修改bug的代码变动）
* test：增加测试
* chore：构建过程或辅助工具的变动

# 第三方框架

| 库                            | 功能        |
|------------------------------|-----------|
| leancloud                    | 即时通讯和数据储存 |
| getx                         | 状态管理      |
| cached_network_image         | 图片缓存      |
| wechat_assets_picker         | 微信选图      |
| wechat_camera_picker         | 微信拍照      |
| flutter_baidu_mapapi_map     | 百度地图      |
| flustars                     | 常用工具类     |
| permission_handler           | 权限申请      |
| extended_image_library       | 图片预览      |
| webview_flutter              | web页面     |
| image_gallery_saver          | 保存图片      |
| flutter_audio_recorder2      | 录音        |
| extended_text_field          | 富文本输入     |
| flutter_luban                | 图片压缩      |
| qr_code_scanner              | 扫一扫       |
| flutter_local_auth_invisible | 生物验证      |
| chewie                       | 视频播放      |
| video_compress               | 视频压缩      |
| video_editor                 | 视频编辑      |
| audioplayers                 | 音频播放      |
| flutter_local_notifications  | 本地通知      |
| lottie                       | lottie动画  |

项目部分参考： https://github.com/fluttercandies/wechat_flutter
如有什么微信的功能需要开发，欢迎提到Issues。

