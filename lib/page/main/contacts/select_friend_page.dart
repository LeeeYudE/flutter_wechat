import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/avatar_widget.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/common_btn.dart';

import '../../../color/colors.dart';
import '../../../controller/friend_controller.dart';
import '../../../language/strings.dart';
import '../../../widget/remove_top_widget.dart';
import 'widget/friend_item.dart';

class SelectFriendArguments{
  String? title;

  SelectFriendArguments({this.title});
}


class SelectFriendPage extends StatefulWidget {

  static const String routeName = '/SelectFriendPage';

  const SelectFriendPage({Key? key}) : super(key: key);

  @override
  State<SelectFriendPage> createState() => _SelectFriendPageState();
}

class _SelectFriendPageState extends State<SelectFriendPage> {

  late SelectFriendArguments _arguments;
  final List<LCObject> _selectedList = [];
  final List<LCObject> _friends = FriendController.instance.friends;

  final IndexBarController _indexBarController = IndexBarController();
  final IndexBarDragListener _barDragListener = IndexBarDragListener.create();
  final AutoScrollController _scrollController = AutoScrollController();

  @override
  void initState() {
    _arguments = Get.arguments;
    _barDragListener.dragDetails.addListener(() {
      _scrollToTag(_barDragListener.dragDetails.value.tag);
    });
    super.initState();
  }

  _scrollToTag(String? tag){
    if(tag != null){
      int _index = -1;
      _friends.forEachIndex((index, value) {
        if(tag == value['pinyin']){
          _index = index;
          return;
        }
      });
      if(_index != -1){
        _scrollController.scrollToIndex(_index,duration: const Duration(milliseconds: 50),preferPosition:AutoScrollPosition.begin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: _arguments.title,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildSelectedFriend(),
        Expanded(child: Stack(
            children: [
              RemoveTopPaddingWidget(child: ListView.builder(itemBuilder: (context , index){
                var _friend = _friends[index];
                return AutoScrollTag(
                    key: ValueKey(index),
                    index: index,
                    controller: _scrollController,
                    child: FriendItem(friend: _friend, lastFriend: _friends.safetyItem(index-1),selectType: _selectedList.contains(_friend)?1:0,onTap: (friend){
                        if(_selectedList.contains(friend)){
                          _selectedList.remove(friend);
                        }else{
                          _selectedList.add(friend);
                        }
                        setState(() {});
                    },));
              },itemCount: _friends.length,controller: _scrollController,)),
              _buildIndexBar(),
            ],
        )),
        _buildBottom()
      ],
    );
  }

  Widget _buildSelectedFriend(){
    return Container(
      height: 100.w,
      width: double.infinity,
      color: Colours.white,
      padding: EdgeInsets.only(left: 20.w,bottom: 20.w,top: 20.w),
      child: RemoveTopPaddingWidget(
        child: ListView.builder(itemBuilder: (context , index){
          return Container(
            margin: EdgeInsets.only(right: 10.w),
            width: 60.w,
            height: 60.w,
              child: AvatarWidget(avatar: _selectedList[index]['followee']['avatar'], weightWidth: 60.w));
        },itemCount: _selectedList.length,scrollDirection:Axis.horizontal ,),
      ),
    );
  }

 Widget _buildIndexBar(){
    return Align(
      alignment: Alignment.centerRight,
      child: IndexBar(
        data: FriendController.tags,
        itemHeight: 30.w,
        margin: EdgeInsets.only(bottom: 10.w),
        indexHintBuilder: (BuildContext context, String tag){
          return Text(tag,style: TextStyle(color: Colours.c_EEEEEE,fontSize: 24.sp),);
        },
        indexBarDragListener: _barDragListener,
        controller: _indexBarController,
      ),
    );
  }

  Widget _buildBottom(){
    return Container(
      height: 100.w,
      padding: EdgeInsets.only(right: 20.w),
      child: Align(
        alignment: Alignment.centerRight,
        child: CommonBtn(height: 60.w,width: 150.w, text: '${Ids.finish.str()}${_selectedList.isNotEmpty?'(${_selectedList.length})':''}', onTap: () {
          NavigatorUtils.pop(_selectedList);
        },backgroundColor: _selectedList.isNotEmpty?Colours.theme_color:Colours.c_CCCCCC,enable:_selectedList.isNotEmpty ,),
      ),
    );
  }

}
