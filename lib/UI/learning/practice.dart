import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/PracticeModel.dart';
import 'package:math/Model/TopicModel.dart';
import 'package:math_keyboard/math_keyboard.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_math_fork/tex.dart';

class Practice extends StatefulWidget {
  late TopicModel topic;

  @override
  State<Practice> createState() => _Practice();

  Practice({Key? key, required this.topic}) : super(key: key);
}

class _Practice extends State<Practice> {
  late User? user;
  late TopicModel topic;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final responseController = TextEditingController();
  bool flag = true;
  bool correct = false;
  int index = 0;
  List<PracticeModel> practiceList = [
    PracticeModel(
        id: "none",
        topicId: "none",
        content: "Loading...",
        equation: "null",
        img: "https://firebasestorage.googleapis.com/v0/b/math-16d0d.appspot.com/o/theory.png?alt=media&token=d3cfd46c-c247-4065-803a-00f621328968",
        result: "null",
        resultImg: "https://firebasestorage.googleapis.com/v0/b/math-16d0d.appspot.com/o/theory.png?alt=media&token=d3cfd46c-c247-4065-803a-00f621328968",
        solutions: "null")
  ];
  List<String> completedPractice = [];
  String mathInput = "";

  @override
  void initState() {
    topic = widget.topic;
    user = FirebaseAuth.instance.currentUser;
    initPractice();
    super.initState();
  }

  initPractice() async {
    await db
        .collection("Practice")
        .where("topicId", isEqualTo: topic.id)
        .get()
        .then((querySnapshot) async {
      print("sections by level completed");
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
    }, onError: (e) => print("Error fetching sections by level")).then((
        value) async =>
    {
      await db
          .collection("PracticeCompleted")
          .where("user", isEqualTo: user?.uid)
          .where("topic", isEqualTo: topic.id)
          .get()
          .then((value) async {
        completedPractice = [];
        for (var item in value.docs) {
          completedPractice.add(item["practice"]);
        }
        var removeList =[];
        for (var i in practiceList){
          if(completedPractice.contains(i.id)){
            removeList.add(i);
          }
        }
        for (var i in removeList){
          practiceList.remove(i);
        }
      }

      )}, onError: (e) => print("Error fetching sections by level"));

    setState(() {});
  }

  Future<void> addPractice(String practice) async {
    if (!completedPractice.contains(practice)) {
      db.collection("PracticeCompleted").add(
          {"user": user!.uid, "practice": practice, "topic": topic.id});
    }
  }

  Future<void> clearPractice() async {
    var collection = FirebaseFirestore.instance.collection('PracticeCompleted')
        .where("topic", isEqualTo: topic.id).where(
        "user", isEqualTo: user?.uid);
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
              child: Column(
                  children: [
                if(practiceList.isEmpty)
                  endTasks()
                else
                  flag == true ? buildTaskView() : buildResultView()

              ]))),
    );
  }


  // Column buildNoTasksView() {
  //   return const Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Padding(
  //         padding: EdgeInsets.all(10.0),
  //         child: Text("You completed all available practice questions",style: TextStyle(fontSize: 22),),
  //       )
  //     ],
  //   );
  // }

  SingleChildScrollView buildResultView() {
    return SingleChildScrollView(
        child: Column(
          children: [
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //
            //   ],
            // ),
            Text(correct == true ? "correct" : "incorrect"),
            Math.tex(practiceList[index].result, mathStyle: MathStyle.display),
            Math.tex(
                practiceList[index].solutions, mathStyle: MathStyle.display),
            if(practiceList[index].resultImg!="") CachedNetworkImage(
              imageUrl: practiceList[index].resultImg,
              placeholder: (context,url)=> const CircularProgressIndicator(),
            ),
            const Text("Your result, if read from photo, if not from input"),
            if(index + 1 < practiceList.length)
              nextTask()
            else
              endTasks()


          ],
        ));
  }

  Column endTasks() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(margin: const EdgeInsets.all(15),
            child: const Text("You finished all practice questions!",style: TextStyle(fontSize: 22),textAlign: TextAlign.center,)),
        ElevatedButton(onPressed: () {
          Navigator.of(context).pop();
        }, child: const Text("Quit",style: TextStyle(fontSize: 20),)),
        ElevatedButton(onPressed: () {
          clearPractice();
          setState(() {});
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Practice(topic: topic,)));
          ;
        }, child: const Text("Start over?",style: TextStyle(fontSize: 20)))
      ],
    );
  }

  Column nextTask() {
    return Column(
      children: [
        ElevatedButton(onPressed: () {
          flag = true;
          correct = false;
          if (index + 1 < practiceList.length) {
            index += 1;
            print(index);
          }
          setState(() {});
        }, child: const Text("Next")),
        if (!correct)
          ElevatedButton(onPressed: () {
            flag = true;
            setState(() {});
          }, child: const Text("Try again?"))
      ],
    );
  }

  SingleChildScrollView buildTaskView() {
    late final inputController = MathFieldEditingController();
    late String solution;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(practiceList[index].content, style: TextStyle(fontSize: 18),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Math.tex(practiceList[index].equation, mathStyle: MathStyle.display,textStyle: TextStyle(fontSize: 20),),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child:Column(
              children: [
                if (practiceList[index].img!= "")SizedBox(
                  height: MediaQuery.of(context).size.height*0.25,
                  child: CachedNetworkImage(
                    imageUrl: practiceList[index].img,
                    placeholder: (context,url)=> const CircularProgressIndicator(),
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
                hintText: "Your solution",
              ),
              // Decorate the input field using the familiar InputDecoration.
              onChanged: (String value) {},
              // Respond to changes in the input field.
              onSubmitted: (String value) {
                mathInput = value;

              },
              // Respond to the user submitting their input.
              autofocus: false, // Enable or disable autofocus of the input field.
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
                onPressed: () {},
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.camera_alt_rounded),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text("submit photo of solution"),
                    )
                  ],
                )),
          ),
          Container(
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () {
                    print(practiceList[index].result);
                    if (mathInput == practiceList[index].result) {
                      correct = true;
                      addPractice(practiceList[index].id);
                    }
                    flag = false;
                    setState(() {});
                  },
                  child: const Text("Submit answer")))
        ],
      ),
    );
  }
}
//text
//math render
//image
//math input
//camera input
