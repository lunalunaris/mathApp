

import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/TopicModel.dart';

class FirestoreHandler{
   FirebaseFirestore db=FirebaseFirestore.instance;

  FirestoreHandler();

   Future<TopicModel?> getTopicById() async {
     TopicModel? topic;
     final ref = db.collection("Topic")
         .doc("di5oYBaHX4PjAmIBnu4K")
         .withConverter(
       fromFirestore: TopicModel.fromFirestore,
       toFirestore: (TopicModel city, _) => city.toFirestore(),
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
   }
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