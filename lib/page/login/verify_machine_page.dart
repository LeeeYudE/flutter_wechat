import 'package:flutter/material.dart';
import 'package:wechat/core.dart';
import 'package:wechat/page/login/widget/verify_machine_widget.dart';
import '../../color/colors.dart';
import '../../language/strings.dart';
import '../../utils/navigator_utils.dart';
import '../../widget/base_scaffold.dart';

class VerifyMachinePage extends StatelessWidget {

  static const String routeName = '/VerifyMachinePage';

  const VerifyMachinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appbarColor: Colours.white,
      title: Ids.wachat_safety.str(),
      leading: IconButton(icon: const Icon(Icons.close,color: Colours.c_999999,), onPressed: () {
        NavigatorUtils.pop();
      },),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Colours.white,
      child: const VerifyMachineWidget(),
    );
  }
}
