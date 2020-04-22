import 'package:flutter/material.dart';

import 'package:serverx_poc/Pages/LoginAd.dart';
import 'package:serverx_poc/Pages/LoginB2C.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: LoginAd.route,
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          LoginAd.route: (context) => LoginAd(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          LoginB2C.route: (context) => LoginB2C(),
        });
  }
}
