import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mongolian_culture/content/detail_page.dart';

import 'package:mongolian_culture/globals.dart' as globals;

import '../app_theme.dart';

class LandscapePage extends StatefulWidget {
  @override
  _LandscapePageState createState() => _LandscapePageState();
}

class _LandscapePageState extends State<LandscapePage> {
  List<Image> _natureImgList = <Image>[];
  List<Image> _humanImgList = <Image>[];
  List<Nature> _natureList = <Nature>[];
  List<Human> _humanList = <Human>[];

  void setNatureList() {
    _natureList = <Nature>[
      Nature(
        index: NatureIndex.DESERT,
        path: 'landscape/nature/desert',
        title: '响沙湾',
      ),
      Nature(
        index: NatureIndex.FOREST,
        path: 'landscape/nature/forest',
        title: '大兴安岭',
      ),
      Nature(
        index: NatureIndex.PRAIRIE,
        path: 'landscape/nature/prairie',
        title: '呼伦贝尔大草原',
      ),
    ];
  }

  void setHumanList() {
    _humanList = <Human>[
      Human(
        index: HumanIndex.CEMETERY,
        path: 'landscape/human/cemetery',
        title: '昭君墓',
      ),
      Human(
        index: HumanIndex.MAUSOLEUM,
        path: 'landscape/human/mausoleum',
        title: '成吉思汗陵',
      ),
      Human(
        index: HumanIndex.YURTS,
        path: 'landscape/human/yurts',
        title: '蒙古包',
      ),
    ];
  }

  loadAsset() async {
    for (int i = 0; i < _natureList.length; i++) {
      await globals
          .getImg('contents/' + _natureList[i].path + '/pic.jpg')
          .then((data) {
        setState(() {
          _natureImgList.add(new Image.network(
            data,
            fit: BoxFit.contain,
          ));
        });
      });
    }
    for (int i = 0; i < _humanList.length; i++) {
      await globals
          .getImg('contents/' + _humanList[i].path + '/pic.jpg')
          .then((data) {
        setState(() {
          _humanImgList.add(new Image.network(
            data,
            fit: BoxFit.contain,
          ));
        });
      });
    }
  }
  @override
  initState() {
    super.initState();
    setNatureList();
    setHumanList();
    Future.delayed(
        Duration.zero,
        () => setState(() {
              loadAsset();
            }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (_natureImgList.length != 3 || _humanImgList.length != 3) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text("景观"),
            ),
            leading: new IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
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
              child: Text("景观"),
            ),
            leading: new IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(30.0),
              child: new ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            "自然景观",
                            style: AppTheme.light_title,
                          )),
                          Container(
                            child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: new Swiper(
                                    layout: SwiperLayout.CUSTOM,
                                    customLayoutOption: new CustomLayoutOption(
                                            startIndex: -1, stateCount: 3)
                                        .addTranslate([
                                      new Offset(-320.0, -40.0),
                                      new Offset(0.0, 0.0),
                                      new Offset(320.0, -40.0)
                                    ]),
                                    itemWidth: 300.0,
                                    itemHeight: 200.0,
                                    itemBuilder: (context, index) {
                                      return new GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  path: _natureList[index].path,
                                                  title:
                                                      _natureList[index].title),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: new Center(
                                            child: _natureImgList[index],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: _natureImgList.length)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            "人文景观",
                            style: AppTheme.light_title,
                          )),
                          Container(
                            child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: new Swiper(
                                    layout: SwiperLayout.CUSTOM,
                                    customLayoutOption: new CustomLayoutOption(
                                            startIndex: -1, stateCount: 3)
                                        .addTranslate([
                                      new Offset(-320.0, -40.0),
                                      new Offset(0.0, 0.0),
                                      new Offset(320.0, -40.0)
                                    ]),
                                    itemWidth: 300.0,
                                    itemHeight: 200.0,
                                    itemBuilder: (context, index) {
                                      return new GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                  path: _humanList[index].path,
                                                  title:
                                                      _humanList[index].title),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: new Center(
                                            child: _humanImgList[index],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: _humanImgList.length)),
                          )
                        ],
                      ),
                    ),
                  ])),
        ),
      );
    }
  }
}

enum NatureIndex {
  DESERT,
  FOREST,
  PRAIRIE,
}

enum HumanIndex {
  CEMETERY,
  MAUSOLEUM,
  YURTS,
}

class Nature {
  Nature({
    this.index,
    this.path,
    this.title,
  });

  NatureIndex index;
  String path;
  String title;
}

class Human {
  Human({
    this.index,
    this.path,
    this.title,
  });

  HumanIndex index;
  String path;
  String title;
}
