import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';
import '../../../../color/colors.dart';
import '../../../../language/strings.dart';
import '../../../../utils/emoji_text.dart';
import '../../../../utils/utils.dart';

class EmojiGridView extends StatefulWidget {
  final ValueChanged<EmojiModel>? onTap;

  const EmojiGridView(
      {Key? key,
      this.onTap})
      : super(key: key);

  @override
  _EmojiGridViewState createState() => _EmojiGridViewState();
}

class _EmojiGridViewState extends State<EmojiGridView> {

  @override
  Widget build(BuildContext context) {
    return emojiGrid(context);
  }

  void _onClickEmoji(EmojiModel emoji){
    if(widget.onTap != null){
      widget.onTap!(emoji);
    }
  }


//emoji表情包的处理
  Widget emojiGrid(BuildContext context) {
    final int itemCount = EmojiUtil.instance.emojiList.length + 1;
    return Container(
      color: Colours.c_EEEEEE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          5.sizedBoxH,
          Expanded(
            child: StaggeredGridView.countBuilder(
              crossAxisCount: 8,
              staggeredTileBuilder: (index) => StaggeredTile.count(index == 0 ? 8 : 1,index == 0 ? 0.8 :  1),
              itemBuilder: (context, index) {
                if(index == 0){
                  return Container(
                    margin: EdgeInsets.only(left: 20.w),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(Ids.all_emoji.str(),style: TextStyle(color: Colours.c_999999,fontSize: 32.sp),)));
                }

                final emoji = EmojiUtil.instance.emojiList[index-1];
                return Center(
                  child: TapWidget(
                    child: Image.asset(Utils.getImgPath(emoji.name!,dir: Utils.DIR_EMOJI),width: 50.w,height: 50.w,),
                    onTap: () {
                      _onClickEmoji(emoji);
                    },
                  ),
                );
              },
              itemCount: itemCount,
              crossAxisSpacing: 4.w,
            ),
          )
        ],
      ),
    );
  }
}
