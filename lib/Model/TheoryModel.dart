import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class TheoryModel{

  late final String id;
  late final String topicId;
  late final String img;
  late final String section;
  TheoryModel({
    required this.id,
    required this.topicId,
    required this.img,
    required this.section
  });

  TheoryModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        topicId = result["topicId"],
        img = result["img"],
        section = result["section"];
  // solutions = json.decode(result["solutions"]).cast<String>().toList();
  Map<String, Object> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'img': img,
      'section' : section
    };
  }
  factory TheoryModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return TheoryModel(
        id: snapshot.id,
        topicId: data?['topicId'],
        img: data?["img"],
        section: data?['section']
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if ( topicId!= null) "topicId": topicId,
      if (img != null) "img": img,
      if (section != null) "section": section,

    };
  }


// String getId(){
//   return id;
// }
// String getTopic(){
//   return topicId;
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