import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math/Database/sqliteHandler.dart';
import 'package:math/Model/PracticeModel.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/Model/TopicModel.dart';
import 'package:math/generated/l10n.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:sqflite/sqflite.dart';
import 'package:image/image.dart' as Imagi;

import '../../Algorithm/PhotoDecoder.dart';
class Practice extends StatefulWidget {
  late TopicModel topic;
  late SectionModel section;

  @override
  State<Practice> createState() => _Practice();

  Practice({Key? key, required this.topic, required this.section})
      : super(key: key);
}

//TODO remove button for all for admin user

class _Practice extends State<Practice> {
  late User? user;
  late TopicModel topic;
  late SectionModel section;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final responseController = TextEditingController();
  final ImagePicker imagePicker = ImagePicker();
  SqliteHandler sql = SqliteHandler();
  bool flag = true;
  bool connected = true;
  bool downloaded = false;
  bool correct = false;
  bool enabled = false;
  String userRole="";
  int index = 0;
  List<PracticeModel> practiceList = [
    PracticeModel(
        id: "none",
        topicId: "none",
        content: "Loading...",
        equation: "null",
        img:
            "https://firebasestorage.googleapis.com/v0/b/math-16d0d.appspot.com/o/theory.png?alt=media&token=d3cfd46c-c247-4065-803a-00f621328968",
        result: "null",
        resultImg:
            "https://firebasestorage.googleapis.com/v0/b/math-16d0d.appspot.com/o/theory.png?alt=media&token=d3cfd46c-c247-4065-803a-00f621328968",
        solutions: "null")
  ];
  List<String> completedPractice = [];
  String mathInput = "";

  @override
  void initState() {
    topic = widget.topic;
    section = widget.section;
    user = FirebaseAuth.instance.currentUser;
    initConnect();
    if (connected) {
      initPractice();
      initRole();
    } else {
      initFromDb();
    }
    isDownloaded();
    super.initState();
  }

  isDownloaded() async {
    downloaded = await sql.isPracticeSaved(practiceList[index].id);
    setState(() {});
  }

  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
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
  Future<void> deletePractice() async {
    PracticeModel p =practiceList[index];
    practiceList.remove(p);
    setState(() {
    });
    final collection = FirebaseFirestore.instance.collection('Practice');
    collection
        .doc(p.id) // <-- Doc ID to be deleted.
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

  initFromDb() async {
    {
      practiceList = [];
      practiceList = await sql.getPracticeModelsByTopic(topic.id);
      enabled = true;
      setState(() {});
    }
  }

  downloadPractice() async {
    if (downloaded) {
      try {
        await sql.deleteById(practiceList[index].id, "Practice");
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
        var temp = await sql.isPracticeSaved(practiceList[index].id);
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
        await sql.insertPracticeModel(practiceList[index]);
        var temp = await sql.isPracticeSaved(practiceList[index].id);
        setState(() {
          downloaded = temp;
        });
      } on DatabaseException catch (e) {
        print(e.toString());
      }
    }
  }

  Future<dynamic> initPractice() async {
    await db
        .collection("Practice")
        .where("topicId", isEqualTo: topic.id)
        .get()
        .then((querySnapshot) async {
      print("practice by topic completed");
      practiceList = [];
      for (var docSnapshot in querySnapshot.docs) {
        practiceList.add(PracticeModel(
            id: docSnapshot.id,
            topicId: docSnapshot["topicId"],
            content: docSnapshot["content"],
            equation: docSnapshot["equation"],
            img: docSnapshot["img"],
            result: docSnapshot["result"],
            resultImg: docSnapshot["resultImg"],
            solutions: docSnapshot["solutions"]));
      }
    }, onError: (e) => print("Error fetching practice by topic")).then(
            (value) async => {
                  await db
                      .collection("PracticeCompleted")
                      .where("user", isEqualTo: user?.uid)
                      .where("topic", isEqualTo: topic.id)
                      .get()
                      .then((value) async {
                    completedPractice = [];
                    if (value.size != 0) {
                      print("here here");
                      for (var item in value.docs) {
                        completedPractice.add(item["practice"]);
                      }
                      var removeList = [];
                      for (var i in practiceList) {
                        if (completedPractice.contains(i.id)) {
                          removeList.add(i);
                        }
                      }
                      for (var i in removeList) {
                        practiceList.remove(i);
                      }
                    }
                    enabled = true;
                    setState(() {});
                  })
                },
            onError: (e) => print(
                "Error fetching completed practice by topic" + e.toString()));

    setState(() {});
  }

  Future<void> addPractice(String practice) async {
    if (!completedPractice.contains(practice)) {
      db
          .collection("PracticeCompleted")
          .add({"user": user!.uid, "practice": practice, "topic": topic.id});
    }
  }

  Future<void> clearPractice() async {
    var collection = FirebaseFirestore.instance
        .collection('PracticeCompleted')
        .where("topic", isEqualTo: topic.id)
        .where("user", isEqualTo: user?.uid);
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(S.of(context).practice),
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
                if (practiceList.isEmpty)
                  endTasks()
                else
                  flag == true ? buildTaskView() : buildResultView()
              ]))),
    );
  }

  SingleChildScrollView buildResultView() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              heroTag: "btn1",
              onPressed: () {
                if (enabled) {
                  downloadPractice();
                  setState(() {});
                }
              },
              label: downloaded == true
                  ? Text(S.of(context).downloaded)
                  : Text(S.of(context).download),
              backgroundColor: downloaded == true ? Colors.pink : Colors.teal,
              icon: const Icon(Icons.download_rounded),
            ),
            if(userRole=="admin")
            FloatingActionButton.extended(
              heroTag: "btn2",
              onPressed: () {
                if (enabled) {
                  deletePractice();
                  if (index + 1 < practiceList.length) {
                    nextTask();
                    }
                  } else {
                  endTasks();
                }
                  setState(() {});
              },
              label: Text(S.of(context).delete),
              backgroundColor: Colors.pink,
              icon: const Icon(Icons.delete_forever_rounded),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
              correct == true ? S.of(context).correct : S.of(context).incorrect,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Math.tex(
            practiceList[index].result,
            mathStyle: MathStyle.display,
            textStyle: const TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Math.tex(practiceList[index].solutions,
              mathStyle: MathStyle.display,
              textStyle: const TextStyle(fontSize: 20)),
        ),
        if (practiceList[index].resultImg != "")
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CachedNetworkImage(
              height: MediaQuery.of(context).size.height*0.25,

              imageUrl: practiceList[index].resultImg,
              placeholder: (context, url) => const CircularProgressIndicator(),
            ),
          ),
        //TODO: result field to be filled after algorithm
        // const Text("Your result, if read from photo, if not from input"),
        if (index + 1 < practiceList.length) nextTask() else endTasks()
      ],
    ));
  }

  Column endTasks() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              margin: const EdgeInsets.all(15),
              child: Text(
                S.of(context).youFinishedAllPracticeQuestions,
                style: const TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                S.of(context).quit,
                style: const TextStyle(fontSize: 20),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                clearPractice();
                setState(() {});
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Practice(
                              topic: topic,
                              section: section,
                            )));
              },
              child: Text(S.of(context).startOver,
                  style: const TextStyle(fontSize: 20))),
        )
      ],
    );
  }

  Column nextTask() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                flag = true;
                correct = false;
                if (index + 1 < practiceList.length) {
                  index += 1;
                  isDownloaded();
                }
                setState(() {});
              },
              child: Text(S.of(context).next)),
        ),
        if (!correct)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () {
                  flag = true;
                  setState(() {});
                },
                child: Text(S.of(context).tryAgain)),
          )
      ],
    );
  }

  fileFromCamera() async {
    final file = await imagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 1000, maxHeight: 1000);
    PhotoDecoder d= PhotoDecoder();
    if(file==null) return;
    d.preProcessImage(file);



    // int loopLimit =1000;
    // for(int x = 0; x < loopLimit; x++) {
    //   int red = decodedBytes[decodedImg.width*3 + x*3];
    //   int green = decodedBytes[decodedImg.width*3 + x*3 + 1];
    //   int blue = decodedBytes[decodedImg.width*3 + x*3 + 2];
    //   imgArray.add([red, green, blue]);
    // }
    // print(imgArray);
    // XFile? filePick = files;
    // File selectedImg;
    // if (filePick != null) {
    //   selectedImg=(File(filePick.path));
    //   List<int> imageBytes = selectedImg.readAsBytesSync();
    //   String imageAsString = base64Encode(imageBytes);
    //   Uint8List uint8list = base64.decode(imageAsString);
    //   Image image = Image.memory(uint8list);
    //   log(imageBytes.toString());
    //   final pngByteData = await image.toByteData(format: ImageByteFormat.rawRgba);
      // String base64Image = base64Encode(imageBytes);
      // log(base64Image);
      //
      // await selectedImg.writeAsBytes(base64.decode());
    //   setState(() {});
    // } else {
    //   if (!mounted) return;
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(content: Text(S.of(context).nothingIsSelected)));
    // }
  }



  SingleChildScrollView buildTaskView() {
    late final inputController = MathFieldEditingController();
    late String solution;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              practiceList[index].content,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Math.tex(
              practiceList[index].equation,
              mathStyle: MathStyle.display,
              textStyle: const TextStyle(fontSize: 20),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  if (practiceList[index].img != "")
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.25,
                      child: CachedNetworkImage(
                        imageUrl: practiceList[index].img,
                        placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                      ),
                    )
                ],
              )
            //Image.network(practiceList[index].img),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: MathField(
              // No parameters are required.
              controller: inputController,

              keyboardType: MathKeyboardType.expression,
              // Specify the keyboard type (expression or number only).
              variables: const ['x', 'y', 'z'],
              // Specify the variables the user can use (only in expression mode).
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: S
                    .of(context)
                    .yourSolution,
              ),
              // Decorate the input field using the familiar InputDecoration.
              onChanged: (String value) {},
              // Respond to changes in the input field.
              onSubmitted: (String value) {
                mathInput = value;
              },
              // Respond to the user submitting their input.
              autofocus:
              false, // Enable or disable autofocus of the input field.
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
                onPressed: () {
                  fileFromCamera();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.camera_alt_rounded),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(S
                          .of(context)
                          .submitPhotoOfSolution),
                    )
                  ],
                )),
          ),
          Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: enabled == true
                          ? MaterialStateProperty.all(Colors.pink)
                          : MaterialStateProperty.all(Colors.blueGrey)),
                  onPressed: () {
                    if (enabled) {
                      print(practiceList[index].result);
                      if (mathInput == practiceList[index].result) {
                        correct = true;
                        addPractice(practiceList[index].id);
                      }
                      flag = false;
                      setState(() {});
                    }
                  },
                  child: Text(S
                      .of(context)
                      .submitAnswer)))
        ],
      ),
    );
  }

}
