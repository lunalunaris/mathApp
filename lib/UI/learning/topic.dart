import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:math/UI/learning/practice.dart';
import 'package:math/UI/learning/quiz.dart';
import 'package:math/UI/learning/theory.dart';
import 'dart:developer' as developer;

import '../../Model/TopicModel.dart';
import '../settings/settings.dart';

class Topic extends StatefulWidget {
  late TopicModel topic;

  @override
  State<Topic> createState() => _Topic();

  Topic({Key? key, required this.topic}) : super(key: key);
}

class _Topic extends State<Topic> {
  late User? user;
  late TopicModel topic;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    topic = widget.topic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Learning"),
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
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                child: Column(
                  children: [
                    GestureDetector(
                    onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => Theory(topic: topic,)));
              },
                child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: 300,
                    height: 150,
                    decoration: const BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage("assets/theory.png"))),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade900.withOpacity(0.7),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Text(
                        "Theory",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )),
              ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Practice(topic: topic,)));
                        ;
                      },
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          width: 300,
                          height: 150,
                          decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/theory.png"))),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade900.withOpacity(0.7),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Text(
                              "Practice",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Quiz(topic: topic,)));
                      },
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          width: 300,
                          height: 150,
                          decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/theory.png"))),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade900.withOpacity(0.7),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Text(
                              "Quiz",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    )
                  ],
                ),
              ),
            )),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.teal,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: "Learn",
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.lime,
                icon: Icon(Icons.games),
                label: "Game",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Setup",
              ),
            ],
            onTap: (option) {
              developer.log(option.toString());
              switch (option) {
                case 0:
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Learning()));
                  break;
              // case 2:
              //   Navigator.of(context).pop();
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) =>
              //               Game(user: user)));
              //   break;
                case 2:
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserSettings()));
                  break;
              }
            },
            selectedItemColor: Colors.pink));
  }

}