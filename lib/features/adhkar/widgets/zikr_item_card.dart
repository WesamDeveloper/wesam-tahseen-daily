import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ZikrItemCard extends StatelessWidget {
  final String text;
  final int count;
  final double fontSize;
  final VoidCallback onTap;

  const ZikrItemCard({
    super.key,
    required this.text,
    required this.count,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.cardBackground,
        margin: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: onTap,
              child: Text(count.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
