import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:math/UI/admin/admin_init.dart';
import 'package:path/path.dart';

import '../../Model/TheoryModel.dart';
import '../../generated/l10n.dart';

class UploadTheory extends StatefulWidget {
  late String container;

  @override
  State<UploadTheory> createState() => _UploadTheory();

  UploadTheory({Key? key, required this.container})
      : super(key: key);
}

class _UploadTheory extends State<UploadTheory> {
  late User? user;
  late String container;

  FirebaseFirestore db = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  List<File> selectedTheoryImg = [];
  final ImagePicker imagePicker = ImagePicker();




  @override
  void initState() {
    container = widget.container;
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  Future<void> addTheory(TheoryModel theory) async {
    db.collection("Theory").add(theory.toFirestore()).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:  Text(S.of(context).theory),
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
                  buildTheoryView(context)
              ]))),
    );
  }





  Future getTheoryPhotos(BuildContext context) async{
    final files = await imagePicker.pickMultiImage(
        maxWidth: 500,
        maxHeight: 500
    );
    List<XFile> filePick= files;
    if(filePick.isNotEmpty){
      for (var i in filePick){
        selectedTheoryImg.add(File(i.path));
      }
      setState(() {
      });
      // submitTheory();
    }
    else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')));
    }
  }
  submitTheory(BuildContext context) async {
    for(var i in selectedTheoryImg){
      final name = basename(i.path);
      final dest = 'theory/$name';
      try {
        var snapshot = await storage.ref(dest).putFile(i);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        TheoryModel theory =
        TheoryModel(id: "none", topicId: container, img: downloadUrl);
        addTheory(theory);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(S.of(context).theorySubmittedSuccessfully)));
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(S.of(context).submissionFailed)));
      }
    }
  }
  Future<void> getTheoryFromCamera(BuildContext context) async {
    final files = await imagePicker.pickImage(source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500
    );
    XFile? filePick= files;
    if(filePick !=null){
      selectedTheoryImg.add(File(filePick.path));
      setState(() {
      });
    }
    else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(S.of(context).nothingIsSelected)));
    }
  }
  Expanded buildTheoryView(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(S.of(context).uploadTheoryImages, style: const TextStyle(
              fontSize: 20,fontWeight: FontWeight.bold
            ),),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                getTheoryPhotos(context);
                setState(() {});
              },
              label:  Text(S.of(context).fromGallery),
              backgroundColor: Colors.pink.shade800,
              icon: const Icon(Icons.add_a_photo_rounded),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                getTheoryFromCamera(context);
                setState(() {});
              },
              label:  Text(S.of(context).fromCamera),
              backgroundColor: Colors.pink.shade800,
              icon: const Icon(Icons.add_a_photo_rounded),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                if(selectedTheoryImg.isNotEmpty){
                  submitTheory(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(S.of(context).filesSubmitted)));
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminInit(
                          )));
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text(S.of(context).nothingIsSelected)));
                }
              },
              child:  Text(S.of(context).submit)),
          Column(
            children: [
              for (var i in selectedTheoryImg)
            SizedBox(width: 200, height: 100,child: Image.file(i)),
            ],),

        ],
      )),
    );
  }




}

