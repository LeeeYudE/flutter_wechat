import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../color/colors.dart';
import '../utils/utils.dart';

class CacheImageWidget extends StatelessWidget {
  final String? url;
  final double weightWidth;
  final double weightHeight;
  final bool hero;
  final double? decorationWidth;
  final double? borderRadius;

  const CacheImageWidget({
    required this.url,
    required this.weightWidth,
    required this.weightHeight,
    this.hero = false,
    this.decorationWidth,
    this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return _buildAvatarWidget(url);
  }

  Widget _buildAvatarWidget(String? avatar) {
    return Container(
      width: weightWidth,
      height: weightHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius??12.w,),
        child: TextUtil.isEmpty(avatar) ? _buildEmptyImage() : hero ? Hero(tag: avatar!, child: _buildImage(avatar)): _buildImage(avatar!),
      ),
    );
  }

  Widget _buildEmptyImage() {
    return Container(
      width:weightWidth ,
      height: weightHeight,
      color: Colours.c_999999,
    );
  }

  CachedNetworkImage _buildImage(String avatar) {
    return CachedNetworkImage(
      width: weightWidth,
      height: weightHeight,
      imageUrl: avatar,
      fit: BoxFit.cover,
      placeholder: (context, url) => _buildEmptyImage(),
      errorWidget: (context, url, error) => _buildEmptyImage(),
    );
  }
}
