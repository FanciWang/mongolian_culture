import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongolian_culture/content/detail_page.dart';

import 'package:mongolian_culture/globals.dart' as globals;

import '../app_theme.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  List<NetworkImage> _imgList = <NetworkImage>[];
  List<Music> _musicList = <Music>[];

  void setCostumeList() {
    _musicList = <Music>[
      Music(
        index: MusicIndex.FOLK_SONG,
        path: 'music/folk_song',
      ),
      Music(
        index: MusicIndex.FOUR_STRINGED,
        path: 'music/four_stringed',
      ),
      Music(
        index: MusicIndex.HORSE_HEAD,
        path: 'music/horse_head',
      ),
      Music(
        index: MusicIndex.KHOOMEI,
        path: 'music/khoomei',
      ),
    ];
  }

  loadAsset() async {
    for (int i = 0; i < _musicList.length; i++) {
      await globals
          .getImg('contents/' + _musicList[i].path + '/pic.jpg')
          .then((data) {
        setState(() {
          _imgList.add(NetworkImage(data));
        });
      });
    }
  }

  Widget _showOne(int ind) {
    String title = '';
    switch (_musicList[ind].index) {
      case MusicIndex.FOLK_SONG:
        title = '长调民歌';
        break;
      case MusicIndex.FOUR_STRINGED:
        title = '四胡';
        break;
      case MusicIndex.HORSE_HEAD:
        title = '马头琴';
        break;
      case MusicIndex.KHOOMEI:
        title = '呼麦';
        break;
    }
    return Column(children: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(path: _musicList[ind].path, title: title),
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
              child: Text("音乐"),
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
              child: Text("音乐"),
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

enum MusicIndex {
  FOLK_SONG,
  FOUR_STRINGED,
  HORSE_HEAD,
  KHOOMEI,
}

class Music {
  Music({
    this.index,
    this.path,
  });

  MusicIndex index;
  String path;
}
