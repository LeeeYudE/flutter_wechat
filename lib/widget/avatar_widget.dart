import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/utils.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatar;
  final double weightWidth;
  final bool hero;

  const AvatarWidget({
    required this.avatar,
    required this.weightWidth,
    this.hero = false
  });

  @override
  Widget build(BuildContext context) {
    return _buildAvatarWidget(avatar);
  }


  Widget _buildAvatarWidget(String? avatar) {
    return SizedBox(
      width: weightWidth.w,
      height: weightWidth.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(weightWidth.w / 2,),
        child: TextUtil.isEmpty(avatar) ? _buildEmptyImage() : hero ? Hero(tag: avatar!, child: _buildImage(avatar)): _buildImage(avatar!),
      ),
    );
  }

  Widget _buildEmptyImage() {
    return Image.asset(
      Utils.getImgPath('avatar_boy'),
      width:ScreenUtilExt.setWidth(weightWidth)  ,
      height:  ScreenUtilExt.setWidth(weightWidth)   ,
      fit: BoxFit.fill,
    );
  }

  CachedNetworkImage _buildImage(String avatar) {
    print('CachedNetworkImage $avatar');
    return CachedNetworkImage(
      imageUrl: avatar,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildEmptyImage(),
      errorWidget: (context, url, error) => _buildEmptyImage(),
    );
  }
}
