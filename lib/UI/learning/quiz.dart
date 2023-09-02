import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math/Model/QuizModel.dart';
import 'package:math/Model/TopicModel.dart';
import 'package:math/UI/learning/quiz_results.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:math/generated/l10n.dart';

class Quiz extends StatefulWidget {
  late TopicModel topic;

  @override
  State<Quiz> createState() => _Quiz();

  Quiz({Key? key, required this.topic}) : super(key: key);
}

class _Quiz extends State<Quiz> {
  late User? user;
  late TopicModel topic;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final responseController = TextEditingController();
  bool flag = true;
  late int chosenVal = 0;
  late String chosenTile = "";
  late int totalQuizzes = 0;
  late int completedQuizzes = 0;
  late int countCorrect = 0;
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
    topic = widget.topic;
    user = FirebaseAuth.instance.currentUser;
    initQuizes();
    super.initState();
  }

  initQuizes() async {
    await db
        .collection("Quiz")
        .where("topicId", isEqualTo: topic.id)
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
      totalQuizzes = quizList.length;
    }, onError: (e) => print("Error fetching quizzes by topic"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
    solutionList.shuffle();
    return SingleChildScrollView(
        child: Column(
      children: [
        //TO DO: add question progress bar if time
        Text(quizList[index].content),
        Math.tex(quizList[index].equation, mathStyle: MathStyle.display),
        Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                if (quizList[index].img != "None")
                  CachedNetworkImage(
                    imageUrl: quizList[index].img,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                  )
              ],
            )
            // Image.network(quizList[index].img),
            ),
        answerView(),
        Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [flag ? answerCheck() : goToNextQuestion()],
            ))
      ],
    ));
  }
  Column answerView() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      answerRowTop(),
      answerRowBottom()
    ]);
  }

  Row answerRowBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        answerCell(() {
          if (tapped != "c") {
            a = Colors.indigo.shade300;
            b = Colors.indigo.shade300;
            c = Colors.indigo;
            d = Colors.indigo.shade300;
          }
          tapped = "c";
          setState(() {});
        },"C: "),
        answerCell(() {
          if (tapped != "d") {
            a = Colors.indigo.shade300;
            b = Colors.indigo.shade300;
            c = Colors.indigo.shade300;
            d = Colors.indigo;
          }
          tapped = "d";
          setState(() {});
        }, "D: ")
      ],
    );
  }



  Row answerRowTop() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        answerCell( () {
          if (tapped != "a") {
            a = Colors.indigo;
            b = Colors.indigo.shade300;
            c = Colors.indigo.shade300;
            d = Colors.indigo.shade300;
          }
          tapped = "a";
          setState(() {});
        }, "A: "),
        answerCell( () {
          if (tapped != "b") {
            a = Colors.indigo.shade300;
            b = Colors.indigo;
            c = Colors.indigo.shade300;
            d = Colors.indigo.shade300;
          }
          tapped = "b";
          setState(() {});
        }, "B: ")
      ],
    );
  }
  ElevatedButton goToNextQuestion() {
    return ElevatedButton(
        onPressed: () {
          if (index + 1 < totalQuizzes) {
            flag = true;
            a = Colors.indigo.shade300;
            b = Colors.indigo.shade300;
            c = Colors.indigo.shade300;
            d = Colors.indigo.shade300;
            tapped = "";
            index += 1;
            setState(() {});
          } else {
            var percent = 100 * (countCorrect / totalQuizzes);
            Navigator.of(context).pop();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        QuizResults(topic: topic, percent: percent)));
          }
        },
        child: Text(S.of(context).next));
  }
  Container answerCell(function, btnText) {
    return Container(
      padding:
      EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      margin: const EdgeInsets.only(right: 5),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(c),
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.3, 50)),
        ),
        onPressed: function,
        child: Row(
          children: [ Text(btnText), Text(solutionList[2])],
        ),
      ),
    );
  }
  ElevatedButton answerCheck() {
    return ElevatedButton(
        onPressed: () {
          flag = false;
          switch (tapped) {
            case "a":
              chosenVal = 0;
              break;
            case "b":
              chosenVal = 1;
              break;
            case "c":
              chosenVal = 2;
              break;
            case "d":
              chosenVal = 3;
              break;
          }
          String correct = "";
          if (solutionList[chosenVal] == quizList[index].result) {
            countCorrect += 1;
            switchButton(tapped, Colors.lime);
          } else {
            switchButton(tapped,Colors.pink.shade900 );
            for (var i in solutionList) {
              if (i == quizList[index].result) {
                correct = i;
              }
            }
          }
          setState(() {});
        },
        child: const Text("Submit answer"));
  }
  switchButton(tapped, color){
    switch (tapped) {
      case "a":
        a = color;
        break;
      case "b":
        b = color;
        break;
      case "c":
        c = color;
        break;
      case "d":
        d = color;
        break;
    }
  }
}
