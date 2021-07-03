import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../globals.dart' as globals;

String _path;
String _title;

class DetailPage extends StatefulWidget {
  final String path;
  final String title;
  DetailPage({@required this.path, @required this.title}) {
    _path = this.path;
    _title = this.title;
  }
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Text _detailText;
  Image _detailImg;
  Icon like = Icon(Icons.favorite,size: 30,);
  Icon dislike = Icon(Icons.favorite_border,size: 30,);
  Icon currentIcon;
  Map myMap;
  List<dynamic> collect = <dynamic>[];

  loadAsset() async {
    await globals.readText('contents/'+_path+'/text.md').then((data) {
      setState(() {
        _detailText = new Text(
          data,
          style: AppTheme.body1,
        );
      });
    });
    await globals.getImg('contents/'+_path+'/pic.jpg').then((data) {
      setState(() {
        _detailImg = Image.network(data);
      });
    });
    await globals.db.collection('user').doc(globals.myId).get().then((res) {
      setState(() {
        collect=res.data[0]['collections'];
      });
      setState(() {
        currentIcon=dislike;
      });
      for(var item in res.data[0]['collections']) {
        if(item['path']==myMap['path']&&item['title']==myMap['title']){
          setState(() {
            currentIcon=like;
          });
        }
      }

          });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myMap={'path':_path,'title':_title};
    Future.delayed(
        Duration.zero,
        () => setState(() {
              loadAsset();
            }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (_detailText == null || _detailImg == null || currentIcon==null) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.mainColor,
            title: Center(
              child: Text(_title),
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
              child: Text(_title),
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
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(20)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _detailImg,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 10,
                        right: 10,
                      ),
                      child: _detailText,
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(right: 30),
                      child: GestureDetector(
                        onTap: (){
                          if(currentIcon==like){
                            setState(() {
                              currentIcon=dislike;
                          });
                            print(collect);
                            collect.removeWhere((item) => item['path']==myMap['path']&&item['title']==myMap['title']);
                          }
                          else{
                            setState(() {
                              currentIcon=like;
                            });
                            collect.add(myMap);
                          }
                          globals.db.collection('user').doc(globals.myId).update({
                            'collections': collect
                          }).then((res) {
      print('更新完成');
                          });
                        },
                        child:ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: currentIcon,
                      ),
                      ),
                    ),
                  ])),
        ),
      );
    }
  }
}
