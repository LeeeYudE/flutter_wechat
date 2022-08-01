import 'package:flutter/material.dart';
import 'package:wechat/widget/remove_top_widget.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:wechat/core.dart';
import '../page/util/photo_preview_page.dart';
import '../utils/navigator_utils.dart';
import 'cache_image_widget.dart';

class FriendCircleGridView extends StatelessWidget {

  List<String> photos = [];

  FriendCircleGridView({required this.photos,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double layoutWidth = constraints.maxWidth;
        int crossCount;
        if(photos.length < 4){
          crossCount = 1;
        }else if(photos.length < 7){
          crossCount = 2;
        }else{
          crossCount = 3;
        }

        double layoutHeight = layoutWidth * (crossCount/3);
        if(photos.length == 4){
          layoutWidth = layoutWidth * 2 / 3;
        }
        return SizedBox(
          height: layoutHeight,
          width: layoutWidth,
          child: RemoveTopPaddingWidget(
            child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: photos.length == 4 ? 2 : 3,
              mainAxisSpacing: 20.w,
              crossAxisSpacing: 20.w,
              childAspectRatio: 1,
            ), itemBuilder: (context , index){
              String url = photos[index];
              return TapWidget(onTap: () {
                NavigatorUtils.toNamed(PhotoPreviewPage.routeName,arguments: PhotoPreviewArguments(heroTag: url,url: url));
              },
                  child: CacheImageWidget(url: url, weightWidth: 0, weightHeight: 0,hero: true,));
            },itemCount: photos.length,physics: const NeverScrollableScrollPhysics(),),
          ),
        );
      },
    );
  }
}
