import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:m_pigplan/record/matingrecord.dart';
import 'package:m_pigplan/record/pregnancy_accident_record.dart';

class QuickPage extends StatefulWidget {
  const QuickPage({Key? key}) : super(key: key);
  @override
  _QuickPage createState() => _QuickPage();
}

class _QuickPage extends State<QuickPage> {

  @override
  void initState() {
    super.initState();
  }

 // final JavascriptRuntime jsRuntime = getJavascriptRuntime();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PigPlan'),
        centerTitle: true,
      ),
      body:
      GridView.count(
          padding: const EdgeInsets.all(8),
          crossAxisCount: 3,
         // childAspectRatio: 1/3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          shrinkWrap: true,

          children: [
            Container(
              child: InkWell(
                child: const Text('교배기록'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const MatingRecord())
                  );
                },
              ), //const Text("He'd have you all unravel at the"),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[100],
            ),
            Container(
              child: InkWell(
                child: const Text('임신 사고기록'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const PregnancyAccidentRecord())
                  );
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[200],
            ),
            Container(
              child: InkWell(
                child: const Text('분만기록'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const MatingRecord())
                  );
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.lightBlueAccent[400],
            ),
            Container(
              child: InkWell(
                child: const Text('이유기록'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const MatingRecord())
                  );
                },
              ),
              padding: const EdgeInsets.all(8),
              color: Colors.blueAccent[400],
            ),
          ],

          /*children: List.generate(18, (index) {
            Container(
              color: Colors.lightBlueAccent,
            );*/



      ),


/*
      Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            RaisedButton(
              textColor: Colors.blue,
              child: const Text('교배기록'),
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const MatingRecord())
                );
              },
            ),
            RaisedButton(
              textColor: Colors.blue,
              child: const Text('임신 사고기록'),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PregnancyAccidentRecord())
                );
              },
            ),
            RaisedButton(
              textColor: Colors.blue,
              child: const Text('분만기록'),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PregnancyAccidentRecord())
                );

              },
            ),
            RaisedButton(
              textColor: Colors.blue,
              child: const Text('이유기록'),
              onPressed: (){

                //final jsResult = jsRuntime.evaluate();




                Navigator.push(context, MaterialPageRoute(builder: (context) => const PregnancyAccidentRecord())


                );

              },
            ),
          ],
        ),
      ),
      */


    );

  }

}
/*

Future<void> addFromJs(JavascriptRuntime jsRuntime) async {

  String blocJs = await rootBundle.loadString("assets/crownix-viewer.min.js");

  final jsResult = jsRuntime.evaluate(blocJs + "");
}*/
