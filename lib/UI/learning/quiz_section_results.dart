import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/learning/quiz_section.dart';
import 'package:math/generated/l10n.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';

import '../../Database/sqliteHandler.dart';
import '../../Model/QuizModel.dart';

class QuizSectionResults extends StatefulWidget {
  late SectionModel section;
  late double percent;
  late List<QuizModel> quizList;

  @override
  State<QuizSectionResults> createState() => _QuizSectionResults();

  QuizSectionResults(
      {Key? key,
      required this.section,
      required this.percent,
      required this.quizList})
      : super(key: key);
}

class _QuizSectionResults extends State<QuizSectionResults> {
  late SectionModel section;
  late double percent;
  late User? user;
  late List<QuizModel> quizList;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String stringPercent = " ";
  bool downloaded = false;
  bool connected = true;
  SqliteHandler sql = SqliteHandler();

  @override
  void initState() {
    section = widget.section;
    percent = widget.percent;
    quizList = widget.quizList;
    user = FirebaseAuth.instance.currentUser;
    //
    initConnect();
    if (connected) {
      checkIfTopicCompleted();
    }
    isDownloaded();
    super.initState();
  }

  checkIfTopicCompleted() async {
    try {
      var document = await FirebaseFirestore.instance
          .collection("SectionQuizCompleted")
          .doc(section.id)
          .get();
      if (percent == 100.0 && !document.exists) {
        await completedSections(section.id);
      }
    } catch (e) {
      throw e;
    }
  }

  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }

  isDownloaded() async {
    downloaded = await sql.isQuizSaved(section.id);
    setState(() {});
  }

  downloadQuizzes() async {
    if (downloaded) {
      try {
        for (var quiz in quizList) {
          await sql.deleteById(quiz.id, "Quiz");
        }
        bool topics = await sql.areTopicsInSection(section.id);
        if (!topics) {
          await sql.deleteById(section.id, "Section");
        }
        var temp = await sql.isSectionQuizSaved(section.id);
        setState(() {
          downloaded =temp;
        });
      } on DatabaseException catch (e) {
        print(e.toString());
      }
    } else if (connected) {
      try {
        bool isSection = await sql.isSectionSaved(section.id);
        if (!isSection) {
          await sql.insertSection(section);
        }
        for (var quiz in quizList) {
          await sql.insertQuizModel(quiz);
        }
        var temp = await sql.isSectionQuizSaved(section.id);
        setState(() {
          downloaded =temp;
        });
      } on DatabaseException catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> completedSections(String sectionId) async {
    db
        .collection("SectionQuizCompleted")
        .add({"user": user!.uid, "section": sectionId});
  }

  @override
  Widget build(BuildContext context) {
    stringPercent = "$percent%";
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () {
                            downloadQuizzes();
                            setState(() {});
                          },
                          label: downloaded == true
                              ? Text(S.of(context).downloaded)
                              : Text(S.of(context).download),
                          backgroundColor: downloaded == true
                              ? Colors.pink
                              : Colors.blueGrey,
                          icon: const Icon(Icons.download_rounded),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: percent / 100,
                        center: Text(
                          stringPercent,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: Colors.indigo.shade100,
                        // progressColor: Colors.pink,
                        linearGradient: const LinearGradient(
                          colors: [Colors.cyan, Colors.pink],
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(15),
                        child: Text(S.of(context).questionsCorrect)),
                    Container(
                        margin: const EdgeInsets.all(15),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => QuizSection(
                                            section: section,
                                          )));
                            },
                            child: Text(S.of(context).tryAgain))),
                    Container(
                        margin: const EdgeInsets.all(15),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Quit")))
                  ],
                ))));
  }
}
