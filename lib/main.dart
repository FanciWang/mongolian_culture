import 'package:flutter/material.dart';
import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:mongolian_culture/globals.dart' as globals;
import 'package:mongolian_culture/entry/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CloudBaseAuthState authState = await globals.auth.getAuthState();
  if (authState==null || (authState!=null && (authState.authType == CloudBaseAuthType.ANONYMOUS))) {
//  print(authState.authType);
//  if (authState==null) {
    await globals.auth.signInAnonymously().then((success) {
      print(success);
      runApp(MyApp());
    }).catchError((err) {
      print(err);
    });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
