import 'package:flutter/cupertino.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/common_btn.dart';

import '../../../base/common_state_widget_x.dart';
import '../../../color/colors.dart';
import '../../../language/strings.dart';
import '../../../widget/avatar_widget.dart';
import '../../../widget/remove_top_widget.dart';
import 'controller/new_friend_controller.dart';

class NewFriendPage extends BaseGetBuilder<NewFriendController> {

  static const String routeName = '/NewFriendPage';

  NewFriendPage({Key? key}) : super(key: key);

  @override
  NewFriendController? getController() => NewFriendController();

  @override
  Widget controllerBuilder(BuildContext context, NewFriendController controller) {
    return MyScaffold(
      title: Ids.new_friend.str(),
      body: _buildBody(context,controller),
    );
  }

  _buildBody(BuildContext context, NewFriendController controller) {
    return CommonStateWidgetX(
      controller: controller, widgetBuilder: (BuildContext context) {
        return RemoveTopPaddingWidget(
          child: ListView.builder(itemBuilder: (context , index){
            var request = controller.requests[index];
            return Container(
              height: 100.w,
              color: Colours.white,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  AvatarWidget(avatar: request['user']['avatar'], weightWidth: 80.w,),
                  20.sizedBoxW,
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.sizedBoxH,
                      Text(request['user']['nickname']??'',style: TextStyle(color: Colours.black,fontSize: 32.sp),),
                    ],
                  )),
                  CommonBtn(text: Ids.agree.str(), width: 100.w, height: 60.w,backgroundColor: Colours.c_EEEEEE,textStyle: TextStyle(
                      color: Colours.theme_color,fontSize: 28.sp
                  ), onTap: (){
                    controller.acceptRequest(request);
                  })
                ],
              ),
            );
          },itemCount: controller.requests.length,),
        );
    },
    );
  }

}
