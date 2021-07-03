import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'detail_page.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  Widget showCard(int period,String title){
    String text='';
    switch(period){
      case 1:
        text='一';
        break;
      case 2:
        text='二';
        break;
      case 3:
        text='三';
        break;
      case 4:
        text='四';
        break;
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(path: 'history/period_'+period.toString(), title: "阶段"+text),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child:Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(20)),
        child: Row(
          children: [
            Text("阶段"+text,style: AppTheme.cardText,),
            Text('\t\t\t\t'),
            Text(title, style: AppTheme.cardTextSub,)
          ],
        ),
      ),
    )
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.mainColor,
          title: Center(
            child: Text("历史"),
          ),
          leading: new IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },),
        ),
        body: Padding(
            padding: EdgeInsets.all(30.0),
            child: new ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  showCard(1,"原始社会时期"),
                  showCard(2,"民族的统一与对外征伐"),
                  showCard(3,"元朝灭亡后的蒙古诸部"),
                  showCard(4,"蒙古国的独立\n内蒙古自治区的建立"),
                ])),
      ),
    );
  }

}