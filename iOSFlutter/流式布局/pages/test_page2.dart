import 'package:flutter/material.dart';
import 'test_page4.dart';

class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({Key key}) : super(key: key);

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('demo'),
        bottom: TabBar(controller: _controller, tabs: [
          Tab(
            icon: Icon(Icons.arrow_back),
          ),
          Tab(
            icon: Icon(Icons.card_giftcard),
          ),
          Tab(
            icon: Icon(Icons.donut_large),
          ),
        ]),
      ),
      body: TabBarView(
        children: <Widget>[
          TestPage4(),
          TestPage4(),
          TestPage4(),
        ],
        controller: _controller,
      ),
    );
  }
}
