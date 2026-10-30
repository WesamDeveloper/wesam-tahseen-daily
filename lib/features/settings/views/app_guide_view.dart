import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';

class AppGuideView extends StatelessWidget {
  const AppGuideView({super.key});

  static const Color _pageBg = Color(0xFFF2F2F7);
  static const Color _cardBg = Colors.white;
  static const Color _borderColor = Color(0xFFE5E5EA);
  static const Color _dividerColor = Color(0xFFE5E5EA);
  static const Color _textPrimary = Color(0xFF1C1C1E);
  static const Color _textSecondary = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      appBar: AppBar(
        title: const Text(
          AppStrings.appGuideTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: AppStrings.fontCairo,
            fontSize: 18.5,
            color: _textPrimary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _cardBg,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: _textPrimary),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(0.8),
          child: Divider(height: 0.8, color: _borderColor),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          children: [
            // Intro Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor, width: 0.8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.auto_stories_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'دليلك الشامل في تطبيق وسام',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppStrings.fontCairo,
                            color: _textPrimary,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'إرشادات استخدام الأذكار، المصحف، التلاوات، والتذكيرات الذكية.',
                          style: TextStyle(
                            fontSize: 12,
                            color: _textSecondary,
                            fontFamily: AppStrings.fontCairo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Guide 1: Athkar
            _buildGuideCard(
              stepNumber: '01',
              icon: Icons.mosque_rounded,
              iconBg: const Color(0xFFFF9500),
              title: 'أذكار الصباح والمساء والتحصين',
              tag: 'الأذكار والتحصين',
              tagColor: const Color(0xFFFF9500),
              tagBg: const Color(0xFFFFF3E0),
              description:
                  'تصفح أذكار الصباح، المساء، النوم، السفر، وأذكار الهم والكرب. اضغط على أي ذكر بعد قراءته لإنقاص العداد الفردي حتى يكتمل. كما تتوفر مسبحة إلكترونية للتسبيح المفتوح مع حفظ مجموع قراءاتك محليًا.',
              tips: [
                'اضغط على بطاقة الذكر لإنقاص عداد التكرار تلقائيًا.',
                'استخدم المسبحة للتسبيح الحر مع حفظ إجمالي الأذكار.',
                'جميع إحصائياتك وقراءاتك محفوظة محليًا دون انترنت.',
              ],
            ),

            const SizedBox(height: 14),

            // Guide 2: Quran Reading
            _buildGuideCard(
              stepNumber: '02',
              icon: Icons.menu_book_rounded,
              iconBg: const Color(0xFF0D9488),
              title: 'المصحف الشريف للقراءة',
              tag: 'القراءة والتدبر',
              tagColor: const Color(0xFF0D9488),
              tagBg: const Color(0xFFE0F2F1),
              description:
                  'تصفح سور القرآن الكريم الـ 114 مع معرفة تفاصيل كل سورة (مكية أم مدنية، وعدد آياتها). انقر على السورة لقراءة آياتها كاملة بخط قرآني واضح وأرقام آيات أنيقة دون الحاجة لإنترنت.',
              tips: [
                'فهرس كامل يوضح نوع السورة وعدد آياتها وترتيبها.',
                'عرض نص الآيات بخط عثماني وتنسيق مريح للعين.',
                'شريط بحث سريع للوصول المباشر لأي سورة.',
              ],
            ),

            const SizedBox(height: 14),

            // Guide 3: Quran Audio
            _buildGuideCard(
              stepNumber: '03',
              icon: Icons.headphones_rounded,
              iconBg: const Color(0xFF5856D6),
              title: 'القرآن الصوتي والاستماع',
              tag: 'التلاوة والاستماع',
              tagColor: const Color(0xFF5856D6),
              tagBg: const Color(0xFFEDE7F6),
              description:
                  'استمع إلى تلاوات عطرة وخاشعة للقرآن الكريم كاملاً بصوت فضيلة الشيخ مشاري بن راشد العفاسي. يمكنك البحث عن أي سورة بالاسم والبدء بالاستماع فورًا.',
              tips: [
                'تلاوة الشيخ مشاري بن راشد العفاسي برواية حفص عن عاصم.',
                'استماع نقي ومستقر لجميع سور القرآن الكريم.',
              ],
            ),

            const SizedBox(height: 14),

            // Guide 4: Audio Controls
            _buildGuideCard(
              stepNumber: '04',
              icon: Icons.play_circle_filled_rounded,
              iconBg: const Color(0xFF007AFF),
              title: 'أدوات التحكم بالتلاوة',
              tag: 'التحكم الصوتي',
              tagColor: const Color(0xFF007AFF),
              tagBg: const Color(0xFFE3F2FD),
              description:
                  'تحكّم كامل في المشغّل الصوتي: تشغيل وإيقاف، تقديم 10 ثوانٍ أو تأخير 10 ثوانٍ للتدبر، والتنقل السلس بين السور السابقة والتالية عبر أزرار التحكم المريحة.',
              tips: [
                'زر التقديم والتأخير بمقدار 10 ثوانٍ لتكرار الآيات والتدبر.',
                'الانتقال السلس للسورة التالية والسابقة بضغطة زر.',
              ],
            ),

            const SizedBox(height: 14),

            // Guide 5: Smart Reminders
            _buildGuideCard(
              stepNumber: '05',
              icon: Icons.notifications_active_rounded,
              iconBg: const Color(0xFFFF9500),
              title: 'تذكيرات القرآن الكريم الذكية',
              tag: 'التذكيرات المحلية',
              tagColor: const Color(0xFFFF9500),
              tagBg: const Color(0xFFFFF3E0),
              description:
                  'نظام إشعارات محلي ذكي يعمل بدون اتصال بالإنترنت. يتابع فترات غيابك عن التطبيق ويرسل لك تذكيرات لطيفة ومؤثرة للعودة لوردك القرآني وفق الفترة التي تختارها وباسمك الشخصي.',
              tips: [
                'يعمل محليًا على جهازك 100% دون إنترنت أو سحابة.',
                'يتوقف تلقائيًا أثناء استخدامك للتطبيق ولا يزعجك أبدًا.',
                'يستخدم اسمك في رسائل ودية لتشجيعك على القراءة.',
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard({
    required String stepNumber,
    required IconData icon,
    required Color iconBg,
    required String title,
    required String tag,
    required Color tagColor,
    required Color tagBg,
    required String description,
    required List<String> tips,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor, width: 0.8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: tagBg,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: tagColor,
                          fontFamily: AppStrings.fontCairo,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppStrings.fontCairo,
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                stepNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  fontFamily: AppStrings.fontCairo,
                  color: Color(0xFFD1D1D6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: _dividerColor),
          const SizedBox(height: 10),

          // Main Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.55,
              color: Color(0xFF48484A),
              fontFamily: AppStrings.fontCairo,
            ),
          ),

          const SizedBox(height: 10),

          // Bullet Tips Box
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: tips.map((tip) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, left: 8),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: iconBg,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 11.5,
                            height: 1.4,
                            color: Color(0xFF3A3A3C),
                            fontFamily: AppStrings.fontCairo,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
