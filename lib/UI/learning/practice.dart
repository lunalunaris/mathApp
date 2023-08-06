import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/PracticeModel.dart';

class Practice extends StatefulWidget {
  const Practice({Key? key}) : super(key: key);

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  List<PracticeModel> tasks=[PracticeModel(id: "1", topicId: "1", content: "example task text 1", img: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FIsosceles_triangle&psig=AOvVaw1bRqyf4vVJ2UPMkNzMFCKn&ust=1691423243620000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCIDVpeCwyIADFQAAAAAdAAAAABAD", result: "5", solutions: ["2+3=5",'1+4=5']),
  PracticeModel(id: "2", topicId: "1", content: "some example task 2", img: "null", result: "16", solutions: ["10+6=16","5+6+5=16"]),
  PracticeModel(id: "3", topicId: "1", content: "some example 3", img: "null", result: "9", solutions: [""])];
  bool test = true;
  testView(PracticeModel practice){
    return Column(
      children: [
        Text(practice.content)
      ],
    );
  }
  
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
          title: const Text("Learning"),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center, children: const [
              Text("Practice", style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink)
              )
            ]
            )));
  }
}


