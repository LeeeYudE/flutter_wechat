import 'package:wechat/base/constant.dart';
import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:wechat/page/util/photo_preview_page.dart';
import 'package:wechat/widget/cache_image_widget.dart';
import 'package:wechat/widget/tap_widget.dart';

import '../utils/navigator_utils.dart';

class ScaleSizeImageWidget extends StatelessWidget {

  double photoWidth;
  double photoHeight;
  String photoUrl;
  bool tapDetail;

  ScaleSizeImageWidget({required this.photoWidth , required this.photoHeight , required this.photoUrl,this.tapDetail = true,Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    double photoWidth = this.photoWidth;
    double photoHeight = this.photoHeight;
    final double scale = photoWidth / photoHeight;
    if (photoWidth == 0) {
      photoWidth = Constant.MAX_PHOTO_WIDTH;
      photoHeight = Constant.MAX_PHOTO_HEIGHT;
    } else if (photoWidth < Constant.MIN_PHOTO_WIDTH && photoHeight < Constant.MIN_PHOTO_HEIGHT) {
      photoWidth = Constant.MIN_PHOTO_WIDTH ;
      photoHeight = photoWidth / scale;
    } else if (photoWidth > Constant.MIN_PHOTO_WIDTH  &&
        photoWidth < Constant.MAX_PHOTO_WIDTH &&
        photoHeight > Constant.MIN_PHOTO_HEIGHT &&
        photoHeight < Constant.MAX_PHOTO_HEIGHT) {
      photoWidth = this.photoWidth;
      photoHeight = this.photoHeight;
    } else {
      if (photoWidth >= photoHeight) {
        photoWidth = Constant.MAX_PHOTO_WIDTH;
        photoHeight = photoWidth / scale;
      } else {
        photoHeight = Constant.MAX_PHOTO_HEIGHT;
        photoWidth = photoHeight * scale;
      }
    }
    Widget image = CacheImageWidget(url: photoUrl, weightWidth: photoWidth, weightHeight: photoHeight,hero: true,);

    if(tapDetail){
      return TapWidget(onTap: () {
        NavigatorUtils.toNamed(PhotoPreviewPage.routeName,arguments: PhotoPreviewArguments(heroTag: photoUrl,url: photoUrl));
      }, child:image );
    }else{
      return image;
    }


  }
}
