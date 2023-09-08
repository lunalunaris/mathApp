import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:math/Model/QuizModel.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/learning/quiz_section_results.dart';

import '../../Database/sqliteHandler.dart';
import '../../generated/l10n.dart';

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
  late int chosenVal = 0;
  late String chosenTile = "";
  late int totalQuizzes = 0;
  late int countCorrect = 0;
  late int index = 0;
  bool connected = true;
  String userRole="";

  bool enabled = false;
  bool downloaded = false;
  SqliteHandler sql = SqliteHandler();
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
    initConnect();
    if (connected) {
      initQuizzes();
      initRole();
    } else {
      initFromDb();
    }
    super.initState();
  }
  Future<void> deleteQuiz() async {
    final collection = FirebaseFirestore.instance.collection('Quiz');
    collection
        .doc(quizList[index].id) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).deletedSuccessfully)))
    })
        .catchError((e) => {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).deleteFailed)))
    });
  }
  initRole() async {
    await db
        .collection("UserRole")
        .doc(user?.uid)
        .get()
        .then((querySnapshot) async {
      userRole = querySnapshot["role"];
      setState(() {});
    });
  }
  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }

  initFromDb() async {
    {
      quizList = [];
      quizList = await sql.getQuizModelsBySection(section.id);
      enabled = true;
      setState(() {});
    }
  }

  initQuizzes() async {
    await db
        .collection("Quiz")
        .where("section", isEqualTo: section.id)
        .get()
        .then((querySnapshot) async {
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
      enabled = true;
    }, onError: (e) => print("Error fetching quizzes by section"));
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
                child: Column(children: [
                  if (quizList.isNotEmpty)
                    mainQuizView()
                  else
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Text(
                              S.of(context).noQuizzesAddedForThisTopic,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                ]))));
  }

  SingleChildScrollView mainQuizView() {
    solutionList = quizList[index].solutions.split(",");
    //  solutionList.shuffle();

    return SingleChildScrollView(
        child: Column(
      children: [
        //add question progress bar if time
        Text(quizList[index].content),
        Math.tex(
          quizList[index].equation,
          mathStyle: MathStyle.display,
          textScaleFactor: 1.5,
        ),

        SizedBox(
          height: 200,
          child: Column(
            children: [
              if (quizList[index].img != "")
                CachedNetworkImage(
                  height: MediaQuery.of(context).size.height*0.25,
                  imageUrl: quizList[index].img,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                ),
              // Image.network(quizList[index].img),
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
            margin: const EdgeInsets.only(right: 5),
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
                children: [const Text("A: "), Text(solutionList[0])],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
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
                children: [const Text("B: "), Text(solutionList[1])],
              ),
            ),
          ),
        ]),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              margin: const EdgeInsets.only(right: 5),
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
                  children: [const Text("C: "), Text(solutionList[2])],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
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
        ),
        Container(
            margin: const EdgeInsets.only(top: 30),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [flag ? buildSubmitButton() : goToNextQuestion(),
                if(userRole=="admin")
                  FloatingActionButton.extended(
                    heroTag: "btn2",
                    onPressed: () {
                      if (enabled) {
                        deleteQuiz();
                        getNextQuiz();
                        setState(() {});
                      }
                    },
                    label: Text(S.of(context).delete),
                    backgroundColor: Colors.pink,
                    icon: const Icon(Icons.delete_forever_rounded),
                  ),],
            ))
      ],
    ));
  }

  Container answerCell(function, btnText, index) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      margin: const EdgeInsets.only(right: 5),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(c),
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.3, 50)),
        ),
        onPressed: function,
        child: Row(
          children: [Text(btnText), Text(solutionList[index])],
        ),
      ),
    );
  }
  getNextQuiz(){
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
              builder: (context) => QuizSectionResults(
                section: section,
                percent: percent,
                quizList: quizList,
              )));
    }
  }
  ElevatedButton goToNextQuestion() {
    return ElevatedButton(
        onPressed: () {

        },
        child: Text(S.of(context).next));
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: enabled == true && tapped != ""
                ? MaterialStateProperty.all(Colors.pink)
                : MaterialStateProperty.all(Colors.blueGrey)),
        onPressed: () {
          if (enabled && tapped != "") {
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
              switch (tapped) {
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
            } else {
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
          }
          setState(() {});
        },
        child: Text(S.of(context).submitAnswer));
  }
}
//text
//math render
//image
//math input
//camera input
// var ind = solutionList.indexOf(correct);
// switch (ind) {
//   case 0:
//     a = Colors.lime;
//     break;
//   case 1:
//     b = Colors.lime;
//     break;
//   case 2:
//     c = Colors.lime;
//     break;
//   case 3:
//     d = Colors.lime;
//     break;
// }
// Container(
//   padding:
//       EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
//   child: ElevatedButton(
//     style: ButtonStyle(
//       fixedSize: MaterialStateProperty.all(
//           Size(MediaQuery.of(context).size.width * 0.3, 50)),
//       backgroundColor: MaterialStateProperty.all(d),
//     ),
//     onPressed: () {
//       if (tapped != "d") {
//         a = Colors.indigo.shade300;
//         b = Colors.indigo.shade300;
//         c = Colors.indigo.shade300;
//         d = Colors.indigo;
//       }
//       tapped = "d";
//       setState(() {});
//     },
//     child: Row(
//       children: [const Text("D: "), Text(solutionList[3])],
//     ),
//   ),
// ),
//Container(
//   padding:
//       EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
//   margin: const EdgeInsets.only(right: 5),
//   child: ElevatedButton(
//     style: ButtonStyle(
//     backgroundColor: MaterialStateProperty.all(a),
//     fixedSize: MaterialStateProperty.all(
//         Size(MediaQuery.of(context).size.width * 0.3, 50)
//       )
//     ),
//     onPressed: () {
//       if (tapped != "a") {
//         a = Colors.indigo;
//         b = Colors.indigo.shade300;
//         c = Colors.indigo.shade300;
//         d = Colors.indigo.shade300;
//       }
//     tapped = "a";
//     setState(() {});
//     },
//     child: Row(
//       children: [
//         const Text("A: "),
//         Text(solutionList[0])
//       ],
//       ),
//   ),
// ),
//Container(
//       padding:
//         EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
//       child: ElevatedButton(
//         style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(b),
//         fixedSize: MaterialStateProperty.all(
//           Size(MediaQuery.of(context).size.width * 0.3, 50)),
//         ),
//       onPressed: () {
//         if (tapped != "b") {
//           a = Colors.indigo.shade300;
//           b = Colors.indigo;
//           c = Colors.indigo.shade300;
//           d = Colors.indigo.shade300;
//         }
//         tapped = "b";
//         setState(() {});
//       },
//       child: Row(
//         children: [
//           const Text("B: "),
//           Text(solutionList[1])],
//     ),
//   ),
// ),
