import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedQuizModel{

  late final String section;
  late final String userId;
  CompletedQuizModel({
    required this.section,
    required this.userId,

  });

  CompletedQuizModel.fromMap(Map<String, dynamic> result)
      : section = result["section"],
        userId = result["userId"];
  // solutions = json.decode(result["solutions"]).cast<String>().toList();
  Map<String, Object> toMap() {
    return {
      'section': section,
      'userId': userId,
    };
  }
  factory CompletedQuizModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return CompletedQuizModel(
        section: data?['section'],
        userId: data?["userId"],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if ( section!= null) "section": section,
      if (userId != null) "userId": userId,
    };
  }


// String getpracticeId(){
//   return practiceId;
// }
// String getTopic(){
//   return topicpracticeId;
// }
// String getContent(){
//   return content;
// }
// String getImg(){
//   return img;
// }
// String getResult(){
//   return result;
// }
// List<String> getSolutions(){
//   return solutions;
// }

}