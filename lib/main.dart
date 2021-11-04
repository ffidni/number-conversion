import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home.dart';
import 'utils/keyboard.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xff2A3C44),
    systemNavigationBarColor: Color(0xff454748),
  ));
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}
