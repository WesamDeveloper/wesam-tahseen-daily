import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CoreTeam extends StatelessWidget {
  const CoreTeam({super.key});
  static const screenRoute = '/team';

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('من أنا'),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Center(
          child: Column(
            children: [
              // صورة شخصية
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('images/me.png'),
                ),
              ),

              const SizedBox(height: 24),

              // الاسم
              const Text(
                'وسام الجنيد',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // التخصص
              const Text(
                'مبرمج تقنية معلومات - متخصص في Flutter',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // بطاقة الوصف
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: const Text(
                    'أنا وسام الجنيد، مطوّر تطبيقات ومبرمج في مجال تقنية المعلومات. أُتقن تطوير تطبيقات باستخدام Flutter مع التركيز على تصميم جذاب وتجربة مستخدم مثالية. أهدف إلى تقديم حلول ذكية ومبتكرة تلبي احتياجات المستخدمين وتحقق أداء عالي. شغوف بالتطوير المستمر والابتكار.',
                    style: TextStyle(fontSize: 16, height: 1.6,fontFamily: "Cairo"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // معلومات التواصل
              Column(
                children: [
                  ContactTile(
                    icon: Icons.phone,
                    title: '+967775904988',
                    onTap: () => _launchUrl('tel:+967775904988'),
                  ),
                  ContactTile(
                    icon: Icons.email,
                    title: 'ws531014@gmail.com',
                    onTap: () => _launchUrl('mailto:ws531014@gmail.com'),
                  ),
                  ContactTile(
                    icon: Icons.code,
                    title: 'github.com/WesamTechnology',
                    onTap: () => _launchUrl('https://github.com/WesamTechnology'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ويدجت مخصص لتنسيق سطر التواصل
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
      leading: Icon(icon, color: Colors.orange[400]),
      title: Text(title),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Colors.white,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}




