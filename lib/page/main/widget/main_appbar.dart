import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';

import '../../../language/strings.dart';
import '../../../utils/navigator_utils.dart';
import '../../../utils/utils.dart';
import '../../../widget/base_scaffold.dart';
import '../../../widget/tap_widget.dart';
import '../contacts/add_friend_page.dart';
import '../discover/scan_qrcode_page.dart';

class MainScaffold extends StatefulWidget {

  String title;
  Widget body;


   MainScaffold(this.title,this.body,{Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {

  List<ItemModel> menuItems = [];

  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    menuItems.add(ItemModel(Ids.create_chat.str(), 'menu_add_newmessage',0));
    menuItems.add(ItemModel(Ids.add_friend.str(), 'menu_add_newmessage',1));
    menuItems.add(ItemModel(Ids.scan.str(), 'menu_add_newmessage',2));
    menuItems.add(ItemModel(Ids.receive_payment.str(), 'menu_add_newmessage',3));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      showLeading: false,
      title: widget.title,
      body: widget.body,
      actions: [
        TapWidget(onTap: () {
          'find'.toast();
        }, child: Image.asset(Utils.getImgPath('icon_search',dir: 'icon'),width: 50.w,height: 50.w,)),
        20.sizedBoxW,
        _buildCustomPopupMenu()
      ],
    );
  }

 Widget _buildCustomPopupMenu(){
    return CustomPopupMenu(
      child: Image.asset(Utils.getImgPath('add_addressicon',dir: 'icon'),width: 40.w,height: 40.w,color: Colours.c_212129,),
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: const Color(0xFF4C4C4C),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map((item) => TapWidget(
                  onTap: () {
                    _controller.hideMenu();
                    switch(item.type){
                      case 0:
                        break;
                      case 1:
                        NavigatorUtils.toNamed(AddFriendPage.routeName);
                        break;
                      case 2:
                        NavigatorUtils.toNamed(ScanQrcodePage.routeName);
                        break;
                      case 3:
                        break;
                    }
                  },
                  child: Container(
                    height: 80.w,
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Row(
                      children: <Widget>[
                        Image.asset(Utils.getImgPath(item.icon,dir: 'icon'),width: 50.w,height: 50.w,),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10.w),
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
        ),
      ),
      pressType: PressType.singleClick,
      verticalMargin: 10.w,
      controller: _controller,
    );
  }

}

class ItemModel {
  String title;
  String icon;
  int type;

  ItemModel(this.title, this.icon,this.type);
}
