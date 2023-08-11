
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:math/UI/learning/learning.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminInit extends StatefulWidget {
  AdminInit({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminInit> createState() => _AdminInitState();
}

class _AdminInitState extends State<AdminInit> {
  late User? user;

  FirebaseFirestore db = FirebaseFirestore.instance;
  var levelList = {
    "Szkoła podstawowa 1-3": "0",
    "Szkoła podstawowa 4-6": "1",
    "Szkoła podstawowa 7-8": "2",
    "Szkoła średnia poziom podstawowy": "3",
    "Skoła średnia poziom rozszerzony": "4"
  };
  var languageList = ["en_GB", "pl_PL"];
  var typeList = ["section", "topic", "theory", "practice", "quiz"];
  String typeDropdown = "";
  String classDropdown = "";
  String langDropdown = "";

  bool flag = false;
  TextEditingController controller = TextEditingController();

  next() {
    print(typeDropdown);
    if (typeDropdown == "section") {
      flag = true;

      setState(() {});
    }
     else {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ChooseSection(
      //             level: levelList[classDropdown],
      //             lang: langDropdown,
      //             type: typeDropdown)));
    }
  }
  Future<void> addSection() async {
    db.collection("Section").add({"lang": langDropdown,"name": controller.text, "level": levelList[classDropdown]});
  }

  submitToDB(){
    addSection();
    //popup
    flag=false;
    classDropdown = levelList.keys.first;
    langDropdown = languageList.first;
    typeDropdown = typeList.first;
    setState(() {});
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    classDropdown = levelList.keys.first;
    langDropdown = languageList.first;
    typeDropdown = typeList.first;
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
          )),
          child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white.withOpacity(0.8),
              ),
              child: SingleChildScrollView(child: flag?buildInput():buildDropdowns()))),
    );
  }

  Column buildInput() {
    String title = "Submit name for your " + typeDropdown;
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextFormField(
            enableSuggestions: false,
            autocorrect: false,
            controller: controller,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
               )),
        ElevatedButton(onPressed: (){
          submitToDB();
        }, child: Text("Submit"))
      ],
    );
  }

  Column buildDropdowns() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(40),
          child: DropdownButton<String>(
            value: classDropdown,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.pink),
            underline: Container(
              height: 2,
              color: Colors.tealAccent,
            ),
            onChanged: (String? value) {
              classDropdown = value!;
              print(classDropdown);
              setState(() {});
            },
            items: levelList.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Container(
          margin: EdgeInsets.all(40),
          child: DropdownButton<String>(
            value: langDropdown,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.pink),
            underline: Container(
              height: 2,
              color: Colors.tealAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                langDropdown = value!;
              });
            },
            items: languageList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Container(
          margin: EdgeInsets.all(40),
          child: DropdownButton<String>(
            value: typeDropdown,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.pink),
            underline: Container(
              height: 2,
              color: Colors.tealAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                typeDropdown = value!;
                print(typeDropdown);
              });
            },
            items: typeList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ElevatedButton(onPressed: () {next();}, child: Text("Next"))
      ],
    );
  }
}
