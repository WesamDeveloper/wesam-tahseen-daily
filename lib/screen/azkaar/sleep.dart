import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sleep extends StatefulWidget {
  const Sleep({super.key});

  @override
  State<Sleep> createState() => _SleepState();
}

class _SleepState extends State<Sleep> {
  int textFont = 20;
  int currentReadCount = 0;
  int totalReadCount = 0;
  List thekr = [
    "بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ",
    "اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ",
    "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
    "اللَّهُمَّ أَنْتَ خَلَقْتَ نَفْسِي وَأَنْتَ تَوَفَّاهَا، لَكَ مَمَاتُهَا وَمَحْيَاهَا، إِنْ أَحْيَيْتَهَا فَاحْفَظْهَا، وَإِنْ أَمَتَّهَا فَاغْفِرْ لَهَا، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَافِيَةَ",
    "اللَّهُمَّ إِنِّي أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِي إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ",
    "اللَّهُمَّ رَبَّ السَّمَاوَاتِ السَّبْعِ، وَرَبَّ الْعَرْشِ الْعَظِيمِ، رَبَّنَا وَرَبَّ كُلِّ شَيْءٍ، فَالِقَ الْحَبِّ وَالنَّوَى، وَمُنَزِّلَ التَّوْرَاةِ وَالْإِنْجِيلِ وَالْفُرْقَانِ، أَعُوذُ بِكَ مِنْ شَرِّ كُلِّ شَيْءٍ أَنْتَ آخِذٌ بِنَاصِيَتِهِ، اللَّهُمَّ أَنْتَ الْأَوَّلُ فَلَيْسَ قَبْلَكَ شَيْءٌ، وَأَنْتَ الْآخِرُ فَلَيْسَ بَعْدَكَ شَيْءٌ، وَأَنْتَ الظَّاهِرُ فَلَيْسَ فَوْقَكَ شَيْءٌ، وَأَنْتَ الْبَاطِنُ فَلَيْسَ دُونَكَ شَيْءٌ، اقْضِ عَنَّا الدَّيْنَ وَأَغْنِنَا مِنَ الْفَقْرِ",
    "سُبْحَانَ اللَّهِ",
    "الْحَمْدُ لِلَّهِ",
    "اللَّهُ أَكْبَرُ",

    "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ ",

    // سورة الإخلاص
    "قُلْ هُوَ اللَّهُ أَحَدٌ "
    "اللَّهُ الصَّمَدُ "
    "لَمْ يَلِدْ وَلَمْ يُولَدْ "
    "وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ ",

    // سورة الفلق
    "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ "
    "مِن شَرِّ مَا خَلَقَ "
    "وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ "
    "وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ "
    "وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ ",

    // سورة الناس
    "قُلْ أَعُوذُ بِرَبِّ النَّاسِ "
    "مَلِكِ النَّاسِ "
    "إِلَٰهِ النَّاسِ "
    "مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ "
    "الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ "
    "مِنَ الْجِنَّةِ وَالنَّاسِ ",

    "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ غَضَبِهِ وَعِقَابِهِ وَشَرِّ عِبَادِهِ، وَمِنْ هَمَزَاتِ الشَّيَاطِينِ، وَأَنْ يَحْضُرُونِ",
  ];


// قائمة التكرار المناسبة:
  List num = [
    1, // باسمك ربي...
    1, // قني عذابك...
    1, // باسمك اللهم...
    1, // خلقت نفسي...
    1, // أسلمت نفسي إليك...
    1, // رب السماوات...
    33, // سبحان الله
    33, // الحمد لله
    34, // الله أكبر
    1, // آية الكرسي
    3, // الإخلاص
    3, // الفلق
    3, // الناس
    1  // أعوذ بكلمات الله...
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
        title: Text("أذكار النوم", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rakkas',
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
