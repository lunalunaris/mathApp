

import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:math/Model/TheoryModel.dart';
import 'package:math/temp/CompletedSectionsModel.dart';
import 'package:math/Model/SectionModel.dart';

import '../Model/TopicModel.dart';

class FirestoreHandler{
   FirebaseFirestore db=FirebaseFirestore.instance;

  FirestoreHandler();

   Future<TopicModel?> getTopicById(String id) async {
     TopicModel? topic;
     final ref = db.collection("Topic")
         .doc(id)
         .withConverter(
       fromFirestore: TopicModel.fromFirestore,
       toFirestore: (TopicModel _topic, _) => _topic.toFirestore(),
     );
     final docSnap = await ref.get();
     topic = docSnap.data()!;
     if (topic != null) {
       print(topic.id);
       return topic;
     } else {
       print("No such document.");
       return null;
     }
   }
   
     //Getters
     
     Future<List<SectionModel>> getSections(String level, String lang) async {
       List<SectionModel> sections =[];
       db.collection("Section").where("level", isEqualTo: level).where("lang",isEqualTo: lang).get().then(
           (querySnapshot) {
             print("sections by level completed");
             for (var docSnapshot in querySnapshot.docs){
               sections.add(SectionModel(id: docSnapshot.id, name: docSnapshot.data()["name"],
                   level: docSnapshot.data()["level"], lang: docSnapshot.data()["lang"]));
               print(sections[0]);
             }
           },
         onError: (e) => print("Error fetching sections by level")
       );
       return sections;
     }
   Future<List<TopicModel>> getTopicsBySection(String section,String lang) async {
     List<TopicModel> topics =[];
     db.collection("Topic").where("section", isEqualTo: section).where("lang",isEqualTo: lang).get().then(
             (querySnapshot) {
           print("topics by section completed");
           for (var docSnapshot in querySnapshot.docs){
             topics.add(TopicModel(id: docSnapshot.id, name: docSnapshot.data()["name"],
                 level: docSnapshot.data()["level"], lang: docSnapshot.data()["lang"], sectionId: docSnapshot.data()["section"]));
             print(topics[0]);
           }
         },
         onError: (e) => print("Error fetching topics by section")
     );
     return topics;
   }

   Future<List<String>> getCompletedSections(String user, String section) async{
     List<String> sectionIds =[];
     db.collection("SectionQuizCompleted").where("sectionId", isEqualTo: section).where("userId",isEqualTo: user).get().then(
             (querySnapshot) {
           print("completed sections retrieved");
           for (var docSnapshot in querySnapshot.docs){
             sectionIds.add(docSnapshot.data()["sectionId"]);
             print(sectionIds[0]);
           }
         },
         onError: (e) => print("Error fetching completed sections")
     );
     return sectionIds;
   }
   Future<bool> isSectionCompleted(String id, String userId) async {
     try {
       var doc = await db.collection('SectionQuizCompleted').where("sectionId", isEqualTo: id).where("userId",isEqualTo: userId).get();
       return doc.docs.isNotEmpty;
     } catch (e) {
       throw e;
     }


   }
   Future<bool> istopicCompleted(String id, String userId) async {
     try {
       var doc = await db.collection('TopicQuizCompleted').where(
           "topicId", isEqualTo: id).where("userId", isEqualTo: userId).get();
       return doc.docs.isNotEmpty;
     } catch (e) {
       throw e;
     }
   }


   Future<List<TheoryModel>> getTheoryByTopic(String topic) async {
     List<TheoryModel> theory =[];
     db.collection("Theory").where("topicId", isEqualTo: topic).get().then(
             (querySnapshot) {
           print("topics by section completed");
           for (var docSnapshot in querySnapshot.docs){
             theory.add(TheoryModel(id: docSnapshot.id, img: docSnapshot.data()["img"], topicId: docSnapshot.data()["topicId"]));
             print(theory[0]);
           }
         },
         onError: (e) => print("Error fetching topics by section")
     );
     return theory;
   }



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
     
     
     
   // Future<Topic?> getTopics() async {
   //   FirebaseFirestore db = FirebaseFirestore.instance;
   //   final ref = db.collection("Topic").doc("di5oYBaHX4PjAmIBnu4K").withConverter(
   //     fromFirestore: Topic.fromFirestore,
   //     toFirestore: (Topic city, _) => city.toFirestore(),
   //   );
   //   final docSnap = await ref.get();
   //   topic = docSnap.data()!; // Convert to City object
   //   if (topic != null) {
   //     print(topic.id);
   //     return topic;
   //   } else {
   //     print("No such document.");
   //     return null;
   //   }
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

//
// FirebaseFirestore db = FirebaseFirestore.instance;
// // db.collection("cities").doc("new-city-id2").set({"name": "Osaka"});
// // final data = {"name": "Warsaw", "country": "Poland"};
// //
// // db.collection("cities").add(data).then((documentSnapshot) =>
// //     print("Added Data with ID: ${documentSnapshot.id}"));
// db.collection("cities").doc("new-city-id2").set({"name": "Osaka"});
// final data = {"name": "Warsaw", "country": "Poland"};
//
// db.collection("cities").add(data).then((documentSnapshot) =>
//     print("Added Data with ID: ${documentSnapshot.id}"));