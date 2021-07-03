import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongolian_culture/content/detail_page.dart';

import 'package:mongolian_culture/globals.dart' as globals;

import '../app_theme.dart';

class CostumesPage extends StatefulWidget {
  @override
  _CostumesPageState createState() => _CostumesPageState();
}

class _CostumesPageState extends State<CostumesPage> {
  List<NetworkImage> _imgList = <NetworkImage>[];
  List<Costumes> _costumeList = <Costumes>[];

  void setCostumeList() {
    _costumeList = <Costumes>[
      Costumes(
        index: CostumeIndex.BELT,
        path: 'costumes/belt',
      ),
      Costumes(
        index: CostumeIndex.BOOT,
        path: 'costumes/boot',
      ),
      Costumes(
        index: CostumeIndex.HEADGEAR,
        path: 'costumes/headgear',
      ),
      Costumes(
        index: CostumeIndex.ROBE,
        path: 'costumes/robe',
      ),
    ];
  }

  loadAsset() async {
    for (int i = 0; i < _costumeList.length; i++) {
      await globals
          .getImg('contents/' + _costumeList[i].path + '/pic.jpg')
          .then((data) {
        setState(() {
          _imgList.add(NetworkImage(data));
        });
      });
    }
  }

  Widget _showOne(int ind) {
    String title = '';
    String path = '';
    switch (_costumeList[ind].index) {
      case CostumeIndex.BELT:
        title = '腰带';
        path = 'costumes/belt';
        break;
      case CostumeIndex.BOOT:
        title = '靴子';
        path = 'costumes/boot';
        break;
      case CostumeIndex.HEADGEAR:
        title = '头饰';
        path = 'costumes/headgear';
        break;
      case CostumeIndex.ROBE:
        title = '长袍';
        path = 'costumes/robe';
        break;
    }
    return Column(children: [
        GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(path: path, title: title),
        ),
      );
    },
    child:Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: _imgList[ind], fit: BoxFit.cover)),
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
    if (_imgList.length != 4) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text("服饰"),
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
              child: Text("服饰"),
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
                    Row(
                      children: [
                        _showOne(0),
                        _showOne(1),
                      ],
                    ),
                    Row(
                      children: [
                        _showOne(2),
                        _showOne(3),
                      ],
                    )
                  ])),
        ),
      );
    }
  }
}

enum CostumeIndex {
  BELT,
  BOOT,
  HEADGEAR,
  ROBE,
}

class Costumes {
  Costumes({
    this.index,
    this.path,
  });

  CostumeIndex index;
  String path;
}
