import 'package:wechat/core.dart';
import 'package:map_launcher/map_launcher.dart' as MapType;
import 'package:map_launcher/map_launcher.dart';
import 'package:wechat/utils/navigator_utils.dart';
import '../widget/dialog/dialog_bottom_widget.dart';


class MapUtil {

  /// 导航目的地
  static Future<void> showDirections(longitude, latitude) async {

    var list = await MapLauncher.installedMaps;

   var index =  await NavigatorUtils.showBottomItemsDialog(list.map<DialogBottomWidgetItem>((e) =>DialogBottomWidgetItem(e.mapName,e.mapType.index)).toList());
    if(index != null){
      var item = list.itemWhere((element) => element.mapType.index == index);
      MapLauncher.showDirections(mapType: item!.mapType, destination: Coords(latitude, longitude));
    }
  }
}
