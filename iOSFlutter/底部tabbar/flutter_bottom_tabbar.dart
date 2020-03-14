
import 'package:flutter/material.dart';

class BottomTabbarWidgetWidget extends StatefulWidget {
  BottomTabbarWidgetWidget({Key key}) : super(key: key);

  @override
  _BottomTabbarWidgetState createState() => _BottomTabbarWidgetState();
}

class _BottomTabbarWidgetState extends State<BottomTabbarWidgetWidget> {

final _bottomNavgaionBarColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: _bottomNavgaionBarColor,
            title: Text(
              '首页',
              style: TextStyle(
                color: Colors.blue
              ),
              )
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            backgroundColor: _bottomNavgaionBarColor,
            title: Text(
              '通讯录',
              style: TextStyle(
                color: Colors.blue
              ),
              )
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            backgroundColor: _bottomNavgaionBarColor,
            title: Text(
              '咨询',
              style: TextStyle(
                color: Colors.blue
              ),
              )
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            backgroundColor: _bottomNavgaionBarColor,
            title: Text(
              '我的',
              style: TextStyle(
                color: Colors.blue
              ),
              )
            ),
        ]
        ),
    );
  }
}

