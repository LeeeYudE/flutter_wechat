
import 'package:extended_image/extended_image.dart';
import 'package:extended_image_library/extended_image_library.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

import '../../utils/navigator_utils.dart';

class PhotoPreviewPage extends StatefulWidget {

  static open(BuildContext context , String url,{String? heroTag}){
    if(!TextUtil.isEmpty(url)){
      NavigatorUtils.pushTransparentPage(context, PhotoPreviewPage(url: url,heroTag: heroTag,));
    }
  }

  String? url;
  String? heroTag;

  PhotoPreviewPage({this.url,this.heroTag});

  @override
  _PhotoPreviewPageState createState() => _PhotoPreviewPageState();
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      onLongPress: (){
        // showImageSaver(context,widget.url);
        // showCommonBottomSheet(context,child: ImageSaveDialog());
      },
      child: Scaffold(
        backgroundColor: const Color(0x00000000),
        body: ExtendedImageSlidePage(
          child: Container(
            child: Center(
              child: Hero(
                tag:widget.heroTag??widget.url!,
                child: ExtendedImage(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fitWidth,
                  image: (!widget.url!.contains('http')?FileImage(File(widget.url!)):NetworkImage(widget.url!)) as ImageProvider<Object>,
                  enableSlideOutPage: true,
                  mode: ExtendedImageMode.gesture,
                  // initGestureConfigHandler: (state){
                  //   return GestureConfig(
                  //       inPageView: true,
                  //       minScale: 1.0,
                  //       animationMinScale: 1.0,
                  //       maxScale: 3.0,
                  //       speed: 0.7,
                  //       animationMaxScale: 3.0,
                  //       cacheGesture: false);
                  // },
                ),
              ),
            ),
          ),
          slideAxis: SlideAxis.both,
          slideType: SlideType.onlyImage,
          onSlidingPage: (state) {
            print('onSlidingPage = $state');
          },
          slidePageBackgroundHandler: (offset, pageSize){
            return Colors.black.withOpacity(0.8);
          },
        ),
      ),
    );

  }


}
