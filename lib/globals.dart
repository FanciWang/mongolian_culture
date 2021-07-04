import 'dart:io';

import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_storage/cloudbase_storage.dart';
import 'package:cloudbase_database/cloudbase_database.dart';
import 'package:dio/dio.dart';
//import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as j;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

CloudBaseCore core = CloudBaseCore.init({
  'env': 'flutter-0gfr3y8dcab04247',
  'appAccess': {'key': '132bd151e45a46d32a4056e20daeb1a7', 'version': '1'},
});
CloudBaseAuth auth = CloudBaseAuth(core);
CloudBaseStorage storage = CloudBaseStorage(core);
CloudBaseDatabase db = CloudBaseDatabase(core);
String myId;
String myName;
Future<String> readText(String dir) async{
  List<String> fileIds = [
    'cloud://flutter-0gfr3y8dcab04247.666c-flutter-0gfr3y8dcab04247-1305329163/'+dir
  ];
  CloudBaseStorageRes<List<DownloadMetadata>> res = await storage.getFileDownloadURL(fileIds);
  return getHttp(res.data[0].downloadUrl);
}
Future<String> getHttp(String url) async {
  try {
    Response response = await Dio().get(url);
    return response.data.toString();
  } catch (e) {
    print(e);
  }
}
Future<String> getImg(String dir) async{
  List<String> fileIds = [
    'cloud://flutter-0gfr3y8dcab04247.666c-flutter-0gfr3y8dcab04247-1305329163/'+dir
  ];
  CloudBaseStorageRes<List<DownloadMetadata>> res = await storage.getFileDownloadURL(fileIds);
  return res.data[0].downloadUrl;
}
