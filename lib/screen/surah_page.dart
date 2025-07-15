import 'package:flutter/material.dart';
import '../services/quran_service.dart';
import '../models/ayah.dart';

class SurahPage extends StatelessWidget {
  final int num;
  final String title;
  const SurahPage({super.key, required this.num, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontFamily: 'Rakkas')),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: FutureBuilder<List<Ayah>>(
              future: QuranService.getSurah(num),
              builder: (ctx, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // ❶ حوِّل كل الآيات إلى TextSpan متصل
                final List<InlineSpan> spans = [];
                for (final a in snap.data!) {
                  spans.add(
                    TextSpan(
                      text: '${a.text.trim()} ',
                      style: const TextStyle(fontSize: 24, fontFamily: 'Amiri', height: 1.8,color: Colors.black),
                    ),
                  );
                  spans.add(
                    TextSpan(
                      text: '﴿${a.ayah}﴾ ',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Scheherazade',
                        color: Colors.green.shade800,
                      ),
                    ),
                  );
                }

                return Directionality( // ❷ نضمن اتجاه RTL
                  textDirection: TextDirection.rtl,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: RichText(
                      text: TextSpan(children: spans),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
