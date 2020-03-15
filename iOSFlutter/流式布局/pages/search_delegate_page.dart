import 'package:flutter/material.dart';
import 'package:listview_demo/pages/test_data.dart';

class SearchTestDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // 右侧图标
    return [
    IconButton(
      icon: Icon(Icons.clear), 
      onPressed: (){
        query = '';
    })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // 左侧返回按钮
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation
        ),
        onPressed: (){
          close(context, null);
        },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // 搜索结果
    return Container(
      width: 100.0,
      height: 300.0,
      color: Colors.yellow,
      child: Center(
        child: Text(
        query
      ),
      )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // 推荐
final suggestionList = query.isEmpty 
? test1Data 
: test2Data.where((input)=> input.startsWith(query)).toList();
    return ListView.builder(
      
      itemCount: suggestionList.length,
      itemBuilder: (context,index)=> ListTile(
        
        title: RichText(
          
          text: TextSpan(
            children: [
              TextSpan(
                text: suggestionList[index].substring(query.length),
                style: TextStyle(color: Colors.grey)
              )
            ],
            text: suggestionList[index].substring(0,query.length),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold
            )
          )
          ),
          
      ) ,
      
      );
  }
  
}