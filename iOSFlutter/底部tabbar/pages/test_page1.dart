import 'package:flutter/material.dart';

class TestPage1 extends StatelessWidget {
  const TestPage1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('页面1'),
        ),
        body: Center(
          child: Text('首页'),
        )
      ),
    );
  }
}