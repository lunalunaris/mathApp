

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/TopicModel.dart';

class Practice extends StatefulWidget{
  late TopicModel topic;

  @override
  State<Practice> createState() => _Practice();

  Practice({Key? key, required this.topic}) : super(key: key);

}

class _Practice extends State<Practice>{
  late User? user;
  late TopicModel topic;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final responseController = TextEditingController();
  bool flag=true;
  @override
  void initState(){
    topic=widget.topic;
    user = FirebaseAuth.instance.currentUser;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var responseTxt = responseController.text;
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
            child: Column (
              children: [flag==true?buildSingleChildScrollView() : buildResultView()]
            )

      )
      ),
    );
  }
  SingleChildScrollView buildResultView() {
    return SingleChildScrollView(child: Container(
      child: Column(
        children: [
          Text(flag==true?"correct":"incorrect"),
          Text("true result (convert to tex)"),
          Text("suggested solutions (convert to tex)"),
          Text("Your result, if read from photo, if not from input"),
          ElevatedButton(onPressed: (){}, child: Text("Next")),
          if(!flag)
            ElevatedButton(onPressed: (){}, child: Text("Try again?"))
        ],
      ),
    ));
  }


  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
            child: Column(
              children: [
                Text("example task"),
                //math render
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),),
                  child: Image.network("https://mathmonks.com/wp-content/uploads/2020/03/Triangle.jpg"),

                ),
                TextFormField(
                  controller: responseController,
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: ElevatedButton(onPressed: (){}, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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
                  margin: EdgeInsets.only(top: 30),
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(onPressed: (){ flag=false;  setState(() {});}, child: Text("Submit answer")))
              ],
            )
            ,
          );
  }

}
//text
//math render
//image
//math input
//camera input