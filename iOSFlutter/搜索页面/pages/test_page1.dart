import 'package:flutter/material.dart';
import 'dynamic_page.dart';
import 'custom_route.dart';
import 'search_delegate_page.dart';

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
                fontSize: 30.0,
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
              onPressed: () {
                Navigator.of(context).push(CustomRoute(DynamicPage('动画效果')));
              },
              child: Icon(Icons.navigate_next, size: 50.0),
            ),
            MaterialButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchTestDelegate());
                // Navigator.of(context).push(CustomRoute(SearchDemoPage()));
              },
              child: Icon(Icons.public, size: 50.0),
            ),
              ],
            )
          )),
    );
  }
}
