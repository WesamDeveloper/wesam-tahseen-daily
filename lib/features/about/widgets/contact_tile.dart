import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ContactTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: AppColors.white,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
