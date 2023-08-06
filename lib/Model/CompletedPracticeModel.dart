import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedPracticeModel{

  late final String practiceId;
  late final String userId;
  late final String section;
  CompletedPracticeModel({
    required this.practiceId,
    required this.userId,
    required this.section
  });

  CompletedPracticeModel.fromMap(Map<String, dynamic> result)
      : practiceId = result["practiceId"],
        userId = result["userId"],
        section = result["section"];
  // solutions = json.decode(result["solutions"]).cast<String>().toList();
  Map<String, Object> toMap() {
    return {
      'practiceId': practiceId,
      'userId': userId,
      'section' : section
    };
  }
  factory CompletedPracticeModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return CompletedPracticeModel(
        practiceId: data?['practiceId'],
        userId: data?["userId"],
        section: data?['section']
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if ( practiceId!= null) "practiceId": practiceId,
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