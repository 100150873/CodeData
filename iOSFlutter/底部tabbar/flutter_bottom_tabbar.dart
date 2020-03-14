import 'package:flutter/material.dart';
import 'pages/test_page1.dart';
import 'pages/test_page2.dart';
import 'pages/test_page3.dart';
import 'pages/test_page4.dart';

class BottomTabbarWidgetWidget extends StatefulWidget {
  BottomTabbarWidgetWidget({Key key}) : super(key: key);

  @override
  _BottomTabbarWidgetState createState() => _BottomTabbarWidgetState();
}

class _BottomTabbarWidgetState extends State<BottomTabbarWidgetWidget> {
  final _bottomNavgaionBarColor = Colors.red;
  int _currentIndex = 0;
  List<Widget> list = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list
      ..add(TestPage1())
      ..add(TestPage2())
      ..add(TestPage3())
      ..add(TestPage4());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: list[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                backgroundColor: _bottomNavgaionBarColor,
                title: Text(
                  '首页',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                backgroundColor: _bottomNavgaionBarColor,
                title: Text(
                  '通讯录',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.warning),
                backgroundColor: _bottomNavgaionBarColor,
                title: Text(
                  '咨询',
                  style: TextStyle(color: Colors.blue),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.mail),
                backgroundColor: _bottomNavgaionBarColor,
                title: Text(
                  '我的',
                  style: TextStyle(color: Colors.blue),
                )),
          ]),
    );
  }
}
