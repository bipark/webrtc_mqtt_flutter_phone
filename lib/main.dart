//
//  main.dart
//  Created by Park Billy on 2021/12/05.
//  rtlink.park@gmail.com
//

import 'package:flutter/material.dart';
import './views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebRTC Phone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage()
    );
  }
}