import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongolian_culture/content/detail_page.dart';

import 'package:mongolian_culture/globals.dart' as globals;

import '../app_theme.dart';

class CustomPage extends StatefulWidget {
  @override
  _CustomPageState createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage> {
  List<Image> _imgList = <Image>[];
  List<Custom> _customList = <Custom>[];

  void setCostumeList() {
    _customList = <Custom>[
      Custom(
        index: CustomIndex.AOBAO,
        path: 'custom/aobao',
      ),
      Custom(
        index: CustomIndex.NADAM,
        path: 'custom/nadam',
      ),
    ];
  }

  loadAsset() async {
    for (int i = 0; i < _customList.length; i++) {
      await globals
          .getImg('contents/' + _customList[i].path + '/pic.jpg')
          .then((data) {
        setState(() {
          _imgList.add(new Image.network(data));
        });
      });
    }
  }

  Widget _showOne(int ind) {
    String title = '';
    switch (_customList[ind].index) {
      case CustomIndex.AOBAO:
        title = '祭敖包';
        break;
      case CustomIndex.NADAM:
        title = '那达慕大会';
        break;
    }
    return Column(children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(path: _customList[ind].path, title: title),
            ),
          );
        },
        child:Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          child: Container(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _imgList[ind],
                ),
              ],
            ),
          ),
        ),
      ),
      Center(
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          child: new Text(
            title,
            style: AppTheme.light_title,
          ),
        ),
      ),
    ]);
  }

  @override
  initState() {
    super.initState();
    setCostumeList();
    Future.delayed(
        Duration.zero,
            () => setState(() {
          loadAsset();
        }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (_imgList.length != 2) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text("习俗"),
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
              child: Text("习俗"),
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
                        _showOne(0),
                        _showOne(1),
                  ])),
        ),
      );
    }
  }
}

enum CustomIndex {
  AOBAO,
  NADAM,
}

class Custom {
  Custom({
    this.index,
    this.path,
  });

  CustomIndex index;
  String path;
}
