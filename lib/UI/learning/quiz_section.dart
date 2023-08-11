import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math/Model/QuizModel.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/Model/TopicModel.dart';
import 'package:math/UI/learning/quiz_results.dart';
import 'dart:math';

import 'package:math/UI/learning/quiz_section_results.dart';

class QuizSection extends StatefulWidget {
  late SectionModel section;

  @override
  State<QuizSection> createState() => _QuizSection();

  QuizSection({Key? key, required this.section}) : super(key: key);
}

class _QuizSection extends State<QuizSection> {
  late User? user;
  late SectionModel section;

  FirebaseFirestore db = FirebaseFirestore.instance;
  final responseController = TextEditingController();
  bool flag = true;
  late int chosenVal=0;
  late String chosenTile="";
  late int totalQuizes = 0;
  late int completedQuizes = 0;
  late int countCorect=0;
  late int index = 0;
  late Color a = Colors.indigo.shade300;
  late Color b = Colors.indigo.shade300;
  late Color c = Colors.indigo.shade300;
  late Color d = Colors.indigo.shade300;
  late String tapped = "";

  late List<String> solutionList = [];
  List<QuizModel> quizList = [
    QuizModel(
        id: "null",
        topicId: "null",
        section: "null",
        content: "Loading...",
        equation: "Loading...",
        img:
        "https://firebasestorage.googleapis.com/v0/b/math-16d0d.appspot.com/o/theory.png?alt=media&token=d3cfd46c-c247-4065-803a-00f621328968",
        result: "result",
        solutions: "1,2,3,4")
  ];

  @override
  void initState() {
    section = widget.section;
    user = FirebaseAuth.instance.currentUser;
    initQuizes();
    super.initState();
  }

  initQuizes() async {
    await db
        .collection("Quiz")
        .where("section", isEqualTo: section.id)
        .get()
        .then((querySnapshot) async {
      print("sections by level completed");
      quizList = [];
      for (var docSnapshot in querySnapshot.docs) {
        quizList.add(QuizModel(
            id: docSnapshot.id,
            topicId: docSnapshot["topicId"],
            section: docSnapshot["section"],
            content: docSnapshot["content"],
            equation: docSnapshot["equation"],
            img: docSnapshot["img"],
            result: docSnapshot["result"],
            solutions: docSnapshot["solutions"]));
      }
      totalQuizes = quizList.length;
    }, onError: (e) => print("Error fetching sections by level"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var responseTxt = responseController.text;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Quiz"),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.pink.shade500.withOpacity(0.8),
                  Colors.teal.shade100.withOpacity(0.8),
                ],
              )),
          child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(0.8),
              ),
              child: Column(children: [buildSingleChildScrollView()]))),
    );
  }

  SingleChildScrollView buildSingleChildScrollView() {
    solutionList = quizList[index].solutions.split(",");
    // solutionList.shuffle();

    return SingleChildScrollView(
        child: Column(
          children: [
            //add question progress bar if time
            Text(quizList[index].content),
            Math.tex(quizList[index].equation, mathStyle: MathStyle.display, textScaleFactor: 1.5,),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 10),
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Image.network(quizList[index].img),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                    margin: EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(a),
                          fixedSize: MaterialStateProperty.all(
                              Size(MediaQuery.of(context).size.width * 0.3, 50))),
                      onPressed: () {
                        if (tapped != "a") {
                          a = Colors.indigo;
                          b = Colors.indigo.shade300;
                          c = Colors.indigo.shade300;
                          d = Colors.indigo.shade300;
                        }
                        tapped = "a";
                        setState(() {});
                      },
                      child: Row(
                        children: [Text("A: "), Text(solutionList[0])],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(b),
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.3, 50)),
                      ),
                      onPressed: () {
                        if (tapped != "b") {
                          a = Colors.indigo.shade300;
                          b = Colors.indigo;
                          c = Colors.indigo.shade300;
                          d = Colors.indigo.shade300;
                        }
                        tapped = "b";
                        setState(() {});
                      },
                      child: Row(
                        children: [Text("B: "), Text(solutionList[1])],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                    margin: EdgeInsets.only(right: 5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(c),
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.3, 50)),
                      ),
                      onPressed: () {
                        if (tapped != "c") {
                          a = Colors.indigo.shade300;
                          b = Colors.indigo.shade300;
                          c = Colors.indigo;
                          d = Colors.indigo.shade300;
                        }
                        tapped = "c";
                        setState(() {});
                      },
                      child: Row(
                        children: [Text("C: "), Text(solutionList[2])],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.3, 50)),
                        backgroundColor: MaterialStateProperty.all(d),
                      ),
                      onPressed: () {
                        if (tapped != "d") {
                          a = Colors.indigo.shade300;
                          b = Colors.indigo.shade300;
                          c = Colors.indigo.shade300;
                          d = Colors.indigo;
                        }
                        tapped = "d";
                        setState(() {});
                      },
                      child: Row(
                        children: [const Text("D: "), Text(solutionList[3])],
                      ),
                    ),
                  ),
                ],
              )
            ]),
            Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    flag? buildSubmitButton():buildNextButton()
                  ],
                ))
          ],
        ));
  }
  ElevatedButton buildNextButton(){
    return ElevatedButton(onPressed: ()
    {

      if (index + 1 < totalQuizes){
        flag=true;
        a = Colors.indigo.shade300;
        b = Colors.indigo.shade300;
        c = Colors.indigo.shade300;
        d = Colors.indigo.shade300;
        tapped="";
        index+=1;
        setState(() {});
      }
      else{
        var percent=100*(countCorect/totalQuizes);
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuizSectionResults(
                    section: section, percent: percent
                )));
      }
    },
        child: Text("Next"));
  }


  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          flag = false;
          switch(tapped){
            case "a":
              chosenVal=0;
              break;
            case "b":
              chosenVal=1;
              break;
            case "c":
              chosenVal=2;
              break;
            case "d":
              chosenVal=3;
              break;
          }
          String correct="";
          if(solutionList[chosenVal]==quizList[index].result){
            countCorect+=1;
            switch(tapped){
              case "a":
                a = Colors.lime;
                break;
              case "b":
                b = Colors.lime;
                break;
              case "c":
                c = Colors.lime;
                break;
              case "d":
                d = Colors.lime;
                break;
            }
          }
          else {
            switch (tapped) {
              case "a":
                a = Colors.pink.shade900;
                break;
              case "b":
                b = Colors.pink.shade900;
                break;
              case "c":
                c = Colors.pink.shade900;
                break;
              case "d":
                d = Colors.pink.shade900;
                break;
            }
            for (var i in solutionList) {
              if (i == quizList[index].result) {
                correct = i;
              }
            }
            var ind = solutionList.indexOf(correct);
            switch (ind) {
              case 0:
                a = Colors.lime;
                break;
              case 1:
                b = Colors.lime;
                break;
              case 2:
                c = Colors.lime;
                break;
              case 3:
                d = Colors.lime;
                break;
            }
          }
          setState(() {});



        },
        child: Text("Submit answer"));
  }
}
//text
//math render
//image
//math input
//camera input
