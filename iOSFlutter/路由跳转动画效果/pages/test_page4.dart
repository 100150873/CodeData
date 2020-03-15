import 'package:flutter/material.dart';

class TestPage4 extends StatelessWidget {
  const TestPage4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('页面4'),
        ),
        body: Center(
          child: Text('页面4'),
        )
      ),
    );
  }
}