import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/UI/learning/quiz.dart';
import 'package:math/generated/l10n.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sqflite/sqflite.dart';

import '../../Database/sqliteHandler.dart';
import '../../Model/QuizModel.dart';
import '../../Model/TopicModel.dart';

class QuizResults extends StatefulWidget {
  late TopicModel topic;
  late SectionModel section;
  late double percent;
  late List<QuizModel> quizList;

  @override
  State<QuizResults> createState() => _QuizResults();

  QuizResults(
      {Key? key,
      required this.topic,
      required this.percent,
      required this.section,
      required this.quizList})
      : super(key: key);
}

class _QuizResults extends State<QuizResults> {
  late TopicModel topic;
  late SectionModel section;
  late double percent;
  late User? user;
  late List<QuizModel> quizList;
  bool downloaded = false;
  bool connected = true;
  SqliteHandler sql = SqliteHandler();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String stringPercent = " ";

  @override
  void initState() {
    topic = widget.topic;
    percent = widget.percent;
    section = widget.section;
    quizList = widget.quizList;
    user = FirebaseAuth.instance.currentUser;
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
          .collection("TopicQuizCompleted")
          .doc(topic.id)
          .get();
      if (percent == 100.0 && !document.exists) {
        await completedTopics();
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

  Future<void> completedTopics() async {
    db
        .collection("TopicQuizCompleted")
        .add({"user": user!.uid, "topic": topic.id});
  }

  isDownloaded() async {
    downloaded = await sql.isQuizSaved(topic.id);
    setState(() {});
  }

  downloadQuizzes() async {
    if (downloaded) {
      try {
        for (var quiz in quizList) {
          await sql.deleteById(quiz.id, "Quiz");
        }
        bool practice = await sql.arePracticesInTopic(topic.id);
        bool quiz = await sql.isQuizSaved(topic.id);
        bool theory = await sql.isTheorySaved(topic.id);
        if (!practice && !quiz && !theory) {
          await sql.deleteById(topic.id, "Topic");
          bool topics = await sql.areTopicsInSection(topic.sectionId);
          bool sectionQuiz = await sql.isSectionQuizSaved(topic.sectionId);
          if (!topics && !sectionQuiz) {
            await sql.deleteById(topic.sectionId, "Section");
          }
        }
        var temp = await sql.isQuizSaved(topic.id);
        setState(() {
          downloaded = temp;
        });
      } on DatabaseException catch (e) {
        print(e.toString());
      }
    } else if (connected) {
      try {
        bool isSection = await sql.isSectionSaved(topic.sectionId);
        if (!isSection) {
          await sql.insertSection(section);
          bool isTopic = await sql.isTopicSaved(topic.id);
          if (!isTopic) {
            await sql.insertTopic(topic);
          }
        }
        for (var quiz in quizList) {
          await sql.insertQuizModel(quiz);
        }
        var temp = await sql.isQuizSaved(topic.id);
        setState(() {
          downloaded = temp;
        });
      } on DatabaseException catch (e) {
        print(e.toString());
      }
    }
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
                                      builder: (context) => Quiz(
                                          topic: topic, section: section)));
                            },
                            child: Text(S.of(context).tryAgain))),
                    Container(
                        margin: const EdgeInsets.all(15),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(S.of(context).quit)))
                  ],
                ))));
  }
}
