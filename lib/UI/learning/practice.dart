import 'dart:convert';
import 'dart:io' as i;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math/Database/sqliteHandler.dart';
import 'package:math/Model/PracticeModel.dart';
import 'package:math/Model/SectionModel.dart';
import 'package:math/Model/TopicModel.dart';
import 'package:math/generated/l10n.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
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
  bool solved = true;
  bool connected = true;
  bool downloaded = false;
  bool correct = false;
  bool enabled = false;
  bool responseSent = false;
  String userRole = "";
  String photoResult = "";

  bool waiting = false;
  bool photoProcessed = false;
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
        solutions: "null",
        photoSolution: 0)
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
    PracticeModel p = practiceList[index];
    practiceList.remove(p);
    setState(() {});
    final collection = FirebaseFirestore.instance.collection('Practice');
    collection
        .doc(p.id)
        .delete()
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
      practiceList = [];
      for (var docSnapshot in querySnapshot.docs) {
        practiceList.add(PracticeModel(
            id: docSnapshot.id,
            topicId: docSnapshot["topicId"],
            content: docSnapshot["content"],
            equation: docSnapshot["equation"],
            img: docSnapshot["img"],
            result: docSnapshot["result"],
            solutions: docSnapshot["solutions"],
            photoSolution: docSnapshot["photoSolution"]));
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
                else if (waiting == true)
                  waitingScreen()
                else
                  solved == true ? buildTaskView() : buildResultView()
              ]))),
    );
  }

  Column waitingScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(S.of(context).loading)],
    );
  }

  SingleChildScrollView buildResultView() {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
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
              if (userRole == "admin")
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
          child: Text(S.of(context).correctResult),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Math.tex(
            practiceList[index].result,
            mathStyle: MathStyle.display,
            textStyle: const TextStyle(fontSize: 20),
          ),
        ),
        if (practiceList[index].solutions != "")
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(S.of(context).suggestedSolutions),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Math.tex(practiceList[index].solutions,
                    mathStyle: MathStyle.display,
                    textStyle: const TextStyle(fontSize: 20)),
              ),
            ],
          ),
        if (photoResult != "")
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(S.of(context).yourResult),
                    ),  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Math.tex(
                        photoResult,
                        mathStyle: MathStyle.display,
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),

                //TODO: block button if sent
                TextButton(
                    onPressed: () {
                      if (!responseSent) {
                        sendResponse();
                        setState(() {});
                      }
                    },
                    child: Text(S.of(context).isThisYourResult))
              ],
            ),
          ),
        if (mathInput != "")
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(S.of(context).yourResult),
                ),
                Math.tex(
                  mathInput,
                  mathStyle: MathStyle.display,
                  textStyle: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        // const Text("Your result, if read from photo, if not from input"),
        if (index + 1 < practiceList.length) nextTask() else endTasks()
      ],
    ));
  }

  sendResponse() async {
    final uri = Uri.http("192.168.1.7:5000", '/upload');
    var request= await http.post(
      Uri.parse('http://192.168.1.7:5000/verify'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': user!.uid,
      }),
    );
    if (request.statusCode==200 || request.statusCode==201)
      {
        responseSent = true;
        setState(() {});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).thankYouForYourFeedback)));
        }
      }
    else{
      responseSent = false;
      setState(() {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).errorSendingYourResponse)));
      }
    }
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
                style: const TextStyle(fontSize: 18),
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
    photoResult = "";
    photoProcessed = false;
    setState(() {});
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                solved = true;
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
                  solved = true;
                  setState(() {});
                },
                child: Text(S.of(context).tryAgain)),
          )
      ],
    );
  }

  fileFromCamera() async {
    final file = await imagePicker
        .pickImage(source: ImageSource.camera, maxWidth: 700, maxHeight: 700)
        .then((value) async {
      if (value == null) return;
      i.File newFile = i.File(value.path);
      var decodedImage = await decodeImageFromList(newFile.readAsBytesSync());
      final uri = Uri.http("192.168.1.7:5000", '/upload');
      var request = MultipartRequest('POST', uri);
      Map<String, String> headers = {"Content-type": "multipart/form-data"};

      request.files.add(
        MultipartFile(
            'image', newFile.readAsBytes().asStream(), newFile.lengthSync(),
            filename: "filename.jpg"),
      );
      print(newFile.readAsBytes().asStream());
      request.headers.addAll(headers);
      request.fields["height"] = decodedImage.height.toString();
      request.fields["width"] = decodedImage.width.toString();
      request.fields["userId"] = user!.uid;
      var res = await request.send();
      await Response.fromStream(res).then((value) {
        if (value.statusCode == 400 || value.statusCode == 500) {
          waiting = false;
          photoProcessed = false;
          solved = false;
          setState(() {});
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text(S.of(context).errorUploadingPhotoPleaseTryAgain)));
          }
          throw Exception("Image upload failed");
        } else {
          var jsonres = jsonDecode(value.body);
          photoResult = jsonres["result"];
          photoProcessed = true;
          waiting = false;
          if (photoResult == practiceList[index].result) {
            solved = true;
            correct = true;
          }
          solved = false;
          setState(() {});
        }
        print(value.body.toString());
      }).catchError((e) {
        print(e);
      });
    });
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
                      height: MediaQuery.of(context).size.height * 0.25,
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
              controller: inputController,
              keyboardType: MathKeyboardType.expression,
              variables: const ['x', 'y', 'z'],
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: S.of(context).yourSolution,
              ),
              onChanged: (String value) {
                mathInput = value;
              },
              onSubmitted: (String value) {
                mathInput = value;
              },
              autofocus: false,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: connected == true
                      ? MaterialStateProperty.all(Colors.pink)
                      : MaterialStateProperty.all(Colors.blueGrey),
                ),
                onPressed: () async {
                  if (connected &&
                      !waiting &&
                      practiceList[index].photoSolution == 1) {
                    waiting = true;
                    setState(() {});
                    await fileFromCamera();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(S.of(context).noInternetConnection)));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.camera_alt_rounded,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(S.of(context).submitPhotoOfSolution),
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
                    if (enabled && !waiting) {
                      print(practiceList[index].result);
                      if (mathInput == practiceList[index].result) {
                        correct = true;
                        solved = true;
                        addPractice(practiceList[index].id);
                      }
                      solved = false;
                      setState(() {});
                    }
                  },
                  child: Text(S.of(context).submitAnswer)))
        ],
      ),
    );
  }
}
