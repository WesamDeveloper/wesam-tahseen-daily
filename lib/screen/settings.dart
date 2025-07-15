import 'package:flutter/material.dart';


class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الضبط"),centerTitle: true,),
      body: Center(child: Text("Setting here",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
    );
  }
}
