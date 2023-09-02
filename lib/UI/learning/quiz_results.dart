import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/learning/quiz.dart';
import 'package:math/generated/l10n.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../Model/TopicModel.dart';

class QuizResults extends StatefulWidget {
  late TopicModel topic;
  late double percent;

  @override
  State<QuizResults> createState() => _QuizResults();

  QuizResults({Key? key, required this.topic, required this.percent})
      : super(key: key);
}

class _QuizResults extends State<QuizResults> {
  late TopicModel topic;
  late double percent;
  late User? user;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String stringPercent = " ";

  @override
  void initState() {
    topic = widget.topic;
    percent = widget.percent;
    user = FirebaseAuth.instance.currentUser;
    completedTopics(topic.id);
    super.initState();
  }

  Future<void> completedTopics(String topicId) async {
    db
        .collection("TopicQuizCompleted")
        .add({"user": user!.uid, "topic": topicId});
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
                                            topic: topic,
                                          )));
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
