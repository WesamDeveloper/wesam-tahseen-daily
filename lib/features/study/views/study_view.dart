import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class StudyView extends StatelessWidget {
  const StudyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.studyTitle),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Study here",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
