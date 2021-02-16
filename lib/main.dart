import 'package:flutter/material.dart';
import 'package:flutter_youtube_watcher/screen/LoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter YouTube API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
      ),

      home: LoginPage(),
      //      home: HomeScreen("enes@gmail.com", "1234456"),
    );
  }
}
