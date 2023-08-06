import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeModel{

  late final String id;
  late final String topicId;
  late final String content;
  late final String equation;
  late final String img;
  late final String result;
  late final String resultImg;
  late final String solutions;
  late final String section;
  PracticeModel({
    required this.id,
    required this.topicId,
    required this.content,
    required this.equation,
    required this.img,
    required this.result,
    required this.resultImg,
    required this.solutions,
    required this.section
  });

  PracticeModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        topicId = result["topicId"],
        content = result["content"],
        equation = result["equation"],
        img = result["img"].
        result = result["result"],
        resultImg= result["resultImg"],
        solutions = result["solutions"],
        section = result["section"];
        // solutions = json.decode(result["solutions"]).cast<String>().toList();
  Map<String, Object> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'content': content,
      'equation' : equation,
      'img': img,
      'result' : result,
      'resultImg': resultImg,
      'solutions' : solutions,
      'section' : section
    };
  }
  factory PracticeModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return PracticeModel(
      id: snapshot.id,
      topicId: data?['topicId'],
      content: data?['content'],
      equation: data?['equation'],
      img: data?["img"],
      result: data?['result'],
      resultImg: data?['resultImg'],
      solutions: data?['solutions'],
      section: data?['section']
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if ( topicId!= null) "topicId": topicId,
      if (content != null) "content": content,
      if (equation != null) "equation": equation,
      if (img != null) "img": img,
      if (result != null) "result": result,
      if (resultImg != null) "resultImg": resultImg,
      if (solutions != null) "solutions": solutions,
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