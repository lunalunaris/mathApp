import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math/Model/PracticeModel.dart';
import 'package:math/generated/l10n.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class UploadPractice extends StatefulWidget {
  late String container;

  @override
  State<UploadPractice> createState() => _UploadPractice();

  UploadPractice({Key? key, required this.container}) : super(key: key);
}

class _UploadPractice extends State<UploadPractice> {
  late User? user;
  late String container;

  FirebaseFirestore db = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final responseController = TextEditingController();

  TextEditingController practiceContentController = TextEditingController();
  MathFieldEditingController practiceEquationController =
      MathFieldEditingController();
  String equationInput = "";
  MathFieldEditingController practiceResultController =
      MathFieldEditingController();
  String resultInput = "";
  MathFieldEditingController practiceSolutionsController =
      MathFieldEditingController();
  String solutionInput = "";

  var imageUrl = "";
  Color cameraColorImg = Colors.black45;
  Color cameraColorResult = Colors.black45;
  File? solutionImg;
  File? taskImg;
  File? tempFile;

  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    container = widget.container;

    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  Future<void> addPractice(PracticeModel practice) async {
    db.collection("Practice").add(practice.toFirestore()).then(
        (documentSnapshot) =>
            print("Added Data with ID: ${documentSnapshot.id}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:  Text(S.of(context).practice),
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
              child: Column(children: [buildPracticeView(context)]))),
    );
  }

  submitPractice(BuildContext context) async {
    try {
      var downloadUrlTask = "";
      var downloadUrlSol = "";

      if (taskImg != null) {
        final nameTask = basename(taskImg!.path);
        final destTask = 'practice/$nameTask';
        var snapshotTask = await storage.ref(destTask).putFile(taskImg!);
        downloadUrlTask = await snapshotTask.ref.getDownloadURL();
      }
      if (solutionImg != null) {
        final nameSolution = basename(solutionImg!.path);
        final destSol = 'practice/$nameSolution';
        var snapshotSol = await storage.ref(destSol).putFile(solutionImg!);
        downloadUrlSol = await snapshotSol.ref.getDownloadURL();
      }
      PracticeModel practice = PracticeModel(
          id: "none",
          topicId: container,
          content: practiceContentController.text,
          equation: equationInput,
          img: downloadUrlTask,
          result: resultInput,
          resultImg: downloadUrlSol,
          solutions: solutionInput);
      try {
        addPractice(practice);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).practiceSubmitted)));
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).submissionFailed)));
      }
    } catch (e) {
      print(e.toString());
    }

    //submit photo and await for it before adding practice
  }

  Future getImgFromGallery(BuildContext context) async {
    final files = await imagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 500, maxHeight: 500);
    XFile? filePick = files;
    if (filePick != null) {
      tempFile = File(filePick.path);
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
      tempFile = File(filePick.path);
      setState(() {});
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).nothingIsSelected)));
    }
  }

  SingleChildScrollView buildPracticeView(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: S.of(context).practiceTaskContent,
              ),
              controller: practiceContentController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: MathField(
              controller: practiceEquationController,
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
            padding: const EdgeInsets.all(5.0),
            child: MathField(
              controller: practiceResultController,
              keyboardType: MathKeyboardType.expression,
              variables: const ['x', 'y', 'z'],
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: S.of(context).textCorrectResult,
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
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: MathField(
              controller: practiceSolutionsController,
              keyboardType: MathKeyboardType.expression,
              variables: const ['x', 'y', 'z'],
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                hintText: S.of(context).suggestedSolutionMethods,
              ),
              onChanged: (String value) {
                solutionInput = value;
                setState(() {});
              },
              onSubmitted: (String value) {
                solutionInput = value;
                setState(() {});
              },
              autofocus: false,
            ),
          ),
          photoBuilder(context),
          ElevatedButton(
              onPressed: () {
                submitPractice(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UploadPractice(
                              container: container,
                            )));
                Navigator.pop(context);
              },
              child: Text(S.of(context).submit))
        ],
      ),
    );
  }

  Padding photoBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  showCameraDialog(context);
                  taskImg = tempFile;
                  setState(() {});
                },
                label: Text(S.of(context).taskImage),
                backgroundColor: Colors.pink.shade800,
                icon: const Icon(Icons.add_a_photo_rounded),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  showCameraDialog(context);
                  solutionImg = tempFile;
                  setState(() {});
                },
                label: Text(S.of(context).resultImage),
                backgroundColor: Colors.pink.shade800,
                icon: const Icon(Icons.add_a_photo_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showCameraDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  20.0,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.only(
              top: 10.0,
            ),
            title: const Text(
              "Choose source",
              style: TextStyle(fontSize: 24.0),
            ),
            content: SizedBox(
              height: 120,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              getImgFromCamera(context);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.photo_camera),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: IconButton(
                            iconSize: 40,
                            onPressed: () {
                              getImgFromGallery(context);
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.photo_library_rounded),
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(100, 100)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
