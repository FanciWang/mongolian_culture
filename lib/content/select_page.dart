import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mongolian_culture/globals.dart' as globals;

import '../app_theme.dart';
import 'detail_page.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  List<BriefInfo> biList = <BriefInfo>[];
  bool _loadFinished = false;

  loadAsset() async {
    List<dynamic> collect = <dynamic>[];
    await globals.db
        .collection('user')
        .doc(globals.myId)
        .get()
        .then((res) async {
      for (var item in res.data[0]['collections']) {
        String img, short;
        await globals
            .readText('contents/' + item['path'] + '/text.md')
            .then((data) {
          short = data.substring(0, 15)+'...';
        });
        await globals
            .getImg('contents/' + item['path'] + '/pic.jpg')
            .then((data) {
          img = data;
        });
        biList.add(BriefInfo(
          title: item['title'],
          img: img,
          short: short,
          path: item['path'],
        ));
      }
    });
    setState(() {
      _loadFinished = true;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration.zero,
        () => setState(() {
              loadAsset();
            }));
  }

  cardOne(int ind) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DetailPage(path: biList[ind].path, title: biList[ind].title),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusDirectional.circular(20)),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(left:10.0,top:10.0,bottom:10.0,right:30.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(biList[ind].img),
                              fit: BoxFit.cover)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          biList[ind].title,
                          style: AppTheme.body1,
                        ),
                        Text(
                          biList[ind].short,
                          style: AppTheme.body2,
                        )
                      ],
                    )
                  ],
                ),
              )),
        ));
  }

  Widget _render(BuildContext context, int index) {
    return cardOne(index);
  }

  cardAll() {
    List<Widget> res = <Widget>[];
    for (int i = 0; i < biList.length; i++) {
      res.add(cardOne(i));
    }
    return res;
  }

  Future<Null> _onRefresh() async {
    _loadFinished=false;
    biList.clear();
    Future.delayed(
        Duration.zero,
            () => setState(() {
          loadAsset();
        }));
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (!_loadFinished) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text("收藏"),
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
              child: Text("收藏"),
            ),
            leading: new IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: RefreshIndicator(
            color: AppTheme.mainColor,
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: _render,
              itemCount: biList.length,
            ),
          ),
        ),
      );
    }
  }
}


class BriefInfo {
  BriefInfo({
    this.title,
    this.img,
    this.short,
    this.path,
  });

  String title;
  String img;
  String short;
  String path;
}
