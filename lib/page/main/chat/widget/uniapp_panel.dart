
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wechat/color/colors.dart';
import 'package:wechat/page/main/chat/controller/uniapp_controller.dart';
import 'package:wechat/core.dart';
import 'package:wechat/utils/utils.dart';
import 'package:wechat/widget/cache_image_widget.dart';
import 'package:wechat/widget/sliding_up_panel.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../../base/base_view.dart';
import '../../../../language/strings.dart';

class UniappPanel extends BaseGetBuilder<UniappController>{
  
  PanelController panelController;

  UniappPanel({required this.panelController});

  @override
  UniappController? getController() => UniappController(panelController);

  @override
  Widget controllerBuilder(BuildContext context, UniappController controller) {
   return Container(
     decoration: BoxDecoration(
       image: DecorationImage(
         image: ExactAssetImage(Utils.getImgPath('bg_mini_program',dir: 'bg')),
         fit: BoxFit.cover,
       )
     ),
     padding: EdgeInsets.only(top: 100.w),
     child: Column(
       children: [
         Text(Ids.recently_used_mini_program.str(),style: TextStyle(color: Colours.c_EEEEEE,fontSize: 32.sp),),
         20.sizedBoxH,
         Expanded(
           child: Obx(
              ()=> GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 5,
               mainAxisSpacing: 20.w,
               crossAxisSpacing: 20.w,
               childAspectRatio: 0.8,
             ), itemBuilder: (BuildContext context, int index) {
               return TapWidget(
                 onTap: () {
                   controller.releaseWgtToRunPath(controller.list[index]);
                 },
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                    CacheImageWidget(url: controller.list[index]['avatar'], weightWidth: 100.w, weightHeight: 100.w,icCircle: true,),
                     10.sizedBoxH,
                     Text(controller.list[index]['appName'],style: TextStyle(color: Colours.white,fontSize: 32.sp),)
                   ],
                 ),
               );
             },itemCount: controller.list.length,),
           ),
         )
       ],
     ),
   );
  }


}