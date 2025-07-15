import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alham extends StatefulWidget {
  const Alham({super.key});

  @override
  State<Alham> createState() => _AlhamState();
}

class _AlhamState extends State<Alham> {
  int textFont = 20;
  int currentReadCount = 0;
  int totalReadCount = 0;
  List<String> thekr = [
    "لا إله إلا الله العظيم الحليم، لا إله إلا الله رب العرش العظيم، لا إله إلا الله رب السماوات ورب الأرض ورب العرش الكريم",

    "حسبنا الله ونعم الوكيل، نعم المولى ونعم النصير",

    "اللهم إني أعوذ بك من الهم والحزن، والعجز والكسل، والجبن والبخل، وضلع الدين وغلبة الرجال",

    "يا حي يا قيوم برحمتك أستغيث، أصلح لي شأني كله ولا تكلني إلى نفسي طرفة عين",

    "لا حول ولا قوة إلا بالله العلي العظيم",

    "اللهم رحمتك أرجو فلا تكلني إلى نفسي طرفة عين وأصلح لي شأني كله",

    "أعوذ بكلمات الله التامات من شر ما خلق",

    "اللهم إني عبدك ابن عبدك ابن أمتك، ناصيتي بيدك، ماضٍ في حكمك، عدل في قضاؤك، أسألك بكل اسم هو لك سميت به نفسك، أو أنزلته في كتابك، أو علمته أحداً من خلقك، أو استأثرت به في علم الغيب عندك، أن تجعل القرآن ربيع قلبي، ونور صدري، وجلاء حزني، وذهاب همي",

    "ربّ إني مسني الضر وأنت أرحم الراحمين"
  ];

  List<int> num = [
    1,
    1,
    1,
    1,
    3,
    3,
    1,
    1,
    1
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
        title: Text("أذكار الكرب والهم", style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Rakkas',
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
