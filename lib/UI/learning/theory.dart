
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math/Model/TopicModel.dart';
import '../../Model/TheoryModel.dart';

class Theory extends StatefulWidget {
  late TopicModel topic;
  @override
  State<Theory> createState() => _Theory();

  Theory({Key? key, required this.topic})
      : super(key: key);

}

class _Theory extends State<Theory> {
  late User? user;
  late TopicModel topic;
  FirebaseFirestore db = FirebaseFirestore.instance;
List<TheoryModel> theory = [];
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    topic = widget.topic;
    // topic=TopicModel(id: "di5oYBaHX4PjAmIBnu4K", name: "Temp", sectionId: "temp", lang: "en_UK");
    initTheoryList();
    super.initState();
  }

  initTheoryList() async{
    await db
        .collection("Theory")
        .where("topicId", isEqualTo: topic.id)
        .get()
        .then((querySnapshot) {
      print("theory by topic completed");
      theory = [];
      for (var docSnapshot in querySnapshot.docs) {
        print(docSnapshot.data());
        theory.add(TheoryModel(
            id: docSnapshot.id,
            img: docSnapshot.data()["img"],
            topicId: docSnapshot.data()["topicId"]));
        print(theory.length);
      }
    }, onError: (e) => print("Error fetching theory by topic"));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
      appBar: AppBar(
        title:  Text(topic.name),
      ),
      body:
     PageView(
      controller: controller,
      children:  <Widget>[
        if(theory.isNotEmpty)
          for(var i in theory)
            Center(
              child: Column(
                children: [
                  if (i.img!= "None")CachedNetworkImage(
                    imageUrl: i.img,
                    placeholder: (context,url)=> const CircularProgressIndicator(),
                  )
                ],
              )
              //Image.network(i.img),
            ),

      ],
    )
    );
  }

}
