import 'package:flutter/material.dart';

class ExpansionTileListDemo extends StatefulWidget {
  ExpansionTileListDemo({Key key}) : super(key: key);

  @override
  _ExpansionTileListDemoState createState() => _ExpansionTileListDemoState();
}

class _ExpansionTileListDemoState extends State<ExpansionTileListDemo> {
  List<int> list;
  List<ExpandStateBean> list1;

  @override
  void initState() {
    // TODO: implement initState

    list = new List();
    list1 = new List();
    for (var i = 0; i < 10; i++) {
      list.add(i);
      list1.add(ExpandStateBean(false, i));
    }
    super.initState();
  }

  _changeRowState(int index, isExpand) {
    setState(() {
      ExpandStateBean stateBean = list1[index];
      stateBean.isOpen = isExpand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('折叠列表'),
      ),
      //加入可滚动组件
      body: SingleChildScrollView(
        // 必须放在 SingleChildScrollView 才有效
        child: ExpansionPanelList(
          expansionCallback: (index, bol) {
            _changeRowState(index, !bol);
          },
          //进行map操作，然后用toList再次组成List
          children: list1.map((value) {
            return ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text('序号：${value.index}'),
                  );
                },
                body: ListTile(
                  title: Text('子标题：${value.index}'),
                ),
                isExpanded: value.isOpen
                );
          }).toList(),
        ),
      ),
    );
  }
}

class ExpandStateBean {
  var isOpen;
  var index;
  ExpandStateBean(this.isOpen, this.index);
}
