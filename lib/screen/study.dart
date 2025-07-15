import 'package:flutter/material.dart';


class Study extends StatefulWidget {
  const Study({super.key});

  @override
  State<Study> createState() => _StudyState();
}

class _StudyState extends State<Study> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(title: Text("الدروس"),centerTitle: true,),
      body: Center(child: Text("Study here",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),),
    );
  }
}
