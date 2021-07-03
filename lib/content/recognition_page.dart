import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../globals.dart' as globals;

class RecognitionPage extends StatefulWidget {
  @override
  _RecognitionPageState createState() => _RecognitionPageState();
}

class _RecognitionPageState extends State<RecognitionPage> {
  List<Widget> _listText = <Widget>[];

  loadAsset() async {
    await globals.readText('recognition/yolov2_tiny_cn.md').then((data) {
      setState(() {
        for(String item in data.split('\n')){
          _listText.add(Container(
            padding: EdgeInsets.all(10.0),
              child:Text(item,style: AppTheme.body1,)));
        }
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
        Duration.zero,
            () => setState(() {
          loadAsset();
        }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (_listText.length==0) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text("分类目录"),
            ),
            leading: new IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },),
          ),
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: AppTheme.subColor,
              valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.mainColor),
            ),
          ),
        ),
      );
    } else {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text("分类目录"),
            ),
            leading: new IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },),
          ),
          body: ListView(
            children:_listText,
          )
        ),
      );
    }
  }
}
