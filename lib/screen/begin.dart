import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dene/screen/home_page.dart'; // تأكد من استبدال هذا بالمسار الصحيح لـ HomePage

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // يمكنك تغيير لون الخلفية
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/dene.png',
              height: 160,
            ),
            const SizedBox(height: 20),
            const Text(
              'صلي على النبي',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Cairo"
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
