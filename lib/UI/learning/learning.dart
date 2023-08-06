import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../../Model/Topic.dart';

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
  late Topic topic= Topic(id: "none",name: "loading...",sectionId: "none",level: "none");

  @override
  void initState()  {

    user = widget.user;
    level = "t";
    initAppointmentList();
    super.initState();
  }
  initAppointmentList() async {
    await getTopics();
    setState(() {});
  }

  Future<Topic?> getTopics() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final ref = db.collection("Topic").doc("di5oYBaHX4PjAmIBnu4K").withConverter(
      fromFirestore: Topic.fromFirestore,
      toFirestore: (Topic city, _) => city.toFirestore(),
    );
    final docSnap = await ref.get();
    topic = docSnap.data()!; // Convert to City object
    if (topic != null) {
      print(topic.id);
      return topic;
    } else {
      print("No such document.");
      return null;
    }
    // List<Topic> topics =[];
    // db.collection("Topic").get().then(
    //       (querySnapshot) {
    //     print("Successfully completed");
    //     for (var docSnapshot in querySnapshot.docs) {
    //       topics.add(Topic(id: docSnapshot.id, name: docSnapshot.data()["name"], sectionId: docSnapshot.data()["section"], level: docSnapshot.data()["level"]));
    //       print(topics[0]);
    //     }
    //   },
    //   onError: (e) => print("Error completing: $e"),
    // );




    }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning"),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(topic.name,
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink))
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