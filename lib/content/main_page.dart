import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_loading/m_loading.dart';
import 'package:mongolian_culture/content/costumes_page.dart';
import 'package:mongolian_culture/content/custom_page.dart';
import 'package:mongolian_culture/content/detail_page.dart';
import 'package:mongolian_culture/content/music_page.dart';
import 'package:mongolian_culture/content/select_page.dart';
import 'package:mongolian_culture/globals.dart' as globals;
import 'package:mongolian_culture/app_theme.dart';
import 'package:path_provider/path_provider.dart';

import 'history_page.dart';
import 'landscape_page.dart';
import 'language_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Text _overviewText;
  Text _shortText;
  Image _overviewImg;
  List<MongolianCulture> _mcList;
  List<Image> _overallImgList = <Image>[];
  List<GlobalKey> _keyList = <GlobalKey>[];
  ScrollController _scrollController;
  List<Widget> _introList = <Widget>[];
  get _drawer => Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.subColor,
              ),
              child: Center(
                child: SizedBox(
                  width: 60.0,
                  height: 60.0,
                  child: CircleAvatar(
                    backgroundColor: AppTheme.mainColor,
                    child: Text(globals.myName),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectPage(),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text('收藏'),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('设置'),
            ),
          ],
        ),

        ///edit end
      );

  loadAsset() async {
    await globals.readText('contents/mongolian_intro/text.md').then((data) {
      setState(() {
        _overviewText = new Text(data);
        _shortText = new Text(
          '\n\n\n' + data.substring(0, 100) + '...',
        );
      });
    });
    await globals.getImg('contents/mongolian_intro/pic.jpg').then((data) {
      setState(() {
        _overviewImg = Image.network(data);
      });
    });
    for (int i = 0; i < _mcList.length; i++) {
      String path = '';
      switch (_mcList[i].index) {
        case MCIndex.MUSIC:
          path = 'music';
          break;
        case MCIndex.CUSTOM:
          path = 'custom';
          break;
        case MCIndex.COSTUMES:
          path = 'costumes';
          break;
        case MCIndex.HISTORY:
          path = 'history';
          break;
        case MCIndex.LANGUAGE:
          path = 'language';
          break;
        case MCIndex.LANDSCAPE:
          path = 'landscape';
          break;
      }
      await globals.getImg('contents/' + path + '/overall.jpg').then((data) {
        setState(() {
          _overallImgList.add(Image.network(data));
        });
      });
    }
    setIntroList();
  }

  Widget _introOne(int ind) {
    String title = '';
    Widget page;
    switch (_mcList[ind].index) {
      case MCIndex.MUSIC:
        title = '音乐';
        page = MusicPage();
        break;
      case MCIndex.CUSTOM:
        title = '习俗';
        page = CustomPage();
        break;
      case MCIndex.COSTUMES:
        title = '服饰';
        page = CostumesPage();
        break;
      case MCIndex.HISTORY:
        title = '历史';
        page = HistoryPage();
        break;
      case MCIndex.LANGUAGE:
        title = '文字';
        page = LanguagePage();
        break;
      case MCIndex.LANDSCAPE:
        title = '景观';
        page = LandscapePage();
        break;
    }
    _keyList.add(new GlobalKey());
    return Container(
      key: _keyList[ind],
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Center(
            child: Text(
              title,
              style: AppTheme.light_title,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => page,
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _overallImgList[ind],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void setMCList() {
    _mcList = <MongolianCulture>[
      MongolianCulture(
        index: MCIndex.HISTORY,
        selected: false,
      ),
      MongolianCulture(
        index: MCIndex.COSTUMES,
        selected: false,
      ),
      MongolianCulture(
        index: MCIndex.LANDSCAPE,
        selected: false,
      ),
      MongolianCulture(
        index: MCIndex.CUSTOM,
        selected: false,
      ),
      MongolianCulture(
        index: MCIndex.LANGUAGE,
        selected: false,
      ),
      MongolianCulture(
        index: MCIndex.MUSIC,
        selected: false,
      ),
    ];
  }

  void setKeyList() {
    _keyList = <GlobalKey>[
      new GlobalKey(),
      new GlobalKey(),
      new GlobalKey(),
      new GlobalKey(),
      new GlobalKey(),
      new GlobalKey(),
    ];
  }

  void setIntroList() {
    _introList = <Widget>[
      _introOne(0),
      _introOne(1),
      _introOne(2),
      _introOne(3),
      _introOne(4),
      _introOne(5),
    ];
  }

  @override
  initState() {
    super.initState();
    setMCList();
//    setKeyList();
//    setIntroList();
    _scrollController = new ScrollController();
    Future.delayed(
        Duration.zero,
        () => setState(() {
              loadAsset();
            }));
  }

  pressButton(int index) {
    setState(() {
      _mcList[index].selected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _overviewCard() {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailPage(path: 'mongolian_intro', title: '蒙古族简介'),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(20)),
          child: Container(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _overviewImg,
                ),
                Container(
                  child: new Text(
                    '蒙古族',
                    style: AppTheme.head_title,
                  ),
                  padding: EdgeInsets.all(10.0),
                ),
                Container(
                  child: _shortText,
                  padding: EdgeInsets.all(10.0),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget _mcListRow1() {
      return Container(
        height: 100,
        margin: EdgeInsets.only(top: 30.0),
        child: new Row(
          children: <Widget>[
            Expanded(
              child: new TextButton(
                onPressed: () {
                  setState(() {
                    _mcList[0].selected = true;
                  });
                },
                child: new Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF86B1D3),
                  ),
                  child: Center(
                    child: new Text(
                      '历史',
                      style: AppTheme.title,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: new TextButton(
                onPressed: () {
                  setState(() {
                    _mcList[1].selected = true;
                  });
                },
                child: new Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3797D3),
                  ),
                  child: Center(
                    child: new Text(
                      '服饰',
                      style: AppTheme.title,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: new TextButton(
                onPressed: () {
                  setState(() {
                    _mcList[2].selected = true;
                  });
                },
                child: new Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2390D1),
                  ),
                  child: Center(
                    child: new Text(
                      '景观',
                      style: AppTheme.title,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _mcListRow2() {
      return Container(
        height: 100,
        child: new Row(
          children: <Widget>[
            Expanded(
              child: new TextButton(
                onPressed: () {
                  setState(() {
                    _mcList[3].selected = true;
                  });
                },
                child: new Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFBE5AA),
                  ),
                  child: Center(
                    child: new Text(
                      '习俗',
                      style: AppTheme.title,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: new TextButton(
                onPressed: () {
                  setState(() {
                    _mcList[4].selected = true;
                  });
                },
                child: new Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF6B87D),
                  ),
                  child: Center(
                    child: new Text(
                      '文字',
                      style: AppTheme.title,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: new TextButton(
                onPressed: () {
                  setState(() {
                    _mcList[5].selected = true;
                  });
                },
                child: new Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE7A875),
                  ),
                  child: Center(
                    child: new Text(
                      '音乐',
                      style: AppTheme.title,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_overviewImg == null ||
        _overviewText == null ||
        _mcList.length != _overallImgList.length) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text('蒙忆'),
            ),
          ),
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: AppTheme.subColor,
              valueColor: new AlwaysStoppedAnimation<Color>(AppTheme.mainColor),
            ),
          ),
          drawer: _drawer,
        ),
      );
    } else {
      for (int i = 0; i < _mcList.length; i++) {
        if (_mcList.elementAt(i).selected) {
//          print(_keyList[i]);
//          RenderBox renderBox = _keyList[i].currentContext.findRenderObject();
//          var offset = renderBox.localToGlobal(Offset.zero);
//          print(offset.dy);
//          _scrollController.animateTo(offset.dy,
//              duration: new Duration(seconds: 2), curve: Curves.ease);

          _scrollController.animateTo(570 + i * 415.0,
              duration: new Duration(seconds: 2), curve: Curves.ease);
          _mcList.elementAt(i).selected = false;
        }
      }
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text('蒙忆'),
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(30.0),
//              child: Column(children: <Widget>[
////                _overviewText,
//                _overviewCard(),
//                _mcListRow1(),
//                _mcListRow2(),
//              ])),
              child: new ListView(
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  children: <Widget>[
                    _overviewCard(),
                    _mcListRow1(),
                    _mcListRow2(),
                    _introList[0],
                    _introList[1],
                    _introList[2],
                    _introList[3],
                    _introList[4],
                    _introList[5],
                  ])),
          drawer: _drawer,
        ),
      );
    }
  }
}

enum MCIndex {
  COSTUMES,
  CUSTOM,
  HISTORY,
  LANDSCAPE,
  LANGUAGE,
  MUSIC,
}

class MongolianCulture {
  MongolianCulture({
    this.index,
    this.selected = false,
  });

  MCIndex index;
  bool selected;
}
