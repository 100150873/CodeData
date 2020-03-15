import 'package:flutter/material.dart';

class TestPage4 extends StatefulWidget {
  TestPage4({Key key}) : super(key: key);
  int _count = 0;
  @override
  _TestPage4State createState() => _TestPage4State();
}

class _TestPage4State extends State<TestPage4> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('页面4'),
        ),
        body: Center(
          child: Text('当前数值 == ${widget._count}'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          setState(() {
            ++widget._count;
          });
        },
        child: Icon(Icons.add),
        tooltip: '点击按钮',
        ),
      ),
    );
  }
}
