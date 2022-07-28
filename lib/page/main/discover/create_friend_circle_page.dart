import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:wechat/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/page/util/video_perview_page.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/clip_rect_widget.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/tap_widget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../color/colors.dart';
import '../../../language/strings.dart';
import '../../../widget/reorderableitemsview.dart';
import 'controller/create_friend_circle_controller.dart';

class CreateFriendCirclePage extends BaseGetBuilder<CreateFriendCircleController> {
  static const String routeName = '/CreateFriendCirclePage';

  static const int mediaTypeText  = 0;
  static const int mediaTypeImage  = 1;
  static const int mediaTypeVideo  = 2;

  int _startDrag = -1;
  List<File> photos = [];
  List<AssetEntity>? selectedAssets;
  final Map<int, GlobalKey> _keys = {};
  int _mediaType = 0;///1 图片 2 视频
  VideoPlayerController? _videoController;

  CreateFriendCirclePage({Key? key}) : super(key: key);

  @override
  CreateFriendCircleController? getController() => CreateFriendCircleController();

  @override
  Widget controllerBuilder(BuildContext context, CreateFriendCircleController controller) {
   bool _enable =  controller.textEditingController.text.trim().isNotEmpty || _mediaType != 0;
    return MyScaffold(
      body: _buildBody(context),
      backgroundColor: Colours.white,
      appbarColor: Colours.white,
      actions: [
        CommonBtn(text: Ids.confirm.str(), onTap: () {
        controller.createFriendCircle(_mediaType, photos);
      },enable: _enable,)],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildInput(),
        Expanded(
            child: Stack(
          children: [
            if(_mediaType != mediaTypeVideo)
            _buildPhoto(context)
            else
              _buildVideo(),
            if (_startDrag != -1) _buildDragDelete(),
          ],
        ))
      ],
    );
  }

  _buildInput() {
    return Container(
      height: 200.w,
      padding: EdgeInsets.only(left: 40.w, right: 40.w, top: 20.w),
      child: TextField(
        controller: controller.textEditingController,
        style: TextStyle(
          color: Colours.black,
          fontSize: 32.sp,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5.w),
          hintText: Ids.thought_moment.str(),
          hintStyle: TextStyle(color: Colours.c_999999, fontSize: 32.sp, height: 1.0),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
          border: const UnderlineInputBorder(borderSide: BorderSide.none),
        ),
        // controller: widget.controller,
      ),
    );
  }

  GlobalKey _getIndexKey(int index) {
    if (_keys.containsKey(index)) {
      return _keys[index]!;
    }
    GlobalKey key = GlobalKey();
    _keys[index] = key;
    return key;
  }

  Widget _buildPhoto(BuildContext context) {
    var itemHeight = (Get.width - 40 * 2 - 10.w * 2) / 3;
    var widgets = photos
        .map<Widget>((e) => Image.file(e,
              key: _getIndexKey(photos.indexOf(e)),
              fit: BoxFit.cover,
            ))
        .toList();
    if (widgets.length < 9) {
      widgets.add(TapWidget(
        key: _getIndexKey(9),
        onTap: () async {
          selectedAssets = await AssetPicker.pickAssets(context,
              pickerConfig: AssetPickerConfig(
                  maxAssets: 9, specialPickerType: SpecialPickerType.wechatMoment, selectedAssets: selectedAssets));
          photos.clear();
          if (selectedAssets != null && selectedAssets!.isNotEmpty) {
            if(selectedAssets!.length == 1){
              File file = (await selectedAssets!.first.file)!;
              if(file.filename.endsWith('mp4')){
                selectedAssets?.clear();
                _mediaType = mediaTypeVideo;
                photos.add(file);
                _initVideo(file);
              }else{
                _mediaType = mediaTypeImage;
                photos.add(file);
              }
            }else{
              await Future.forEach<AssetEntity>(selectedAssets!, (element) async {
                File file = (await element.file)!;
                photos.add(file);
              });
            }
          }else{
            _mediaType = mediaTypeText;
          }
          update();
        },
        child: Container(
          color: Colours.c_EEEEEE,
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colours.black,
            ),
          ),
        ),
      ));
    }
    return Container(
      padding: EdgeInsets.only(left: 40.w, right: 40.w, top: 20.w),
      child: ReorderableItemsView(
        onReorder: (int oldIndex, int newIndex) {
          debugPrint('oldIndex $oldIndex newIndex $newIndex');
          if (photos.length < 9 && oldIndex == photos.length) {
            return;
          }
          photos.insert(newIndex, photos.removeAt(oldIndex));
          update();
        },
        feedBackWidgetBuilder: (BuildContext context, int index, Widget child) {
          return SizedBox(width: itemHeight, height: itemHeight, child: child);
        },
        isGrid: true,
        staggeredTiles: widgets.map((e) => const StaggeredTile.count(1, 1)).toList(),
        children: widgets,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        onDragStarted: (index) {
          if (photos.length < 9 && index == photos.length) {
            return;
          }
          _startDrag = index;
          update();
        },
        onDragEnd: (index) {
          if (photos.length < 9 && index == photos.length) {
            return;
          }
          var includeWidget = _getIndexKey(-1).includeWidget(_getIndexKey(index));
          if (includeWidget) {
            photos.removeAt(_startDrag);
            selectedAssets?.removeAt(_startDrag);
          }
          _startDrag = -1;
          update();
        },
      ),
    );
  }

  _buildDragDelete() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        key: _getIndexKey(-1),
        width: double.infinity,
        color: Colours.c_E63E24.withOpacity(0.8),
        height: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete,
              color: Colours.white,
            ),
            5.sizedBoxH,
            Text(
              Ids.drag_to_delete.str(),
              style: TextStyle(color: Colours.white, fontSize: 24.sp),
            )
          ],
        ),
      ),
    );
  }

  _initVideo(File file) async {
    _videoController = VideoPlayerController.file(file);;
    _videoController?.addListener(() {
      if(_videoController?.value.isInitialized??false){
        update();
      }
    });
    await _videoController!.initialize();
  }

  Widget _buildVideo() {
    if(_videoController != null && _videoController!.value.isInitialized){
      return Align(
        alignment: Alignment.topLeft,
        child: TapWidget(
          onTap: () async  {
            if(photos.isNotEmpty){
             var result = await  NavigatorUtils.toNamed(VideoPerviewPage.routeName,arguments:VideoArguments(url: photos.first.path,actionType: VideoArguments.actionTypeDelete));
             if(VideoArguments.actionTypeDelete == result){
               photos.clear();
               _mediaType = mediaTypeText;
               update();
             }
            }
          },
          child: Container(
              margin: EdgeInsets.only(left: 40.w),
              width: 300.w,
              height: 500.w,
              child: ClipRectWidget(
                child: Stack(
                  children: [
                    VideoPlayer(_videoController!),
                    Center(child: Container(
                        decoration: Colours.white.boxDecoration(borderRadius: 60.w),
                        child: Icon(Icons.play_circle,color: Colours.c_CCCCCC,size: 60.w,)),)
                  ],
                ),
              )),
        ),
      );
    }else{
      return Container();
    }
  }



}
