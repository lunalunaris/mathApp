// import 'dart:math';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:math/Model/CompletedTopicModel.dart';
// import 'package:math/Model/PracticeModel.dart';
// import 'package:math/Model/QuizModel.dart';
// import 'package:math/Model/TheoryModel.dart';
// import 'package:math/Model/CompletedSectionsModel.dart';
// import 'package:math/Model/SectionModel.dart';
//
// import '../Model/TopicModel.dart';
//
// class FirestoreHandler {
//   FirebaseFirestore db = FirebaseFirestore.instance;
//
//   FirestoreHandler();
//
//   Future<TopicModel?> getTopicById(String id) async {
//     TopicModel? topic;
//     final ref = db.collection("Topic").doc(id).withConverter(
//           fromFirestore: TopicModel.fromFirestore,
//           toFirestore: (TopicModel _topic, _) => _topic.toFirestore(),
//         );
//     final docSnap = await ref.get();
//     topic = docSnap.data()!;
//     if (topic != null) {
//       print(topic.id);
//       return topic;
//     } else {
//       print("No such document.");
//       return null;
//     }
//   }
//
//   //Getters
//
//   Future<List<SectionModel>> getSections(String level, String lang) async {
//     List<SectionModel> sections = [];
//     db
//         .collection("Section")
//         .where("level", isEqualTo: level)
//         .where("lang", isEqualTo: lang)
//         .get()
//         .then((querySnapshot) {
//       print("sections by level completed");
//       for (var docSnapshot in querySnapshot.docs) {
//         sections.add(SectionModel(
//             id: docSnapshot.id,
//             name: docSnapshot.data()["name"],
//             level: docSnapshot.data()["level"],
//             lang: docSnapshot.data()["lang"]));
//         print(sections[0]);
//       }
//     }, onError: (e) => print("Error fetching sections by level"));
//     return sections;
//   }
//   // Future<List<dynamic>> getCollection( String section, String lang) async {
//   //   try {
//   //     QuerySnapshot snapshot = await db
//   //         .collection("Topic")
//   //         .where("section", isEqualTo: section)
//   //         .where("lang", isEqualTo: lang)
//   //         .get();
//   //     List<dynamic> result =  snapshot.docs.map((doc) => doc.data()).toList();
//   //     return result;
//   //   } catch (error) {
//   //     print(error);
//   //     return null;
//   //   }
//   // }
//   Future<List<TopicModel>?> getTopicsBySection(
//       String section, String lang) async {
//     db
//         .collection("Topic")
//         .where("section", isEqualTo: section)
//         .where("lang", isEqualTo: lang)
//         .get()
//         .then((querySnapshot) {
//       print("topics by section completed");
//       List<TopicModel> topics = [];
//       // print(querySnapshot.toString());
//       for (var docSnapshot in querySnapshot.docs) {
//         print(docSnapshot.data());
//         topics.add(TopicModel(
//             id: docSnapshot.id,
//             name: docSnapshot.data()["name"],
//             lang: docSnapshot.data()["lang"],
//             sectionId: docSnapshot.data()["section"]));
//         print(topics.length);
//         return topics;
//       }
//     }, onError: (e) => print("Error fetching topics by section"));
//     return null;
//   }
//
//   Future<List<String>> getCompletedSections(String user, String section) async {
//     List<String> sectionIds = [];
//     db
//         .collection("SectionQuizCompleted")
//         .where("sectionId", isEqualTo: section)
//         .where("userId", isEqualTo: user)
//         .get()
//         .then((querySnapshot) {
//       print("completed sections retrieved");
//       for (var docSnapshot in querySnapshot.docs) {
//         sectionIds.add(docSnapshot.data()["sectionId"]);
//         print(sectionIds[0]);
//       }
//     }, onError: (e) => print("Error fetching completed sections"));
//     return sectionIds;
//   }
//
//   Future<bool> isSectionCompleted(String id, String userId) async {
//     try {
//       var doc = await db
//           .collection('SectionQuizCompleted')
//           .where("sectionId", isEqualTo: id)
//           .where("userId", isEqualTo: userId)
//           .get();
//       return doc.docs.isNotEmpty;
//     } catch (e) {
//       throw e;
//     }
//   }
//
//   Future<bool> istopicCompleted(String id, String userId) async {
//     try {
//       var doc = await db
//           .collection('TopicQuizCompleted')
//           .where("topicId", isEqualTo: id)
//           .where("userId", isEqualTo: userId)
//           .get();
//       return doc.docs.isNotEmpty;
//     } catch (e) {
//       throw e;
//     }
//   }
//
//   Future<List<TheoryModel>> getTheoryByTopic(String topic) async {
//     List<TheoryModel> theory = [];
//     db.collection("Theory").where("topicId", isEqualTo: topic).get().then(
//         (querySnapshot) {
//       print("theory by topic completed");
//       for (var docSnapshot in querySnapshot.docs) {
//         theory.add(TheoryModel(
//             id: docSnapshot.id,
//             img: docSnapshot.data()["img"],
//             topicId: docSnapshot.data()["topicId"]));
//         print(theory[0]);
//       }
//     }, onError: (e) => print("Error fetching theory by topic"));
//     return theory;
//   }
//
//   Future<List<PracticeModel>> getPracticeByTopic(String topic) async {
//     List<PracticeModel> practice = [];
//     db.collection("Practice").where("topicId", isEqualTo: topic).get().then(
//         (querySnapshot) {
//       print("practice by topic completed");
//       for (var docSnapshot in querySnapshot.docs) {
//         practice.add(PracticeModel(
//             id: docSnapshot.id,
//             topicId: docSnapshot.data()["topicId"],
//             content: docSnapshot.data()["content"],
//             equation: docSnapshot.data()["equation"],
//             img: docSnapshot.data()["img"],
//             result: docSnapshot.data()["result"],
//             resultImg: docSnapshot.data()["resultImg"],
//             solutions: docSnapshot.data()["solutions"]));
//         print(practice[0]);
//       }
//     }, onError: (e) => print("Error fetching practice by topic"));
//     return practice;
//   }
//
//   Future<List<QuizModel>> getQuizByTopic(String topic) async {
//     List<QuizModel> quiz = [];
//     db.collection("Quiz").where("topicId", isEqualTo: topic).get().then(
//         (querySnapshot) {
//       print("quiz by topic completed");
//       for (var docSnapshot in querySnapshot.docs) {
//         quiz.add(QuizModel(
//             id: docSnapshot.id,
//             topicId: docSnapshot.data()["topicId"],
//             section: docSnapshot.data()["section"],
//             content: docSnapshot.data()["content"],
//             equation: docSnapshot.data()["equation"],
//             img: docSnapshot.data()["img"],
//             result: docSnapshot.data()["result"],
//             solutions: docSnapshot.data()["solutions"]));
//         print(quiz[0]);
//       }
//     }, onError: (e) => print("Error fetching quiz by topic"));
//     return quiz;
//   }
//
//   Future<List<QuizModel>> getQuizBySection(String section) async {
//     List<QuizModel> quiz = [];
//     db.collection("Quiz").where("section", isEqualTo: section).get().then(
//         (querySnapshot) {
//       print("quiz by section completed");
//       for (var docSnapshot in querySnapshot.docs) {
//         quiz.add(QuizModel(
//             id: docSnapshot.id,
//             topicId: docSnapshot.data()["topicId"],
//             section: docSnapshot.data()["section"],
//             content: docSnapshot.data()["content"],
//             equation: docSnapshot.data()["equation"],
//             img: docSnapshot.data()["img"],
//             result: docSnapshot.data()["result"],
//             solutions: docSnapshot.data()["solutions"]));
//         print(quiz[0]);
//       }
//     }, onError: (e) => print("Error fetching quiz by section"));
//     return quiz;
//   }
//
//   //Setters
//   Future<void> addTheory(TheoryModel theory) async {
//     db.collection("Theory").add(theory.toFirestore()).then((documentSnapshot) =>
//         print("Added Data with ID: ${documentSnapshot.id}"));
//   }
//
//   Future<void> addPractice(PracticeModel practice) async {
//     db.collection("Practice").add(practice.toFirestore()).then(
//         (documentSnapshot) =>
//             print("Added Data with ID: ${documentSnapshot.id}"));
//   }
//
//   Future<void> addQuiz(QuizModel quiz) async {
//     db.collection("Quiz").add(quiz.toFirestore()).then((documentSnapshot) =>
//         print("Added Data with ID: ${documentSnapshot.id}"));
//   }
//
//   Future<void> addTopic(TopicModel topic) async {
//     db.collection("Topic").add(topic.toFirestore()).then((documentSnapshot) =>
//         print("Added Data with ID: ${documentSnapshot.id}"));
//   }
//
//   Future<void> addSection(SectionModel section) async {
//     db.collection("Section").add(section.toFirestore()).then(
//         (documentSnapshot) =>
//             print("Added Data with ID: ${documentSnapshot.id}"));
//   }
//
//   Future<void> addCompletedSection(CompletedSectionsModel section) async {
//     db.collection("SectionQuizCompleted").add(section.toFirestore()).then(
//         (documentSnapshot) =>
//             print("Added Data with ID: ${documentSnapshot.id}"));
//   }
//
//   Future<void> addCompletedTopic(CompletedTopicModel topic) async {
//     db.collection("TopicQuizCompleted").add(topic.toFirestore()).then(
//         (documentSnapshot) =>
//             print("Added Data with ID: ${documentSnapshot.id}"));
//   }
//
//   // Update
//   Future<void> updateElement(
//       String collection, String id, Map<String, String> changes) async {
//     db.collection(collection).doc(id).set(changes);
//   }
//
//   //Delete
//
//   Future<void> removeElement(String collection, String id) {
//     return db.collection(collection).doc(id).delete();
//   }
// }
//
// // if time add favourite and flagged quiz/practice and flagged review for admin
// // List<Topic> topics =[];
// // db.collection("Topic").get().then(
// //       (querySnapshot) {
// //     print("Successfully completed");
// //     for (var docSnapshot in querySnapshot.docs) {
// //       topics.add(Topic(id: docSnapshot.id, name: docSnapshot.data()["name"], sectionId: docSnapshot.data()["section"], level: docSnapshot.data()["level"]));
// //       print(topics[0]);
// //     }
// //   },
// //   onError: (e) => print("Error completing: $e"),
// // );
//
// // Future<Topic?> getTopics() async {
// //   FirebaseFirestore db = FirebaseFirestore.instance;
// //   final ref = db.collection("Topic").doc("di5oYBaHX4PjAmIBnu4K").withConverter(
// //     fromFirestore: Topic.fromFirestore,
// //     toFirestore: (Topic city, _) => city.toFirestore(),
// //   );
// //   final docSnap = await ref.get();
// //   topic = docSnap.data()!; // Convert to City object
// //   if (topic != null) {
// //     print(topic.id);
// //     return topic;
// //   } else {
// //     print("No such document.");
// //     return null;
// //   }
// // List<Topic> topics =[];
// // db.collection("Topic").get().then(
// //       (querySnapshot) {
// //     print("Successfully completed");
// //     for (var docSnapshot in querySnapshot.docs) {
// //       topics.add(Topic(id: docSnapshot.id, name: docSnapshot.data()["name"], sectionId: docSnapshot.data()["section"], level: docSnapshot.data()["level"]));
// //       print(topics[0]);
// //     }
// //   },
// //   onError: (e) => print("Error completing: $e"),
// // );
//
// //
// // FirebaseFirestore db = FirebaseFirestore.instance;
// // // db.collection("cities").doc("new-city-id2").set({"name": "Osaka"});
// // // final data = {"name": "Warsaw", "country": "Poland"};
// // //
// // // db.collection("cities").add(data).then((documentSnapshot) =>
// // //     print("Added Data with ID: ${documentSnapshot.id}"));
// // db.collection("cities").doc("new-city-id2").set({"name": "Osaka"});
// // final data = {"name": "Warsaw", "country": "Poland"};
// //
// // db.collection("cities").add(data).then((documentSnapshot) =>
// //     print("Added Data with ID: ${documentSnapshot.id}"));
