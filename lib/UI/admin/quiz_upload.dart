import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math/generated/l10n.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import '../../Model/QuizModel.dart';

class UploadQuiz extends StatefulWidget {
  late String type;
  late String container;

  @override
  State<UploadQuiz> createState() => _UploadQuiz();

  UploadQuiz({Key? key, required this.type, required this.container})
      : super(key: key);
}

class _UploadQuiz extends State<UploadQuiz> {
  late User? user;
  late String container;
  late String type;
   bool connected=true;
  FirebaseFirestore db = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final responseController = TextEditingController();
  String equationInput = "";
  String resultInput = "";
  TextEditingController quizContentController = TextEditingController();
  MathFieldEditingController quizEquationController =
      MathFieldEditingController();
  MathFieldEditingController quizResultController =
      MathFieldEditingController();
  MathFieldEditingController aSolutionsController =
      MathFieldEditingController();
  String aInput = "";
  MathFieldEditingController bSolutionsController =
      MathFieldEditingController();
  String bInput = "";
  MathFieldEditingController cSolutionsController =
      MathFieldEditingController();
  String cInput = "";
  MathFieldEditingController dSolutionsController =
      MathFieldEditingController();
  String dInput = "";

  Color cameraColorImg = Colors.black45;
  Color cameraColorResult = Colors.black45;
  File? image;

  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    container = widget.container;
    type = widget.type;
    initConnect();
    if(connected){
      user = FirebaseAuth.instance.currentUser;
    }
    super.initState();
  }
  initConnect() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none ||
        connectivityResult == ConnectivityResult.bluetooth) {
      connected = false;
    }
  }


  Future<void> addQuiz(QuizModel quiz) async {
    db.collection("Quiz").add(quiz.toFirestore()).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }

  submitQuiz(BuildContext context) async {
    try {
      var downloadUrl = "";

      if (image != null) {
        final name = basename(image!.path);
        final dest = 'practice/$name';
        var snapshotTask = await storage.ref(dest).putFile(image!);
        downloadUrl = await snapshotTask.ref.getDownloadURL();
      }
      var solution = "$aInput,$bInput,$cInput,$dInput";
      QuizModel quiz;
      if (type == "quiz") {
        quiz = QuizModel(
            id: "",
            topicId: container,
            section: "",
            content: quizContentController.text,
            equation: equationInput,
            img: downloadUrl,
            result: resultInput,
            solutions: solution);
      } else {
        quiz = QuizModel(
            id: "",
            topicId: "",
            section: container,
            content: quizContentController.text,
            equation: equationInput,
            img: downloadUrl,
            result: resultInput,
            solutions: solution);
      }
      try {
        addQuiz(quiz);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).quizSubmittedSuccessfully)));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).submissionFailed)));
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getImgFromGallery(BuildContext context) async {
    final files = await imagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);
    XFile? filePick = files;
    if (filePick != null) {
      image = File(filePick.path);
      setState(() {});
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).nothingIsSelected)));
    }
  }

  Future getImgFromCamera(BuildContext context) async {
    final files = await imagePicker.pickImage(
        source: ImageSource.camera, maxWidth: 500, maxHeight: 500);
    XFile? filePick = files;
    if (filePick != null) {
      image = File(filePick.path);
      setState(() {});
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).nothingIsSelected)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(type),
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
              child: Column(children: [buildQuizView(context)]))),
    );
  }

  SingleChildScrollView buildQuizView(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    getImgFromCamera(context);
                    setState(() {});
                  },
                  icon: const Icon(Icons.add_a_photo_rounded),
                  style: ButtonStyle(
                      iconColor: MaterialStateProperty.all(cameraColorImg)),
                ),
                IconButton(
                  onPressed: () {
                    getImgFromGallery(context);
                    setState(() {});
                  },
                  icon: const Icon(Icons.photo_library_rounded),
                  style: ButtonStyle(
                      iconColor: MaterialStateProperty.all(cameraColorImg)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextField(
                  controller: quizContentController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: S.of(context).quizTaskContent,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: MathField(
                controller: quizEquationController,
                keyboardType: MathKeyboardType.expression,
                variables: const ['x', 'y', 'z'],
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: S.of(context).equations,
                ),
                onChanged: (String value) {
                  equationInput = value;
                  setState(() {});
                },
                onSubmitted: (String value) {
                  equationInput = value;
                  setState(() {});
                },
                autofocus: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: MathField(
                controller: quizResultController,
                keyboardType: MathKeyboardType.expression,
                variables: const ['x', 'y', 'z'],
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  hintText: S.of(context).correctResult,
                ),
                onChanged: (String value) {
                  resultInput = value;
                  setState(() {});
                },
                onSubmitted: (String value) {
                  resultInput = value;
                  setState(() {});
                },
                autofocus: false,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: MathField(
                    controller: aSolutionsController,
                    keyboardType: MathKeyboardType.expression,
                    variables: const ['x', 'y', 'z'],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "A",
                    ),
                    onChanged: (String value) {
                      aInput = value;
                      setState(() {});
                    },
                    onSubmitted: (String value) {
                      aInput = value;
                      setState(() {});
                    },
                    autofocus: false,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: MathField(
                    controller: bSolutionsController,
                    keyboardType: MathKeyboardType.expression,
                    variables: const ['x', 'y', 'z'],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "B",
                    ),
                    onChanged: (String value) {
                      bInput = value;
                      setState(() {});
                    },
                    onSubmitted: (String value) {
                      bInput = value;
                      setState(() {});
                    },
                    autofocus: false,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: MathField(
                    controller: cSolutionsController,
                    keyboardType: MathKeyboardType.expression,
                    variables: const ['x', 'y', 'z'],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "C",
                    ),
                    onChanged: (String value) {
                      cInput = value;
                      setState(() {});
                    },
                    onSubmitted: (String value) {
                      cInput = value;
                      setState(() {});
                    },
                    autofocus: false,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: MathField(
                    controller: dSolutionsController,
                    keyboardType: MathKeyboardType.expression,
                    variables: const ['x', 'y', 'z'],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: "D",
                    ),
                    onChanged: (String value) {
                      dInput = value;
                      setState(() {});
                    },
                    onSubmitted: (String value) {
                      dInput = value;
                      setState(() {});
                    },
                    autofocus: false,
                  ),
                ),
              ],
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:  connected==true ? MaterialStateProperty.all(Colors.pink): MaterialStateProperty.all(Colors.blueGrey)
                ),
                onPressed: () {
                  if(connected) {
                    submitQuiz(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UploadQuiz(
                                  container: container,
                                  type: type,
                                )));
                    Navigator.pop(context);
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                        Text(S.of(context).noInternetConnection)));
                  }
                },
                child: Text(S.of(context).submit))
          ],
        ),
      ),
    );
  }
}
