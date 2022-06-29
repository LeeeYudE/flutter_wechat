import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/base_scaffold.dart';

import '../../../base/base_view.dart';
import '../../../color/colors.dart';
import '../../../language/strings.dart';
import '../../../utils/navigator_utils.dart';
import '../../../utils/utils.dart';
import '../../../widget/input_field.dart';
import '../../../widget/tap_widget.dart';
import 'controller/search_friend_controller.dart';

class SearchFriendPage extends BaseGetBuilder<SearchFriendController> {

  static const String routeName = '/SearchFriendPage';

  SearchFriendPage({Key? key}) : super(key: key);

  @override
  getController() => SearchFriendController();

  @override
  Widget controllerBuilder(BuildContext context, controller) {
    return MyScaffold(
      showAppbar: false,
      body: _buildBody(context,controller),
    );
  }

  _buildBody(BuildContext context,SearchFriendController controller) {
    return Container(
      padding: EdgeInsets.only(top: context.statusHeight+20.w,left: 20.w,right: 20.w),

      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: InputField(
                leftWidget: Image.asset(Utils.getImgPath('search_white',dir: Utils.DIR_ICON),color: Colours.c_999999,width: 40.w,height: 40.w,),
                controller: controller.controller,
                hint: Ids.accound_and_phone.str(),
                showClean: true,
              )),
              10.sizedBoxW,
              TapWidget(child: Text(Ids.cancel.str(),style: TextStyle(color: Colours.c_4486F4,fontSize: 32.sp),), onTap: (){
                NavigatorUtils.pop();
              })
            ],
          ),
          20.sizedBoxH,
          if(controller.controller.text.trim().isNotEmpty)
            _buildSearchLayout(controller)
        ],
      ),
    );
  }

  _buildSearchLayout(SearchFriendController controller){
    return TapWidget(
      onTap: () {
        controller.search();
      },
      child: Container(
        height: 150.w,
        color: Colours.white,
        padding: EdgeInsets.symmetric(vertical: 10.w,horizontal: 20.w),
        child: Row(
          children: [
            Image.asset(Utils.getImgPath('ic_search_friend',dir: Utils.DIR_CONTACT),width: 100.w,height: 100.w,),
            20.sizedBoxW,
            Text('${Ids.search.str()}：',style: TextStyle(color: Colours.black,fontSize: 32.sp),),
            Text(controller.controller.text.toString(),style: TextStyle(color: Colours.theme_color,fontSize: 32.sp),),
          ],
        ),
      ),
    );
  }


}
