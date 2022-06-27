import 'package:flutter/material.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/core.dart';

import '../../../language/strings.dart';
import '../../../utils/utils.dart';
import '../../../widget/tap_widget.dart';
import '../widget/main_appbar.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        Ids.contacts.str(),
        _buildBody()
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colours.white,
      child: _buildHeader(),
    );
  }

  _buildHeader(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderItem('ic_new_friend',Ids.new_friend.str(),0),
        _buildHeaderItem('ic_group',Ids.group_chat.str(),1),
        _buildHeaderItem('ic_tag',Ids.lable.str(),2),
      ],
    );
  }

  _buildHeaderItem(String icon,String title,int type){
    return TapWidget(
      onTap: () {

      },
      child: Container(
        height: 100.w,
        decoration:Colours.c_EEEEEE.bottomBorder(),
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.w),
        child: Row(
          children: [
            Image.asset(Utils.getImgPath(icon,dir:Utils.DIR_CONTACT,format: Utils.WEBP )),
            40.sizedBoxW,
            Text(title,style: TextStyle(color: Colours.black,fontSize: 32.sp),),
          ],
        ),
      ),
    );
  }

}
