import 'package:flutter/material.dart';
 
 class DynamicPage extends StatefulWidget {
   // 为什么要注释 ？不知道！
  //  DynamicPage({Key key}) : super(key: key);
 String _title;
 DynamicPage(this._title);
   @override
   _DynamicPageState createState() => _DynamicPageState();
 }
 
 class _DynamicPageState extends State<DynamicPage> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.yellow,
       appBar: AppBar(
         backgroundColor: Colors.red,
         //隐藏左侧返回导航栏
         leading: Container(),
         title: Text(
           widget._title,
           style: TextStyle(
             fontSize: 40
           ),
           ),
         elevation: 4.0,
       ),
       body: Center(
         child:MaterialButton(
           onPressed: (){
Navigator.of(context).pop();
           },
           child: Icon(
             Icons.arrow_back,
             size:40.0,
           ),
           )
       ),
     );
   }
 }