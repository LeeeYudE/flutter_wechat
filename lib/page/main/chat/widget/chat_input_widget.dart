import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/main/chat/widget/press_record_widget.dart';
import 'package:wechat/page/main/chat/widget/send_message_btn.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../../utils/emoji_text.dart';
import '../../../../widget/input_field.dart';
import '../../../../widget/subscription_mixin.dart';
import '../controller/chat_controller.dart';
import 'chat_more_panel.dart';
import 'emoji_grid_view.dart';

class ChatInputWidget extends StatefulWidget {
  const ChatInputWidget({Key? key}) : super(key: key);

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> with WidgetsBindingObserver, SubscriptionMixin  {

  static const int INPUT_TYPE_NULL = 0;
  static const int INPUT_TYPE_EMOJI = 1;
  static const int INPUT_TYPE_AUDIO = 2;
  static const int INPUT_TYPE_MORE = 3;


  final FocusNode focusNode = FocusNode();
  final ChatController _chatController = Get.find();

  double _keyboardHeight = 0;
  //是否键盘弹出
  bool isKeyboard = false;
  bool autoShowKeyboard = false;
  int inputType = INPUT_TYPE_NULL;

  @override
  initState(){
    super.initState();
    _init();
  }

  void _init() async {
    WidgetsBinding.instance.addObserver(this);
    _keyboardHeight = SpUtil.getDouble('keyboardHeight', defValue: 400.w)!;
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if(mounted){
          if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
            if (isKeyboard) {
              onKeyboardHeight(0);
              FocusScope.of(context).requestFocus(FocusNode());
            }
            return;
          }
          final bottom = MediaQuery.of(context).viewInsets.bottom;
          onKeyboardHeight(bottom);
        }
      });
  }

  void onKeyboardHeight(double height) {
    // debugPrint("onKeyboardHeight $isKeyboard $height $_keyboardHeight");
    if (height == 0) {
      //关闭键盘
      if (isKeyboard) {
        setState(() {
          isKeyboard = false;
        });
      }
    } else {
      if (height < _keyboardHeight) {
        return;
      }
      autoShowKeyboard = false;
      _keyboardHeight = height;
      setState(() {
        inputType = INPUT_TYPE_NULL;
        isKeyboard = true;
      });
      SpUtil.putDouble('keyboardHeight', _keyboardHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Colours.c_CCCCCC.toLine(1.w),
        _buildInputLayout(),
        Colours.c_CCCCCC.toLine(1.w),
        _buildBottomPanel()
      ],
    );
  }

  _buildInputLayout(){
    return TapWidget(
      onTap: () {  },
      child: Container(
        color: Colours.c_F7F7F7,
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.w),
        child: Row(
          children: [
            _buildInputType(),
            20.sizedBoxW,
            Expanded(child:inputType == INPUT_TYPE_AUDIO?const PressRecordWidget(): InputField(autofocus: false,focusNode: focusNode,controller: _chatController.textController,extended: true,)),
            20.sizedBoxW,
            _buildInputEmoji(),
            20.sizedBoxW,
            _buildInputMore()
          ],
        ),
      ),
    );
  }

  _buildInputMore(){
    return Stack(
      alignment: Alignment.center,
      children: [
        TapWidget(onTap: () {
          _clickInputBtn(INPUT_TYPE_MORE);
          setState((){});
        },
        child: Image.asset(Utils.getImgPath('ic_chat_more',dir:Utils.DIR_CHAT,format:Utils.WEBP),width: 60.w,height: 60.w,color: Colours.black,)),
        const SendMessageBtn(),
      ],
    );
  }

  _buildInputType(){
    return TapWidget(onTap: () {
      _clickInputBtn(INPUT_TYPE_AUDIO);
    }, child: Image.asset(Utils.getImgPath(inputType == INPUT_TYPE_AUDIO?'ic_keyboard':'ic_voice',dir:Utils.DIR_CHAT,format:Utils.WEBP ),width: 60.w,height: 60.w,color: Colours.black,fit:BoxFit.fill));
  }

  _buildInputEmoji(){
    return TapWidget(onTap: () {
      _clickInputBtn(INPUT_TYPE_EMOJI);
    },
    child: Image.asset(Utils.getImgPath('ic_emotion',dir:Utils.DIR_CHAT,format:Utils.WEBP),width: 60.w,height: 60.w,color: Colours.black,fit:BoxFit.fill ,));
  }

  _clickInputBtn(int inputType) {
    setState(() {
      if (this.inputType == inputType) {
        this.inputType = INPUT_TYPE_NULL;
        WidgetsBinding.instance.addPostFrameCallback((_) => focusNode.showkeyboard());
        autoShowKeyboard = true;
      } else {
        this.inputType = inputType;
        if (isKeyboard) {
          _hidekeyboard();
        }
        if (inputType != INPUT_TYPE_EMOJI) {
          focusNode.unfocus();
        }
      }
    });
  }

  _hidekeyboard() {
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide').whenComplete(() {});
  }

  _buildBottomPanel(){
    // debugPrint('_buildBottomPanel $isKeyboard $inputType ');
    if ((!isKeyboard && inputType == INPUT_TYPE_NULL && !autoShowKeyboard) || inputType == INPUT_TYPE_AUDIO) {
      return Container();
    }
    Widget? child;
    if(inputType == INPUT_TYPE_MORE){
      child = ChatMorePanel();
    }else if(inputType == INPUT_TYPE_EMOJI){
      child = EmojiGridView(onTap: (EmojiModel emoji){
        insertText(emoji.tag!);
      },);
    }
    return SizedBox(
      height: _keyboardHeight,
      child: child,
    );
  }

  void insertText(String text) {
    _chatController.textController.insertText(text);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
