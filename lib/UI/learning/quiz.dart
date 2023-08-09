import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/TopicModel.dart';

class Quiz extends StatefulWidget {
  late TopicModel topic;

  @override
  State<Quiz> createState() => _Quiz();

  Quiz({Key? key, required this.topic}) : super(key: key);

}

class _Quiz extends State<Quiz> {
  late User? user;
  late TopicModel topic;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final responseController = TextEditingController();
  bool flag = true;

  @override
  void initState() {
    topic = widget.topic;
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var responseTxt = responseController.text;
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
                  children: [buildSingleChildScrollView()]
              )

          )
      ),
    );
  }


  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          //add question progress bar if time
          Text("example task"),
          //math render
          Container(
            margin: EdgeInsets.only(top: 20),
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),),
            child: Image.network(
                "https://mathmonks.com/wp-content/uploads/2020/03/Triangle.jpg"),

          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [Container(margin: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                  style: ButtonStyle(
                    // backgroundColor: flag=="corect"?Colors.lime:Colors.
                  ),
                  onPressed: () {},
                  child: Row(children: [Text("A: "), Text("solution 1")],),
                )
                  ,),
                  Container(child: ElevatedButton(
                    onPressed: () {},
                    child: Row(children: [Text("B: "), Text("solution 2")],),
                  )
                    ,),
                ],),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Container(margin: EdgeInsets.only(right: 10),child: ElevatedButton(
                  onPressed: () {},
                  child: Row(children: [Text("C: "), Text("solution 3")],),
                )
                  ,),
                  Container(child: ElevatedButton(
                    onPressed: () {},
                    child: Row(children: [Text("D: "), Text("solution 4")],),
                  )
                    ,),],)
              ]
          ),
      Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(8),
          child: ElevatedButton(onPressed: () {
            flag = false;
            setState(() {});
          }, child: Text("Submit answer")))
      ],
    ));
  }

}
//text
//math render
//image
//math input
//camera input