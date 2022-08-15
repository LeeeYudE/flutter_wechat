import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/domain/entities/cover_data.dart';
import 'package:video_editor/domain/entities/transform_data.dart';
import 'package:wechat/core.dart';
import '../color/colors.dart';

class VideoCoverSelection extends StatefulWidget {
  /// Slider that allow to select a generated cover
  const VideoCoverSelection({
    Key? key,
    required this.controller,
    this.height = 60,
    this.quality = 10,
    this.quantity = 5,
  }) : super(key: key);

  /// The [controller] param is mandatory so every change in the controller settings will propagate in the cover selection view
  final VideoEditorController controller;

  /// The [height] param specifies the height of the generated thumbnails
  final double height;

  /// The [quality] param specifies the quality of the generated thumbnails, from 0 to 100 ([more info](https://pub.dev/packages/video_thumbnail))
  final int quality;

  /// The [quantity] param specifies the quantity of thumbnails to generate
  final int quantity;

  @override
  _VideoCoverSelectionState createState() => _VideoCoverSelectionState();
}

class _VideoCoverSelectionState extends State<VideoCoverSelection> with AutomaticKeepAliveClientMixin {
  double _aspect = 1.0, _width = 1.0;
  Duration? _startTrim, _endTrim;
  Size _layout = Size.zero;
  double left = 1.0;
  late double itemHeight;
  late double itemWidth;
  var _isDraging = false;
  final ValueNotifier<Rect> _rect = ValueNotifier<Rect>(Rect.zero);
  final ValueNotifier<TransformData> _transform = ValueNotifier<TransformData>(TransformData());

  late Stream<List<CoverData>> _stream = (() => _generateThumbnails())();
  CoverData? currentCover;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    widget.controller.removeListener(_scaleRect);
    _transform.dispose();
    _rect.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    itemHeight = widget.height;
    itemWidth = itemHeight * 2 / 3 ;
    _aspect = widget.controller.preferredCropAspectRatio ?? widget.controller.video.value.aspectRatio;
    _startTrim = widget.controller.startTrim;
    _endTrim = widget.controller.endTrim;
    widget.controller.addListener(_scaleRect);

    // init the widget with controller values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaleRect();
    });
  }

  @override
  bool get wantKeepAlive => true;

  void _scaleRect() {
    _rect.value = _calculateCoverRect();
    _transform.value = TransformData.fromRect(
      _rect.value,
      _layout,
      widget.controller,
    );

    if (widget.controller.preferredCropAspectRatio != null && _aspect != widget.controller.preferredCropAspectRatio) {
      _aspect = widget.controller.preferredCropAspectRatio!;
      _layout = _calculateLayout();
    }

    // if trim values changed generate new thumbnails
    if (!widget.controller.isTrimming &&
        (_startTrim != widget.controller.startTrim || _endTrim != widget.controller.endTrim)) {
      _startTrim = widget.controller.startTrim;
      _endTrim = widget.controller.endTrim;
      setState(() {
        _stream = _generateThumbnails();
      });
    }
  }

  Stream<List<CoverData>> _generateThumbnails() async* {
    final int duration = widget.controller.isTrimmmed
        ? (widget.controller.endTrim - widget.controller.startTrim).inMilliseconds
        : widget.controller.videoDuration.inMilliseconds;
    final double eachPart = duration / widget.quantity;
    final List<CoverData> _byteList = [];
    for (int i = 0; i < widget.quantity; i++) {
      try {
        final CoverData _bytes = await widget.controller.generateCoverThumbnail(
            timeMs: (widget.controller.isTrimmmed
                    ? (eachPart * i) + widget.controller.startTrim.inMilliseconds
                    : (eachPart * i))
                .toInt(),
            quality: widget.quality);

        if (_bytes.thumbData != null) {
          _byteList.add(_bytes);
          if(i == 0){
            widget.controller.updateSelectedCover(_bytes);
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      yield _byteList;
    }
    currentCover ??= _byteList.first;
  }

  Rect _calculateCoverRect() {
    final Offset min = widget.controller.minCrop;
    final Offset max = widget.controller.maxCrop;
    return Rect.fromPoints(
      Offset(
        min.dx * _layout.width,
        min.dy * _layout.height,
      ),
      Offset(
        max.dx * _layout.width,
        max.dy * _layout.height,
      ),
    );
  }

  Size _calculateLayout() {
    return _aspect < 1.0 ? Size(widget.height * _aspect, widget.height) : Size(widget.height, widget.height / _aspect);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(builder: (_, box) {
      final double width = box.maxWidth;
      if (_width != width) {
        _width = width;
        _layout = _calculateLayout();
        _rect.value = _calculateCoverRect();
      }

      return StreamBuilder(
          stream: _stream,
          builder: (_, AsyncSnapshot<List<CoverData>> snapshot) {
            final data = snapshot.data;
            return snapshot.hasData
                ? Stack(children: [
                    Container(
                      height: itemHeight,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colours.transparent, width: widget.controller.coverStyle.selectedBorderWidth)),
                      child: Opacity(
                        opacity: 0.5,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: data!.length,
                            itemBuilder: (BuildContext context, int index) {

                              final CoverData coverData = data[index];
                              final _key = GlobalKey(debugLabel: index.toString());
                              return ValueListenableBuilder(
                                  valueListenable: widget.controller.selectedCoverNotifier,
                                  key: _key,
                                  builder: (context, CoverData? selectedCover, __) {

                                    return InkWell(
                                        onTap: () {
                                          widget.controller.updateSelectedCover(coverData);
                                          final _renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
                                          if (_renderBox != null) {
                                            left = _renderBox.localToGlobal(Offset.zero).dx-20.w;
                                          }
                                          setState(() {
                                            currentCover = coverData;
                                          });
                                        },
                                        child: Image(
                                          width: itemWidth,
                                          height: itemHeight,
                                          image: MemoryImage(coverData.thumbData!),
                                          fit: BoxFit.cover,
                                        ));
                                  });
                            }),
                      ),
                    ),
                    Positioned(
                      left: left,
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colours.theme_color, width: widget.controller.coverStyle.selectedBorderWidth)),
                          width: itemWidth,
                          height: itemHeight,
                          child: currentCover != null
                              ? Image(
                            width:itemWidth,
                            height: itemHeight,
                                  image: MemoryImage(currentCover!.thumbData!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        onHorizontalDragEnd: (_) => setState(() => _isDraging = false),
                        onHorizontalDragCancel: () => setState(() => _isDraging = false),
                        //垂直方向拖动事件
                        onHorizontalDragUpdate: (DragUpdateDetails details) {
                          _isDraging = true;
                          final double dragWidth = 1.0.sw - 40.w - itemWidth;
                          left = details.delta.dx + left;
                          final double scale = ((data.length - 1) * itemWidth - dragWidth) / dragWidth;

                          if (left >= dragWidth) {
                            left = dragWidth - 1;
                          } else if (left <= 0) {
                            left = 1;
                          }
                          final double currentIndex = left / (dragWidth / data.length);
                          debugPrint(' ${1.0.sw} left = $left currentIndex ${scale} ${data.length} $currentIndex');

                          final CoverData coverData = data[currentIndex.toInt()];
                          setState(() {
                            scrollController.jumpTo(left * scale);
                            widget.controller.updateSelectedCover(coverData);
                            currentCover = coverData;
                          });
                        },
                      ),
                    )
                  ])
                : const SizedBox();
          });
    });
  }
}
