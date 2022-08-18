import 'package:flutter/material.dart';
import 'package:wechat/utils/navigator_utils.dart';
import 'package:wechat/widget/base_scaffold.dart';
import 'package:wechat/core.dart';
import 'package:wechat/widget/tap_widget.dart';

class TestAccountsPage extends StatefulWidget {

  static const String routeName = '/TestAccountsPage';

  const TestAccountsPage({Key? key}) : super(key: key);

  @override
  State<TestAccountsPage> createState() => _TestAccountsPageState();
}

class _TestAccountsPageState extends State<TestAccountsPage> {

  List<String> accounts = [];

  @override
  void initState() {
    super.initState();
    for(int i = 0 ; i < 24 ; i++){
      accounts.add('182000000'+ (i <10?'0$i':'$i'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        title: '测试账号',
        body: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    return ListView.builder(itemBuilder: (context , index){
      return TapWidget(
        onTap: () {
          NavigatorUtils.pop(accounts[index]);
        },
        child: Container(
          padding: EdgeInsets.all(20.w),
          height: 100.w,
        child: Text(accounts[index]),),
      );
    },itemCount: accounts.length,);
  }



}
