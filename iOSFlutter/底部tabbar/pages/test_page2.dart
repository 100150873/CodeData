import 'package:flutter/material.dart';

class TestPage2 extends StatelessWidget {
  const TestPage2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('页面2'),
        ),
        body: Center(
          child: Text('页面2'),
        )
      ),
    );
  }
}