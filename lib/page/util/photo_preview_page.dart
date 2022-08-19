import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_image_library/extended_image_library.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/page/util/controller/phone_preview_controller.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/dialog/dialog_bottom_widget.dart';
import '../../color/colors.dart';
import '../../language/strings.dart';
import '../../utils/navigator_utils.dart';

class PhotoPreviewArguments{
  String? url;
  String? heroTag;

  PhotoPreviewArguments({required this.url,this.heroTag});
}

class PhotoPreviewPage extends BaseGetBuilder<PhonePreviewController> {

  static const String routeName = '/PhotoPreviewPage';

  PhotoPreviewPage({Key? key}) : super(key: key);

  static open(String url,{String? heroTag}){
    if(!TextUtil.isEmpty(url)){
      NavigatorUtils.toNamed(routeName,arguments: PhotoPreviewArguments(url:url,heroTag: heroTag));
    }
  }

  late PhotoPreviewArguments _arguments;

  @override
  void onInit() {
    _arguments = Get.arguments;
    super.onInit();
  }

  @override
  PhonePreviewController? getController() => PhonePreviewController();

  @override
  Widget controllerBuilder(BuildContext context, PhonePreviewController controller) {
    return MyScaffold(
      showAppbar: false,
      backgroundColor: Colours.transparent,
      onBodyClick: (){
        NavigatorUtils.pop();
      },
      body: Stack(
        children: [
          ExtendedImageSlidePage(
            child: Center(
              child: Hero(
                tag:_arguments.heroTag??_arguments.url!,
                child: ExtendedImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitWidth,
                  image: (!_arguments.url!.contains('http')?FileImage(File(_arguments.url!)):CachedNetworkImageProvider(_arguments.url!)) as ImageProvider<Object>,
                  enableSlideOutPage: true,
                  mode: ExtendedImageMode.gesture,
                  // initGestureConfigHandler: (state){
                  //   return GestureConfig(
                  //       inPageView: false,
                  //       minScale: 0.7,
                  //       animationMinScale: 0.7,
                  //       maxScale: 3.0,
                  //       speed: 0.7,
                  //       animationMaxScale: 3.0,
                  //       cacheGesture: false);
                  // },
                ),
              ),
            ),
            slideAxis: SlideAxis.both,
            slideType: SlideType.onlyImage,
            onSlidingPage: (state) {
              debugPrint('onSlidingPage = $state');
            },
            slidePageBackgroundHandler: defaultSlidePageBackgroundHandler,
            // slidePageBackgroundHandler: (offset, pageSize){
            //   return Colours.black_transparent;
            // },

          ),
          Container(
            margin: EdgeInsets.only(top: 100.w,left: 20.w,right: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios,color: Colours.white,), onPressed: () {
                  Get.back();
                },
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz,color: Colours.white,), onPressed: () async {
                 var result =  await NavigatorUtils.showBottomItemsDialog([DialogBottomWidgetItem(Ids.save_to_phone.str(), 0)]);
                 if(result != null){
                    controller.saveMedia(_arguments.url);
                 }
                },
                )
              ],
            ),
          ),
        ],
      ),
    );

  }


  Color defaultSlidePageBackgroundHandler(Offset offset, Size pageSize) {
    double opacity = offset.distance /
        (Offset(pageSize.width, pageSize.height).distance / 2.0);
    return Colours.black.withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
  }


}
