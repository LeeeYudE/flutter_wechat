import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../color/colors.dart';
import '../utils/utils.dart';

class AvatarWidget extends StatelessWidget {
  final String? avatar;
  final double weightWidth;
  final bool hero;
  final double? decorationWidth;
  final double? borderRadius;
  final bool circle;

  const AvatarWidget({
    required this.avatar,
    required this.weightWidth,
    this.hero = false,
    this.decorationWidth,
    this.borderRadius,
    this.circle = false
  });

  @override
  Widget build(BuildContext context) {
    return _buildAvatarWidget(avatar);
  }

  Widget _buildAvatarWidget(String? avatar) {
    return SizedBox(
      width: weightWidth,
      height: weightWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circle?weightWidth:borderRadius??12.w,),
        child: TextUtil.isEmpty(avatar) ? _buildEmptyImage() : hero ? Hero(tag: avatar!, child: _buildImage(avatar)): _buildImage(avatar!),
      ),
    );
  }

  Widget _buildEmptyImage() {
    return Image.asset(
      Utils.getImgPath('default_nor_avatar',dir: 'avatar'),
      width:weightWidth ,
      height: weightWidth ,
      fit: BoxFit.fill,
    );
  }

  CachedNetworkImage _buildImage(String avatar) {
    return CachedNetworkImage(
      width: weightWidth,
      height: weightWidth,
      imageUrl: avatar,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildEmptyImage(),
      errorWidget: (context, url, error) => _buildEmptyImage(),
    );
  }
}
