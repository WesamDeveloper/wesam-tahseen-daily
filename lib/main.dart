import 'package:dene/screen/begin.dart';
import 'package:dene/screen/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange[400],
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontFamily: "Rakkas",
              fontSize: 28,
              color: Colors.black)
        )
      ),
      home: SplashScreen(),
    );
  }
}
