import 'package:flutter/material.dart';
import '../data/quran_surahs.dart';
import 'surah_page.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القرآن الكريم', style: TextStyle(fontFamily: 'Rakkas')),
        centerTitle: true,

      ),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (ctx, i) {
          final surah = surahs[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange[300],
                child: Text(surah["index"]!),
              ),
              title: Text(
                surah["name"]!,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurahPage(
                      num: int.parse(surah["index"]!),
                      title: surah["name"]!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}