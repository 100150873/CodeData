import 'package:flutter/material.dart';

class ExpansionTilePage extends StatefulWidget {
  ExpansionTilePage({Key key}) : super(key: key);

  @override
  _ExpansionTilePageState createState() => _ExpansionTilePageState();
}

class _ExpansionTilePageState extends State<ExpansionTilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'expansionTile'
        ),
      ),
      body: Center(
        child: ExpansionTile(
          title: Text('标题'),
          leading: Icon(Icons.ac_unit),
          backgroundColor: Colors.white12,
          //默认打开 or 闭合
          initiallyExpanded: true,
          children: <Widget>[
            ListTile(
              title: Text('主标题'),
              subtitle: Text('子标题'),
            )
          ],
          ),
        
      ),
    );
  }
}