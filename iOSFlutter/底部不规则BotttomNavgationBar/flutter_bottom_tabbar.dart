import 'package:flutter/material.dart';
import 'pages/test_page1.dart';
import 'pages/test_page2.dart';
import 'pages/test_page3.dart';
import 'pages/test_page4.dart';
import 'pages/dynamic_page.dart';

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
      //设置了这个属性才会有不规则的居中按钮
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('点击了按钮');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return DynamicPage('新页面');
          }));
        },
        tooltip: '只是一个提示',
        child: Icon(Icons.add, color: Colors.red),
      ),

      //BottomNavigationBar  底部导航栏
      //BottomAppBar  底部工具栏
      //两个是有区别的
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        // 圆形缺口
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                }),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                }),
            IconButton(
                icon: Icon(Icons.contacts),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                }),
            IconButton(
                icon: Icon(Icons.map),
                onPressed: () {
                  setState(() {
                    _currentIndex = 3;
                  });
                }),
          ],
        ),
      ),
    );
  }
}
