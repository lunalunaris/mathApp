import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LevelChoice extends StatefulWidget {
  late User? user;

  LevelChoice({Key? key, required this.user}) : super(key: key);

  @override
  State<LevelChoice> createState() => _LevelChoiceState();
}

class _LevelChoiceState extends State<LevelChoice> {
  late User? user;

  selectLevel(String level) {
    //push to database user's level choice

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Learning(
                  user: user
                )));
  }

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var levelList = [
      "Szkoła podstawowa 1-3",
      "Szkoła podstawowa 4-6",
      "Szkoła podstawowa 7-8",
      "Szkoła średnia poziom podstawowy",
      "Skoła średnia poziom rozszerzony"
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose level"),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Text("Choose your class",                      style:
            TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.pink),),
        SizedBox(height: 30,),
        Table(
          children: [
            for (var item in levelList)
              TableRow(children: [
                ElevatedButton(
                    onPressed: () {
                      selectLevel(item);
                    },
                    style: ButtonStyle(

                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(15)),
                        //
                        backgroundColor: MaterialStateProperty.all(Colors.teal),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ))),
                    child:  Text(
                      item,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ))
              ]),

          ],
        )
      ])),
    );
  }
}
