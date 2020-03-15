import 'package:flutter/material.dart';

class WrapLayout extends StatefulWidget {
  WrapLayout({Key key}) : super(key: key);

  @override
  _WrapLayoutState createState() => _WrapLayoutState();
}

class _WrapLayoutState extends State<WrapLayout> {
  List<Widget> list;

  @override
  void initState() {
    list = List<Widget>()..add(buildAddButton());
    super.initState();
  }

  Widget buildAddButton() {
    return GestureDetector(
      onTap: () {
        if (list.length < 9) {
          setState(() {
            // 这里第一次不可能为-1 因为初始化的时候添加了一个按钮
            list.insert(list.length - 1, buildPhoto());
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 80.0,
          height: 80.0,
          child: Icon(Icons.add),
          color: Colors.black54,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('流式布局'),
      ),
      body: Container(
        width: width,
        height: height * 0.5,
        color: Colors.grey,
        child: Wrap(
          children: list,
          spacing: 26.0,
        ),
      ),
    );
  }

  Widget buildPhoto() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 80.0,
        height: 80.0,
        color: Colors.amber,
        child: Center(
          child: Text('照片'),
        ),
      ),
    );
  }
}
