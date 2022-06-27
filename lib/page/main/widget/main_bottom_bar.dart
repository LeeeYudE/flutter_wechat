import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../../../language/strings.dart';
import '../../../utils/utils.dart';

class MainBottomBar extends StatefulWidget {

  ValueChanged<int> onIndexChange;

  MainBottomBar(this.onIndexChange,{Key? key}) : super(key: key);

  @override
  State<MainBottomBar> createState() => _MainBottomBarState();
}

class _MainBottomBarState extends State<MainBottomBar> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.w,
      color: Colours.c_EEEEEE,
      child: Row(
          children: [
            _buildTabItem('tabbar_mainframe_normal','tabbar_mainframe_selected',Ids.wachat.str(),0),
            _buildTabItem('tabbar_contacts_normal','tabbar_contacts_selected',Ids.contacts.str(),1),
            _buildTabItem('tabbar_discover_normal','tabbar_discover_selected',Ids.discover.str(),2),
            _buildTabItem('tabbar_mine_normal','tabbar_mine_selected',Ids.mine.str(),3)
          ],
      ),
    );
  }

  Widget _buildTabItem(String icon , String iconSelected , String title , int index){

  return Expanded(
    child: TapWidget(
      onTap: () {
        if(_currentIndex != index) {
          setState((){
            _currentIndex = index;
          });
          widget.onIndexChange.call(index);
        } },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              Utils.getImgPath(_currentIndex == index? iconSelected:icon,dir: 'tabbar',format:Utils.WEBP ),
              width: 45.w,
              height: 45.w,
            ),
            5.sizedBoxH,
            Text(title,style: TextStyle(color:_currentIndex == index? Colours.theme_color:Colours.c_555555,fontSize: 24.sp),)
          ],
        ),
      ),
    );


  }

}
