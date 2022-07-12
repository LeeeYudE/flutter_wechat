import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/core.dart';
import 'package:wechat/language/strings.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/input_field.dart';

import '../../../../../color/colors.dart';
import '../../../../../widget/keyboard/view_keyboard.dart';
import 'controller/send_red_packet_controller.dart';

class SendRedPacketPage extends BaseGetBuilder<SendRedPacketController> {

  static const int TYPE_SINGLE = 0;///单聊红包
  static const int TYPE_GROUP = 1;///群聊红包
  static const String symbol = '¥';

  static const String routeName = '/SendRedPacketPage';

  SendRedPacketPage({Key? key}) : super(key: key);

  @override
  SendRedPacketController? getController() => SendRedPacketController();

  get isSingleType => controller.conversation.isSingle;

  @override
  Widget controllerBuilder(BuildContext context, SendRedPacketController controller) {
    return MyScaffold(
      title: Ids.send_red_packet.str(),
      body: _buildBody(context),
      onBodyClick: (){
        controller.showKeyboard.value = false;
      },
    );
  }


  _buildBody(BuildContext context) {
    return Stack(
      children: [
        _buildInput(),
        _buildKeyboard()
      ],
    );
  }

  _buildInput(){
    return Column(
      children: [
        _buildWarningHint(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if(!isSingleType)
                _buildGroupHint(),
              if(!isSingleType)
                _buildRedPacketCount(),
              20.sizedBoxH,
              _buildInputAmount(),
              40.sizedBoxH,
              _buildHint(),
              60.sizedBoxH,
              _buildAmount(),
              40.sizedBoxH,
              _buildSendBtn()
            ],
          ),
        ),
      ],
    );
  }

  _buildGroupHint(){
    return Container(
      margin: EdgeInsets.only(bottom: 20.w),
      child: Align(
          alignment: Alignment.topLeft,
          child: Text(Ids.lucky_red_packet.str(),style: TextStyle(color: Colours.c_FA9E3B,fontSize: 28.sp),)),
    );
  }

  _buildWarningHint(){
    return Obx(()=>Offstage(
      offstage: controller.warningHint.isEmpty,
      child: Container(
        color: Colours.c_FA9E3B,
        child: Center(
          child: Text(controller.warningHint.value,style: TextStyle(color: Colours.white,fontSize: 24.sp),),
        ),
      ),
    ));
  }

  _buildRedPacketCount(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 100.w,
          decoration: Colours.white.boxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.w),
          child: Row(
            children: [
              Text(Ids.red_packet_count.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),),
              const Spacer(),
              SizedBox(
                  width: 200.w,
                  child: InputField(hint: Ids.input_count.str(),controller: controller.countController,inputType:TextInputType.phone,textAlign: TextAlign.end,
                    lengthLimiting: 3,inputFormatter:FilteringTextInputFormatter.digitsOnly,)),
              Text(Ids.count.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),)
            ],
          ),
        ),
        Text(Ids.group_member_count.str().sprint(['${controller.conversation.members?.length??0}']),style: TextStyle(color: Colours.c_999999,fontSize: 24.sp),)
      ],
    );
  }

  _buildInputAmount(){
    return Container(
      height: 100.w,
      decoration: Colours.white.boxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.w),
      child: Row(
        children: [
            Text(isSingleType?Ids.single_red_packet_amount.str():Ids.total_amount.str(),style: TextStyle(color: Colours.black,fontSize: 32.sp),),
            const Spacer(),
            SizedBox(
                width: 200.w,
                child: InputField(hint: '${symbol}0.00',controller: controller.amountController,readOnly: true,textAlign: TextAlign.end,
                lengthLimiting: 10,
                onTap: (){
                    controller.showKeyboard.value = true;
                },))
        ],
      ),
    );
  }

  _buildHint(){
    return Container(
      height: 130.w,
      decoration: Colours.white.boxDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InputField(hint: Ids.red_packet_hint.str(),controller: controller.hintController, lengthLimiting: 10,
    ),
      ));
  }

  _buildAmount(){
    String amount = controller.amountController.text;
    if(amount.isEmpty){
      amount = '0.00';
    }else{
      try{
        amount = double.parse(amount.replaceAll(symbol, '')).formatDecimals;
      }catch (e){
        amount = '0.00';
      }

    }
    return Center(
      child: Text('$symbol$amount',style: TextStyle(color: Colours.black,fontSize: 80.sp,fontWeight: FontWeight.bold),),
    );
  }

  _buildSendBtn(){
    return CommonBtn(text: Ids.slip_money_into_red_packet.str(), width: 250.w, height: 80.w, onTap: (){
      controller.sendRedPacket();
    },backgroundColor: Colours.c_FF4E32,);
  }

  _buildKeyboard(){
    return Obx(
      ()=> Offstage(
        offstage: !controller.showKeyboard.value,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: CustomKeyboard(
            showDot: true,
            pwdLength: 10,
            onKeyDown: (keyEvent) {
              if('del' == keyEvent.key){
                controller.amountController.removeLastText();
              }else{
                if(keyEvent.key == '.'){
                  if(!controller.amountController.text.contains('.')){
                    controller.amountController.insertText((controller.amountController.text.isEmpty?'0':'')+keyEvent.key);
                  }
                }else{
                  controller.amountController.insertText(keyEvent.key);
                }
              }
            },
            onResult: (data) {},
            onClose: () {},
          ),
        ),
      ),
    );
  }


}
