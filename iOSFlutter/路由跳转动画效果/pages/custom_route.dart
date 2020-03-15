import 'package:flutter/material.dart';

class CustomRoute extends PageRouteBuilder {
  final Widget widget;
  CustomRoute(this.widget)
      : super(
            transitionDuration: Duration(seconds: 1),
            //固定格式
            pageBuilder: (
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
            ) {
              return widget;
            },
            // 这个是关键  所有的逻辑都在这个里面
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation1,
              Animation<double> animation2,
              Widget child,
            ) {
              // ----------------------------渐隐渐现效果
              // return FadeTransition(
              //   opacity: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
              //     parent:animation1,
              //     curve: Curves.fastOutSlowIn
              //   )),
              //   child: child,
              //   );

              // ----------------------------缩放效果
              // return ScaleTransition(
              //   scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
              //     parent:animation1,
              //     curve: Curves.fastOutSlowIn
              //   )),
              //   child: child,
              //   );

              // ----------------------------旋转+缩放效果
              // return RotationTransition(
              //   turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              //       parent: animation1, curve: Curves.fastOutSlowIn)),
              //   child: ScaleTransition(
              //       scale: Tween(begin: 0.0,end: 1.0).animate(CurvedAnimation(
              //     parent:animation1,
              //     curve: Curves.fastOutSlowIn
              //   )),
              //   child: child,
              //     ),
              // );

              // ----------------------------左右滑动效果
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(-1.0, 0.0),
                  end: Offset(0.0, 0.0)
                  ).animate(CurvedAnimation(
                  parent:animation1,
                  curve: Curves.fastOutSlowIn
                )),
                child: child,
                );
            });
}
