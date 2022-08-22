

import 'package:wechat/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:wechat/base/base_view.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/widget/common_btn.dart';
import 'package:wechat/widget/input_field.dart';

import '../../../controller/user_controller.dart';
import '../../../language/strings.dart';

class EditNicknamePage extends StatefulWidget {

  static const String routeName = '/EditNicknamePage';

  const EditNicknamePage({Key? key}) : super(key: key);

  @override
  State<EditNicknamePage> createState() => _EditNicknamePageState();

}

class _EditNicknamePageState extends State<EditNicknamePage> {

  final TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    _editingController.addListener(() {
      setState((){});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        title: Ids.edit_nickname.str(),
        body: _buildBody(context),
        actions:[
          CommonBtn(text: Ids.confirm.str(), onTap: () async {
             await UserController.instance.editNickname(_editingController.text.trim());
          },enable: _editingController.text.trim().isNotEmpty,)
        ]);
  }


  _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          InputField(
            hint: Ids.nickname.str(),
            controller: _editingController,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

}