import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_official_plugin/leancloud_plugin.dart';
import 'package:wechat/controller/member_controller.dart';
import 'package:wechat/controller/user_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/widget/clip_rect_widget.dart';
import '../../../../color/colors.dart';

var row = 0, column = 0;

class ChatAvatar extends StatelessWidget {

  double size = 100.w;

  double padding = 5.w;

  double margin = 2.w;

  final Conversation conversation;

  ChatAvatar({required this.conversation, Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var memberController = MemberController.instance;
    var userController = UserController.instance;

    if(conversation.isSingle){///单聊
      String? avatar;
      conversation.members?.forEach((username) {
        if(username != userController.username){
          avatar = memberController.getMember(username)?.avatar;
        }
      });

      return AvatarWidget(avatar: avatar, weightWidth: 100.w);

    }else{

      List<String> avatars = [];

      conversation.members?.forEach((username) {
          var avatar = memberController.getMember(username)?.avatar;
          if(avatars.length < 9){
            avatars.add(avatar??'');
          }
      });

      var childCount = avatars.length;

      var columnMax;

      List icons = [];

      List<Widget> stacks = [];

      // 五张图片之后(包含5张)，每行的最大列数是3

      var imgWidth;

      if (childCount >= 5) {
        columnMax = 3;

        imgWidth = (size - (padding * columnMax) - margin.w) / columnMax;
      } else {
        columnMax = 2;

        imgWidth = (size - (padding * columnMax) - margin.w) / columnMax;
      }
      for (var i = 0; i < childCount; i++) {
        icons.add(_weChatGroupChatChildIcon(avatars[i], imgWidth));
      }

      row = 0;

      column = 0;

      var centerTop = 0.0;

      if (childCount == 2 || childCount == 5 || childCount == 6) {
        centerTop = imgWidth / 2;
      }

      for (var i = 0; i < childCount; i++) {
        var left = imgWidth * row + padding * (row + 1);

        var top = imgWidth * column + padding * column + centerTop;

        switch (childCount) {
          case 3:
          case 7:
            _topOneIcon(stacks, icons[i], childCount, i, imgWidth, left, top);
            break;
          case 5:
          case 8:
            _topTwoIcon(stacks, icons[i], childCount, i, imgWidth, left, top);
            break;
          default:
            _otherIcon(stacks, icons[i], childCount, i, imgWidth, left, top, columnMax);
            break;
        }
    }
      return ClipRectWidget(
        child: Container(
          width: size,
          height: size,
          color: Colours.c_EEEEEE,
          padding: EdgeInsets.only(
            top: padding.w,
          ),
          alignment: AlignmentDirectional.bottomCenter,
          child: Stack(
            children: stacks,
          ),
        ),
      );
    }

  }

  _weChatGroupChatChildIcon(String avatar, double width) {
    return AvatarWidget(weightWidth: width, avatar: avatar,borderRadius: 4.w,);
  }

// 顶部为一张图片

  _topOneIcon(List stacks, Widget child, int childCount, i, imgWidth, left, top) {
    if (i == 0) {
      var firstLeft = imgWidth / 2 + left + margin / 2;

      if (childCount == 7) {
        firstLeft = imgWidth + left + margin;
      }

      stacks.add(Positioned(
        child: child,
        left: firstLeft,
      ));

      row = 0;
      column++;
    } else {
      stacks.add(Positioned(
        child: child,
        left: left,
        top: top,
      ));
      row++;

      if (i == 3) {
        row = 0;
        column++;
      }
    }
  }

// 顶部为两张图片

  _topTwoIcon(List stacks, Widget child, int childCount, i, imgWidth, left, top) {
    if (i == 0 || i == 1) {
      stacks.add(Positioned(
        child: child,
        left: imgWidth / 2 + left + margin / 2,
        top: childCount == 5 ? top : 0.0,
      ));
      row++;
      if (i == 1) {
        row = 0;
        column++;
      }
    } else {
      stacks.add(Positioned(
        child: child,
        left: left,
        top: top,
      ));
      row++;
      if (i == 4) {
        row = 0;
        column++;
      }
    }
  }

  _otherIcon(List stacks, Widget child, int childCount, i, imgWidth, left, top, columnMax) {
    stacks.add(Positioned(
      child: child,
      left: left,
      top: top,
    ));
    row++;
    if ((i + 1) % columnMax == 0) {
      row = 0;
      column++;
    }
  }
}
