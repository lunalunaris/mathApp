import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LevelChoice extends StatefulWidget {
  LevelChoice({
    Key? key,
  }) : super(key: key);

  @override
  State<LevelChoice> createState() => _LevelChoiceState();
}

class _LevelChoiceState extends State<LevelChoice> {
  late User? user;
  FirebaseFirestore db = FirebaseFirestore.instance;
  var levelList = {
    "Szkoła podstawowa 1-3": "0",
    "Szkoła podstawowa 4-6": "1",
    "Szkoła podstawowa 7-8": "2",
    "Szkoła średnia poziom podstawowy": "3",
    "Skoła średnia poziom rozszerzony": "4"
  };

  selectLevel(String level) {
    print(user?.uid);
    addLevel(levelList[level]!);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Learning()));
  }

  Future<void> addLevel(String level) async {
    db.collection("UserLevel").doc(user?.uid).set({"level": level});
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Choose level"),
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
            )
          ),
          child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(0.8),
              ),
              child: ListView(
                children: [
                  Container(padding: EdgeInsets.all(10),alignment: Alignment.center,
                      child: Text("Choose class", style:
                      TextStyle(fontSize: 20,
                          fontWeight: FontWeight.bold,color: Colors.teal.withOpacity(0.7)),)),
                  const Divider(height: 0,indent: 40, endIndent: 40,color: Colors.teal,),
              for (var i in  levelList.keys)
                  Column(
      children: [
                    ListTile(
      leading: const Icon(Icons.sailing_rounded),
      title: TextButton(
          onPressed: () {selectLevel(i);},
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.1)),
              overlayColor: MaterialStateProperty.all(
                  Colors.pinkAccent.withOpacity(0.3)),
              shape: MaterialStateProperty.all<
                  RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(5)),
                  ))),
          child: Text(
            i,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
            textAlign: TextAlign.center,
          )),

    ),
    const Divider(height: 0),
    ])
     ] )
    )
    ),
    );
  }
}
//     Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// const Text(
// "Choose your class",
// style: TextStyle(
// fontSize: 30,
// fontWeight: FontWeight.bold,
// color: Colors.pink),
// ),
// const SizedBox(
// height: 30,
// ),
// Table(
// children: [
// for (var item in)
// TableRow(children: [
// ElevatedButton(
// onPressed: () {
// selectLevel(item);
// },
// style: ButtonStyle(
// padding:
// MaterialStateProperty.all<EdgeInsets>(
// const EdgeInsets.all(15)),
// backgroundColor:
// MaterialStateProperty.all(Colors.teal),
// shape: MaterialStateProperty.all<
//     RoundedRectangleBorder>(
// const RoundedRectangleBorder(
// borderRadius: BorderRadius.zero,
// ))),
// child: Text(
// item,
// softWrap: true,
// textAlign: TextAlign.center,
// style: const TextStyle(
// fontSize: 25,
// fontWeight: FontWeight.bold),
// ))
// ]),
// ],
// )
