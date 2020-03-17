import 'package:flutter/material.dart';
import 'package:listview_demo/flutter_bottom_tabbar.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
/*动画事件监听器，
    它可以监听到动画的执行状态，
    如果结束则执行页面跳转动作。 */
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => BottomTabbarWidgetWidget()),
            (route) => route == null);
      }
    });
//播放动画
    _controller.forward();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 透明度动画组件
    return FadeTransition(
      //执行动画
      opacity: _animation,
      // 网络图片
      child: Image.network(
        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1584464988620&di=26ce3c9d01abb9b5223360b83a7f4162&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20181003%2F0f8307fe3de6468d8b51c53b276e9e1b.jpeg',
        //缩放
        scale: 2.0,
        fit: BoxFit.cover,
        ),
      );
  }
}
