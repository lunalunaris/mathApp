import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../Model/TopicModel.dart';

import '../settings/settings.dart';

class Learning extends StatefulWidget {
  late User? user;
  late String level;

  Learning({Key? key, required this.user}) : super(key: key);

  @override
  State<Learning> createState() => _Learning();
}

class _Learning extends State<Learning> {
  late User? user;
  late String level;
  late TopicModel topic= TopicModel(id: "none",name: "loading...",sectionId: "none",level: "none", lang: 'en_UK');

  late Map<String,List<TopicModel>> topics= {"section1": [TopicModel(id: "1",name: "topic1",sectionId: "section1",level: "class1", lang: 'en_UK')],
    "section2" : [TopicModel(id: "2",name: "topic3",sectionId: "section2",level: "class1", lang: 'en_UK')],};
  @override
  void initState()  {

    user = widget.user;
    level = "t";
    initAppointmentList();
    super.initState();
  }
  initAppointmentList() async {
    // await getTopics();
    setState(() {});
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning"),
      ),
      body: Center(
          child: Table( children:
            [

          ])),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.teal,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: "Learn",
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.lime,
              icon: Icon(Icons.games),
              label: "Game",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setup",
            ),
          ],
          onTap: (option) {
            developer.log(option.toString());
            switch (option) {
            // case 2:
            //   Navigator.of(context).pop();
            //   Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               Game(user: user)));
            //   break;
              case 2:
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserSettings(user: user)));
                break;
            }
          },
          selectedItemColor: Colors.pink),
    );
  }
}