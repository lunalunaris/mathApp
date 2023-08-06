import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedQuizModel{

  late final String quizId;
  late final String userId;
  late final String section;
  CompletedQuizModel({
    required this.quizId,
    required this.userId,
    required this.section
  });

  CompletedQuizModel.fromMap(Map<String, dynamic> result)
      : quizId = result["quizId"],
        userId = result["userId"],
        section = result["section"];
  // solutions = json.decode(result["solutions"]).cast<String>().toList();
  Map<String, Object> toMap() {
    return {
      'quizId': quizId,
      'userId': userId,
      'section' : section
    };
  }
  factory CompletedQuizModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return CompletedQuizModel(
        quizId: data?['quizId'],
        userId: data?["userId"],
        section: data?['section']
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if ( quizId!= null) "quizId": quizId,
      if (userId != null) "userId": userId,
      if (section != null) "section": section,

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