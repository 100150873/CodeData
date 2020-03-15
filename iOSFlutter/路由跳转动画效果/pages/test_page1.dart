import 'package:flutter/material.dart';
import 'dynamic_page.dart';
import 'custom_route.dart';

class TestPage1 extends StatelessWidget {
  const TestPage1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            '页面1',
            style: TextStyle(
              fontSize:30.0,
            ),
            ),
        ),
        body: Center(
          child: MaterialButton(
            onPressed: (){
              Navigator.of(context).push(CustomRoute(DynamicPage('动画效果')));
            },
            child: Icon(
              Icons.navigate_next,
              size: 50.0
            ),
            ),
        )
      ),
    );
  }
}