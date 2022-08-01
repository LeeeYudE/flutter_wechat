import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../../../color/colors.dart';
import '../../../../../language/strings.dart';
import '../../../../../widget/hb_password_input_text_field.dart';
import '../../../../../widget/keyboard/view_keyboard.dart';
import '../red_packet/send_red_packet_page.dart';
import 'package:flutter_local_auth_invisible/flutter_local_auth_invisible.dart';

class PayInfoArguments {
  String hint;
  String amount;

  PayInfoArguments({required this.hint, required this.amount});
}

class PayPasswordPage extends StatefulWidget {
  static const String routeName = '/PayPasswordPage';

  const PayPasswordPage({Key? key}) : super(key: key);

  @override
  State<PayPasswordPage> createState() => _PayPasswordPageState();
}

class _PayPasswordPageState extends State<PayPasswordPage> {

  static const FINGERPRINT_STATUS_INIT = 0;
  static const FINGERPRINT_STATUS_CHECK = 1;///正在指纹识别
  static const FINGERPRINT_STATUS_ERROR = 2;///指纹识别失败

  static const int PAY_METHOD_FINGERPRINT = 0;
  static const int PAY_METHOD_PASSWORD = 1;

  int payMethod = PAY_METHOD_FINGERPRINT;
  int fingerprintChecking = FINGERPRINT_STATUS_INIT;

  late PayInfoArguments _arguments;

  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  bool get isfingerprintChecking => fingerprintChecking != FINGERPRINT_STATUS_INIT;

  @override
  void initState() {
    _arguments = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      backgroundColor: Colours.black_transparent,
      showAppbar: false,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Stack(
      children: [
        if(!isfingerprintChecking)
        _buildCenter(context),
        if(!isfingerprintChecking)
        _buildKeyboard(),
        if(isfingerprintChecking)
        _buildFingerprintChecking()
      ],
    );
  }

  _buildCenter(BuildContext context) {
    return  Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        decoration: Colours.white.boxDecoration(borderRadius: 24.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.w,
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: TapWidget(
                        onTap: () {
                          NavigatorUtils.pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colours.c_999999,
                          size: 50.w,
                        ),
                      )),
                  Center(
                    child: Text(
                      Ids.input_pay_password.str(),
                      style: TextStyle(color: Colours.black, fontSize: 28.sp),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TapWidget(
                        onTap: () {
                          setState(() {
                            payMethod =
                                payMethod == PAY_METHOD_FINGERPRINT ? PAY_METHOD_PASSWORD : PAY_METHOD_FINGERPRINT;
                          });
                        },
                        child: Text(
                          (payMethod == PAY_METHOD_FINGERPRINT) ? Ids.used_fingerprint.str() : Ids.used_password.str(),
                          style: TextStyle(color: Colours.c_5B6B8D, fontSize: 32.sp),
                        )),
                  )
                ],
              ),
            ),
            40.sizedBoxH,
            Text(
              _arguments.hint,
              style: TextStyle(color: Colours.black, fontSize: 28.sp),
            ),
            4.sizedBoxH,
            Text(
              SendRedPacketPage.symbol + _arguments.amount,
              style: TextStyle(color: Colours.black, fontSize: 64.sp, fontWeight: FontWeight.bold),
            ),
            40.sizedBoxH,
            Colours.line.toLine(1.w),
            20.sizedBoxH,
            Row(
              children: [
                Text(
                  Ids.pay_method.str(),
                  style: TextStyle(color: Colours.c_999999, fontSize: 28.sp),
                ),
                const Spacer(),
                Text(
                  Ids.loose_change.str(),
                  style: TextStyle(color: Colours.c_999999, fontSize: 28.sp),
                ),
                Image.asset(
                  Utils.getIconImgPath('icon_loose_change'),
                  width: 28.sp,
                  height: 28.sp,
                ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colours.c_999999,
                  size: 25.w,
                )
              ],
            ),
            20.sizedBoxH,
            (payMethod == PAY_METHOD_FINGERPRINT)
                ? SizedBox(
                    height: 80.w,
                    child: HBPasswordInputTextField(
                      backgroundColor: Colours.transparent,
                      fillColor: Colours.c_EEEEEE,
                      borderWidth: 0,
                      borderRaiuds: 5,
                      controller: _textEditingController,
                      node: _focusNode,
                      obscureText: true,
                      obscureTextString: "🤪",
                      boxWidth: 80.w,
                      boxHeight: 80.w,
                      type: HBPasswordInputTextFieldType.BOXES,
                      length: 6,
                      textStyle: TextStyle(fontSize: 20.sp, color: Colours.theme_color),
                      onChange: (text) {
                        if (text.length == 6) {
                          if (text == '000000') {
                            NavigatorUtils.pop(true);
                          } else {
                            Ids.password_error.str().toast();
                            _textEditingController.clear();
                          }
                        }
                      },
                      borderColor: Colours.transparent,
                      spacing: 20.w,
                    ),
                  )
                : CommonBtn(
                    text: Ids.confim_pay.str(),
                    width: 250.w,
                    height: 80.w,
                    onTap: () {
                      setState(() {
                        fingerprintChecking = FINGERPRINT_STATUS_CHECK;
                      });
                      _authenticate();
                    }),
            20.sizedBoxH,
            Text(
              '${Ids.password.str()}:000000',
              style: TextStyle(color: Colours.c_999999, fontSize: 24.sp),
            ),
            20.sizedBoxH,
          ],
        ),
      ),
    );
  }

  _buildFingerprintChecking() {
    return Center(
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40.w),
            decoration: Colours.white.boxDecoration(borderRadius: 24.w),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100.w,
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: TapWidget(
                              onTap: () {
                                LocalAuthentication.stopAuthentication();
                                setState(() {
                                  fingerprintChecking = FINGERPRINT_STATUS_INIT;
                                });
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                color: Colours.c_999999,
                                size: 50.w,
                              ))),
                    ],
                  ),
                ),
                40.sizedBoxH,
                Icon(
                  FontAwesomeIcons.fingerprint,
                  size: 100.w,
                  color: fingerprintChecking == FINGERPRINT_STATUS_CHECK ? Colours.c_999999:Colours.c_E63E24,
                ),
                40.sizedBoxH,
                Text(
                  fingerprintChecking == FINGERPRINT_STATUS_CHECK?Ids.check_fingerprint.str():Ids.check_fingerprint_error.str(),
                  style: TextStyle(color: fingerprintChecking == FINGERPRINT_STATUS_CHECK ? Colours.c_999999:Colours.c_E63E24, fontSize: 32.sp),
                ),
                40.sizedBoxH,
              ],
            )));
  }

  _buildKeyboard() {
    return Offstage(
      offstage: payMethod == PAY_METHOD_PASSWORD,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CustomKeyboard(
          showDot: false,
          showClose: false,
          onKeyDown: (keyEvent) {
            if ('del' == keyEvent.key) {
              _textEditingController.removeLastText();
            } else {
              if (keyEvent.key == '.') {
                if (!_textEditingController.text.contains('.')) {
                  _textEditingController.insertText(keyEvent.key);
                }
              } else {
                _textEditingController.insertText(keyEvent.key);
              }
            }
          },
          onResult: (data) {},
          onClose: () {},
        ),
      ),
    );
  }

  _authenticate() async {

    bool didAuthenticate = await LocalAuthentication.authenticate(localizedReason: Ids.check_fingerprint.str(),  useErrorDialogs: true,);
    if(didAuthenticate){
      NavigatorUtils.pop(true);
    }else{
      setState(() {
        fingerprintChecking = FINGERPRINT_STATUS_ERROR;
      });
    }
  }

}
