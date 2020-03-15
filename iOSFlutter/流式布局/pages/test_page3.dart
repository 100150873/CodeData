import 'dart:ui' as prefix0;

import 'package:flutter/material.dart';

class TestPage3 extends StatelessWidget {
  const TestPage3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text('磨砂玻璃效果'),
          ),
          body: Stack(
            children: <Widget>[
              // 约束盒子组件，添加额外的约束条件child上
              ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: Image.network(
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1584261673935&di=9f079a8666db46078ece4b2ef96c5fef&imgtype=0&src=http%3A%2F%2F00.minipic.eastday.com%2F20170325%2F20170325161855_5864e3bb430ea85fee365bcc99539938_27.jpeg'),
              ),
              Center(
                child: ClipRect(
                  //可裁剪的矩形
                  //背景过滤器
                  child: BackdropFilter(
                    filter: prefix0.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        width: 500.0,
                        height: 700.0,
                        decoration: BoxDecoration(color: Colors.grey.shade200),
                        child: Center(
                          child: Text(
                            '磨砂滤镜效果',
                            //文字样式
                            style: Theme.of(context).textTheme.display3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
