import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main(){
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:MyHomePage(title:'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget{
  MyHomePage({Key key, this.title}):super(key:key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Icon(Icons.star,color: Colors.green[500],),
            new Icon(Icons.star,color: Colors.green[500],),
            new Icon(Icons.star,color: Colors.green[500],),
            new Icon(Icons.star,color: Colors.black,),
            new Icon(Icons.star,color: Colors.black,),
          ],

        ),
      ),
    );
  }
}
