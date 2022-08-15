import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/avatar_widget.dart';

import '../../../../../../language/strings.dart';

class ChannelsCommentItem extends StatelessWidget {

  LCObject comment;

  ChannelsCommentItem({required this.comment,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w,right: 20.w,top: 20.w,bottom: 20.w),
      child: Row(
        children: [
          AvatarWidget(avatar: comment['user']['avatar'], weightWidth: 80.w),
          20.sizedBoxW,
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(comment['user']['nickname'],style: TextStyle(color: Colours.c_5B6B8D,fontSize: 28.sp),),
                  10.sizedBoxW,
                  Text(comment.createdAt?.millisecondsSinceEpoch.commonDateTime(showTime: true)??'',style: TextStyle(color: Colours.c_CCCCCC,fontSize: 28.sp),),
                ],
              ),
              20.sizedBoxH,
              // Text(comment['comment']),
              ExpandableText(
                comment['comment'],
                expandText: Ids.full_text.str(),
                collapseText: Ids.expandable_text.str(),
                maxLines: 2,
                linkColor: Colours.black,
                style: TextStyle(color: Colours.black,fontSize: 28.sp),
              )
            ],
          ))
        ],
      ),
    );
  }
}
