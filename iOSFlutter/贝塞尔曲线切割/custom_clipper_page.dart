import 'dart:ui';
import 'package:flutter/material.dart';

class CustomClipperPage extends StatelessWidget {
  const CustomClipperPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('自定义贝塞尔曲线'),
      ),
      body: Column(
        children: <Widget>[
          ClipPath(
            clipper: BottomClipper(),
            child: Container(
              color: Colors.deepOrangeAccent,
              height: 200.0,
            ),
          )
        ],
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 30);
    var firstControlPoint = Offset(size.width * 0.5, size.height);
    var firstEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
