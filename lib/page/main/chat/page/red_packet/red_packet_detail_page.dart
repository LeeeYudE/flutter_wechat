import 'package:flutter/material.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/page/red_packet/widget/red_packet_top_bg.dart';
import '../../../../../controller/member_controller.dart';
import '../../../../../widget/avatar_widget.dart';
import '../../../../../widget/base_scaffold.dart';
import 'controller/red_packet_detail_contrlller.dart';

class RedPacketDetailPage extends BaseGetBuilder<RedPacketDetailController> {

  static const String routeName = '/RedPacketDetailPage';


  RedPacketDetailPage({Key? key}) : super(key: key);

  @override
  RedPacketDetailController? getController() => RedPacketDetailController();


  @override
  Widget controllerBuilder(BuildContext context, RedPacketDetailController controller) {
    return MyScaffold(
      showAppbar: false,
      body: _buildBody(context),
    );
  }


  _buildBar(){
    return SizedBox(
      height: 150.w,
      child: AppBar(
        toolbarHeight: 100.w,
        backgroundColor: Colours.transparent,
        elevation: 0,
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Stack(
      children: [
        _buildAmount(),
        CustomPaint(
          size: Size(1.0.sw, 300.w),
          painter: RedPacketTopBg(),
        ),
        _buildBar(),
      ],
    );
  }

  _buildAmount(){
    var _message = controller.message;
    var member = MemberController.instance.getMember(_message.fromClientID);
    return  Container(
      color: Colours.white,
      width: double.infinity,
      padding: EdgeInsets.only(top: 300.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AvatarWidget(avatar: member?.avatar, weightWidth: 48.w),
              10.sizedBoxW,
              Text("${MemberController.instance.getMember(_message.fromClientID)?.nickname}的红包", style: TextStyle(fontSize: 32.sp, color: Colours.black, fontWeight: FontWeight.w500),),
              10.sizedBoxW,
              Container(
                decoration: Colours.c_D48610.boxDecoration(borderRadius: 5.w),
                padding: EdgeInsets.all(5.w),
                child: Center(
                  child: Text('拼',style: TextStyle(color: Colours.white,fontSize: 24.sp,height: 1.1),),
                ),
              )
            ],
          ),
          20.sizedBoxH,
          Text(_message.text??'', style: TextStyle(fontSize: 28.sp, color: Colours.c_CCCCCC),),
          40.sizedBoxH,
          if(controller.redPacket != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                    height: 80.sp,
                    child: Text('${controller.redPacket!['amount']}',textAlign: TextAlign.center, style: TextStyle(fontSize: 96.sp, color: Colours.c_D48610,height: 1),)),
                Text('元', style: TextStyle(fontSize: 32.sp, color: Colours.c_D48610,height: 1.0),),
              ],
            ),
          100.sizedBoxH,
          Colours.c_EEEEEE.toLine(10.w),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 20.w),
            height: 100.w,
            child:(controller.redPacket != null)?
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${controller.redPacket!['packet_count']}个红包共${controller.redPacket!['amount']}元，3秒被抢光', style: TextStyle(fontSize: 28.sp, color: Colours.c_CCCCCC))):null,
          ),
          Colours.c_EEEEEE.toLine(2.w),
          20.sizedBoxH,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                AvatarWidget(avatar: member?.avatar, weightWidth: 100.w),
                20.sizedBoxW,
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${MemberController.instance.getMember(_message.fromClientID)?.nickname}", style: TextStyle(fontSize: 32.sp, color: Colours.black),),
                      Text("8月2日 19:35", style: TextStyle(fontSize: 24.sp, color: Colours.c_CCCCCC),),
                    ],
                  ),
                ),
                if((controller.redPacket != null))
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${controller.redPacket!['amount']}元', style: TextStyle(fontSize: 32.sp, color: Colours.black,height: 1),),
                    5.sizedBoxH,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wine_bar,color:Colours.c_FA9E3B,size: 32.w,),
                        Text('手气最佳', style: TextStyle(fontSize: 24.sp, color: Colours.c_FA9E3B,height: 1),),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }


}
