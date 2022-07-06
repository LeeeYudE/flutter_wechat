import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat/core.dart';
import '../load_widget.dart';


class RefreshFooter extends StatelessWidget {
  final LoadStatus? status;

  const RefreshFooter({this.status});

  @override
  Widget build(BuildContext context) {
    if (status == LoadStatus.loading) {
      return LoadWidget(size: 50.w,);
    } else {
      if (status == LoadStatus.noMore) {
        return SizedBox(
            height: 50.w,
            child: Center(child: Text('没有更多数据',style: TextStyle(color: Colors.grey,fontSize: 24.sp),)));
      } else {
        return Container();
      }
    }
  }

}
