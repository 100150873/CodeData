import 'package:flutter/material.dart';

class TestPage3 extends StatelessWidget {
  const TestPage3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('页面3'),
        ),
        body: Center(
          child: Text('页面3'),
        )
      ),
    );
  }
}