import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Safer extends StatefulWidget {
  const Safer({super.key});

  @override
  State<Safer> createState() => _SaferState();
}

class _SaferState extends State<Safer> {
  int textFont = 20;
  int currentReadCount = 0;
  int totalReadCount = 0;
  List<String> thekr = [
    // 1. دعاء الركوب
    "بِسْمِ اللَّهِ",
    "الحمدُ للهِ، سبحانَ الَّذي سخَّرَ لنا هذا وما كنَّا لهُ مقرنينَ، وإنَّا إلى ربِّنا لمنقلبونَ",

    // 2. دعاء السفر الكامل
    "اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا البِرَّ وَالتَّقْوَى، وَمِنَ العَمَلِ مَا تَرْضَى، اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا، وَاطْوِ عَنَّا بُعْدَهُ، اللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ، وَالخَلِيفَةُ فِي الأَهْلِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ وَعْثَاءِ السَّفَرِ، وَكَآبَةِ المَنْظَرِ، وَسُوءِ المُنْقَلَبِ فِي المَالِ وَالأَهْلِ وَالْوَلَدِ",

    // 3. تكبير وتهليل
    "الله أكبر، الله أكبر، الله أكبر، سبحانك إني ظلمت نفسي فاغفر لي فإنه لا يغفر الذنوب إلا أنت",

    // 4. دعاء للحفظ في الطريق
    "اللَّهُمَّ احْفَظْنَا وَوَفِّقْنَا وَسَهِّلْ طَرِيقَنَا، وَارْزُقْنَا سَفَرًا سَالِمًا وَعَوْدًا حَمِيدًا، وَاكْفِنَا شَرَّ الطَّرِيقِ وَرُفَقَاءِ السُّوءِ وَالْحَوَادِثِ، وَاجْعَلْ مَلَائِكَتَكَ تَحُفُّنَا",
  ];

  List<int> num = [
    1, // بسم الله
    1, // سبحان الذي سخر
    1, // دعاء السفر الكامل
    1, // تكبير وتسبيح
    1  // دعاء الحفظ والتوفيق
  ];

  @override
  void initState() {
    super.initState();
    _loadTotalReadCount();
  }

  Future<void> _loadTotalReadCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      totalReadCount = prefs.getInt('total_read') ?? 0;
    });
  }

  Future<void> _updateTotalReadCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    totalReadCount += currentReadCount;
    await prefs.setInt('total_read', totalReadCount);
  }

  void _onFinish() {
    _updateTotalReadCount();
    setState(() {
      thekr.clear();
      num.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool finished = thekr.isEmpty;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,


        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (textFont > 19) textFont -= 2;
                  });
                },
                child: SizedBox(
                  width: 40,
                  child: Text("ض", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,fontFamily: 'Rakkas',), textAlign: TextAlign.center),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (textFont != 40) textFont += 2;
                  });
                },
                child: SizedBox(
                  width: 40,
                  child: Text("ض", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27,fontFamily: 'Rakkas',), textAlign: TextAlign.center),
                ),
              ),
            ],
          )
        ],
        toolbarHeight: 100,
        title: Text("دعاء السفر", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rakkas',
          fontSize: 30,)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/5.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: thekr.length,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          if (num[i] > 0) {
                            num[i] -= 1;
                            currentReadCount += 1;
                          }
                          if (num[i] == 0) {
                            thekr.removeAt(i);
                            num.removeAt(i);
                            if (thekr.isEmpty) _onFinish();
                          }
                        });
                      },
                      child: Card(
                        color: Color(0xFFFDF6E3),
                        margin: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(11),
                              child: Text(thekr[i], style: TextStyle(fontWeight: FontWeight.bold, fontSize: textFont.toDouble()), textAlign: TextAlign.center),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.orange[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  if (num[i] > 0) {
                                    num[i] -= 1;
                                    currentReadCount += 1;
                                  }
                                  if (num[i] == 0) {
                                    thekr.removeAt(i);
                                    num.removeAt(i);
                                    if (thekr.isEmpty) _onFinish();
                                  }
                                });
                              },
                              child: Text(num[i].toString()),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (finished)
                Container(
                  margin: EdgeInsets.only(bottom: 300),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text("عدد الأذكار الحالية", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                            Text("$currentReadCount", style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.orange[400])),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Text("المجموع للأذكار", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                            Text("$totalReadCount", style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold,color: Colors.orange[400])),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[400],
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          ),
                          child: Text("العودة", style: TextStyle(fontSize: 18, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
