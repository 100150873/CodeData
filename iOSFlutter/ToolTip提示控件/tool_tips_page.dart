import 'package:flutter/material.dart';


class ToolTipPage extends StatelessWidget {
  const ToolTipPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('提示器'),
      ),
      body: Center(
        child: Tooltip(
          // 长按提示语
          message: '不要碰我',
          child: Image.network('https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1584469487139&di=b2e0c49671e196b0b8a23820eef50eb0&imgtype=0&src=http%3A%2F%2Fpic.feizl.com%2Fupload%2Fallimg%2F170918%2F18362zf1lsf3e0a.jpg'),
          ),
      ),
    );
  }
}