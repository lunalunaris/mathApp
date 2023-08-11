import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:math/Model/PracticeModel.dart';
import 'package:math/Model/TopicModel.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_math_fork/tex.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import '../../Model/QuizModel.dart';
import '../../Model/TheoryModel.dart';

class Upload extends StatefulWidget {
  late String type;
  late String container;

  @override
  State<Upload> createState() => _Upload();

  Upload({Key? key, required this.type, required this.container})
      : super(key: key);
}

class _Upload extends State<Upload> {
  late User? user;
  late String container;
  late String type;

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
  TextEditingController quizContentController = TextEditingController();
  MathFieldEditingController quizEquationController =
      MathFieldEditingController();
  MathFieldEditingController quizResultController =
      MathFieldEditingController();
  MathFieldEditingController ASolutionsController =
      MathFieldEditingController();
  String aInput = "";
  MathFieldEditingController BSolutionsController =
      MathFieldEditingController();
  String bInput = "";
  MathFieldEditingController CSolutionsController =
      MathFieldEditingController();
  String cInput = "";
  MathFieldEditingController DSolutionsController =
      MathFieldEditingController();
  String dInput = "";
  var imageUrl = "";
  Color cameraColorImg=Colors.black45;
  Color cameraColorResult=Colors.black45;
  File? imageFirst;
  File? image;
  File? imageSecond;
  String imagePathFirst="";
  String imagePathSecond="";
  final ImagePicker imagePicker = ImagePicker();

  Future imgFirstFromFile() async {
    final chosenImg = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (chosenImg != null) {
        imageFirst = File(chosenImg.path);
        // fileToFirebase();
      }
    });
  }
  Future imgSecondFromFile() async{
    final chosenImg = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (chosenImg != null) {
        image = File(chosenImg.path);
        // fileToFirebase();
      }
    });
  }

  Future fileToFirebase() async {

    if (image != null) {
      final name = basename(image!.path);
      final dest = 'questions/$name';
      try {
        // final ref =storage.ref(dest).child('file/');
        // await ref.putFile(image!);
        var snapshot = await storage.ref(dest).putFile(image!);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      } catch (e) {
        print(e.toString());
      }
      return imageUrl;
    }
  }

  @override
  void initState() {
    container = widget.container;
    type = widget.type;
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }
  Future<void> addTheory(TheoryModel theory) async {
    db.collection("Theory").add(theory.toFirestore()).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<void> addPractice(PracticeModel practice) async {
    db.collection("Practice").add(practice.toFirestore()).then(
            (documentSnapshot) =>
            print("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<void> addQuiz(QuizModel quiz) async {
    db.collection("Quiz").add(quiz.toFirestore()).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Practice"),
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
                if (type == "theory")
                  buildTheoryView(context)
                else if (type == "practice")
                  buildPracticeView(context)
                else if (type == "quiz" || type == 'section quiz')
                  buildQuizView(context)
              ]))),
    );
  }

  submitTheory(BuildContext context) {
    TheoryModel theory = TheoryModel(id: "none", topicId: container, img: imagePathFirst );
    addTheory(theory);
  }

  submitPractice(BuildContext context) {
    PracticeModel practice= PracticeModel(id: "none",
        topicId: container,
        content: practiceContentController.text,
        equation: equationInput,
        img: imagePathFirst,
        result: resultInput,
        resultImg: imagePathSecond,
        solutions: solutionInput);
    //submit photo and await for it before adding practice
    addPractice(practice);
  }

  submitQuiz(BuildContext context) {}

  Column buildTheoryView(BuildContext context) {
    return Column(
      children: [
        Text("Upload theory images"),
        IconButton(
          onPressed: () {
          //  imgFromFile();
            imagePathFirst =imageUrl;
            setState(() {});
          },
          icon: Icon(Icons.add_a_photo_rounded),
          style: ButtonStyle(
            iconColor: MaterialStateProperty.all(cameraColorImg)
          ),
        ),
        //maybe matex file input]
        ElevatedButton(
            onPressed: () {
              submitTheory(context);
            },
            child: const Text("Submit"))
      ],
    );
  }

  SingleChildScrollView buildPracticeView(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            const Text("Task contents"),
            TextFormField(
              controller: practiceContentController,
            ),
            const Text("Equations"),
            MathField(
              controller: practiceEquationController,
              keyboardType: MathKeyboardType.expression,
              variables: const ['x', 'y', 'z'],
              decoration: const InputDecoration(),
              onChanged: (String value) {},
              onSubmitted: (String value) {
                equationInput = value;
                setState(() {});
              },
              autofocus: false,
            ),
            const Text("Image"),
            IconButton(
              onPressed: () {
                //imgFromFile();
                imagePathFirst =imageUrl;
                print(imagePathFirst);
                setState(() {});
              },
              icon: Icon(Icons.add_a_photo_rounded),
              style: ButtonStyle(
                  iconColor: MaterialStateProperty.all(cameraColorImg)
              ),
            ),
            const Text("Text result"),
            MathField(
              controller: practiceResultController,
              keyboardType: MathKeyboardType.expression,
              variables: const ['x', 'y', 'z'],
              decoration: const InputDecoration(),
              onChanged: (String value) {},
              onSubmitted: (String value) {
                resultInput = value;
                setState(() {});
              },
              autofocus: false,
            ),
            const Text("Result image"),
            IconButton(
              onPressed: () {
                //imgFromFile();
                imagePathSecond =imageUrl;
                setState(() {});
              },
              icon: Icon(Icons.add_a_photo_rounded),
              style: ButtonStyle(
                  iconColor: MaterialStateProperty.all(cameraColorResult)
              ),
            ),
            const Text("Solution suggestions"),
            MathField(
              controller: practiceSolutionsController,
              keyboardType: MathKeyboardType.expression,
              variables: const ['x', 'y', 'z'],
              decoration: const InputDecoration(),
              onChanged: (String value) {},
              onSubmitted: (String value) {
                solutionInput = value;
                setState(() {});
              },
              autofocus: false,
            ),
            ElevatedButton(
                onPressed: () {
                  submitPractice(context);
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildQuizView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text("Quiz contents"),
          TextFormField(
            controller: quizContentController,
          ),
          const Text("Equations"),
          MathField(
            controller: quizEquationController,
            keyboardType: MathKeyboardType.expression,
            variables: const ['x', 'y', 'z'],
            decoration: const InputDecoration(),
            onChanged: (String value) {},
            onSubmitted: (String value) {
              equationInput = value;
              setState(() {});

            },
            autofocus: false,
          ),
          const Text("Image"),
          IconButton(
            onPressed: () {
           //   imgFromFile();
              imagePathFirst =imageUrl;
              setState(() {});

            },
            icon: Icon(Icons.add_a_photo_rounded),
            style: ButtonStyle(
                iconColor: MaterialStateProperty.all(cameraColorImg)
            ),
          ),
          const Text("Correct result"),
          MathField(
            controller: quizResultController,
            keyboardType: MathKeyboardType.expression,
            variables: const ['x', 'y', 'z'],
            decoration: const InputDecoration(),
            onChanged: (String value) {},
            onSubmitted: (String value) {
              resultInput = value;
              setState(() {});

            },
            autofocus: false,
          ),
          const Text("Solutions"), //summarise later
          MathField(
            controller: ASolutionsController,
            keyboardType: MathKeyboardType.expression,
            variables: const ['x', 'y', 'z'],
            decoration: const InputDecoration(),
            onChanged: (String value) {},
            onSubmitted: (String value) {
              aInput = value;
              setState(() {});

            },
            autofocus: false,
          ),
          MathField(
            controller: BSolutionsController,
            keyboardType: MathKeyboardType.expression,
            variables: const ['x', 'y', 'z'],
            decoration: const InputDecoration(),
            onChanged: (String value) {},
            onSubmitted: (String value) {
              bInput = value;
              setState(() {});

            },
            autofocus: false,
          ),
          MathField(
            controller: CSolutionsController,
            keyboardType: MathKeyboardType.expression,
            variables: const ['x', 'y', 'z'],
            decoration: const InputDecoration(),
            onChanged: (String value) {},
            onSubmitted: (String value) {
              cInput = value;
              setState(() {});

            },
            autofocus: false,
          ),
          MathField(
            controller: DSolutionsController,
            keyboardType: MathKeyboardType.expression,
            variables: const ['x', 'y', 'z'],
            decoration: const InputDecoration(),
            onChanged: (String value) {},
            onSubmitted: (String value) {
              dInput = value;
              setState(() {});

            },
            autofocus: false,
          ),
          ElevatedButton(
              onPressed: () {
                submitQuiz(context);
              },
              child: const Text("Submit"))
        ],
      ),
    );
  }
}

// List<PracticeModel> practiceList = [
//   PracticeModel(
//       id: "none",
//       topicId: "none",
//       content: "Loading...",
//       equation: "null",
//       img: "https://firebasestorage.googleapis.com/v0/b/math-16d0d.appspot.com/o/theory.png?alt=media&token=d3cfd46c-c247-4065-803a-00f621328968",
//       result: "null",
//       resultImg: "https://firebasestorage.googleapis.com/v0/b/math-16d0d.appspot.com/o/theory.png?alt=media&token=d3cfd46c-c247-4065-803a-00f621328968",
//       solutions: "null")
// ];

//
// SingleChildScrollView buildResultView() {
//   return SingleChildScrollView(
//       child: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//
//             ],
//           ),
//           Text(correct == true ? "correct" : "incorrect"),
//           Math.tex(practiceList[index].result, mathStyle: MathStyle.display),
//           Math.tex(
//               practiceList[index].solutions, mathStyle: MathStyle.display),
//           const Text("Your result, if read from photo, if not from input"),
//           if(index + 1 < practiceList.length)
//             nextTask()
//           else
//             endTasks()
//
//
//         ],
//       ));

// Column endTasks() {
//   return Column(
//     children: [
//       Container(margin: const EdgeInsets.all(8),
//           child: const Text("You finished all practice questions!")),
//       ElevatedButton(onPressed: () {
//         Navigator.of(context).pop();
//       }, child: const Text("Quit")),
//       ElevatedButton(onPressed: () {
//         clearPractice();
//         setState(() {});
//         Navigator.of(context).pop();
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => Practice(topic: topic,)));
//         ;
//       }, child: const Text("Start over?"))
//     ],
//   );
// }
//
// Column nextTask() {
//   return Column(
//     children: [
//       ElevatedButton(onPressed: () {
//         flag = true;
//         correct = false;
//         if (index + 1 < practiceList.length) {
//           index += 1;
//           print(index);
//         }
//         setState(() {});
//       }, child: const Text("Next")),
//       if (!correct)
//         ElevatedButton(onPressed: () {
//           flag = true;
//           setState(() {});
//         }, child: const Text("Try again?"))
//     ],
//   );
// }
//
// SingleChildScrollView buildTaskView() {
//   late final inputController = MathFieldEditingController();
//   late String solution;
//   return SingleChildScrollView(
//     child: Column(
//       children: [
//         Text(practiceList[index].content),
//         Math.tex(practiceList[index].equation, mathStyle: MathStyle.display),
//         Container(
//           margin: const EdgeInsets.only(top: 20),
//           height: 200,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: Image.network(
//               practiceList[index].img),
//         ),
//         MathField(
//           // No parameters are required.
//           controller: inputController,
//
//           keyboardType: MathKeyboardType.expression,
//           // Specify the keyboard type (expression or number only).
//           variables: const ['x', 'y', 'z'],
//           // Specify the variables the user can use (only in expression mode).
//           decoration: const InputDecoration(),
//           // Decorate the input field using the familiar InputDecoration.
//           onChanged: (String value) {},
//           // Respond to changes in the input field.
//           onSubmitted: (String value) {
//             mathInput = value;
//
//           },
//           // Respond to the user submitting their input.
//           autofocus: false, // Enable or disable autofocus of the input field.
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 30),
//           child: ElevatedButton(
//               onPressed: () {},
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(4.0),
//                     child: Icon(Icons.camera_alt_rounded),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.all(2.0),
//                     child: Text("submit photo of solution"),
//                   )
//                 ],
//               )),
//         ),
//         Container(
//             margin: const EdgeInsets.only(top: 30),
//             padding: const EdgeInsets.all(8),
//             child: ElevatedButton(
//                 onPressed: () {
//                   print(practiceList[index].result);
//                   if (mathInput == practiceList[index].result) {
//                     correct = true;
//                     addPractice(practiceList[index].id);
//                   }
//                   flag = false;
//                   setState(() {});
//                 },
//                 child: const Text("Submit answer")))
//       ],
//     ),
//   );
// }
//
//

//text
//math render
//image
//math input
//camera input
