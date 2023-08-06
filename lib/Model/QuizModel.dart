import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel{

  late final String id;
  late final String topicId;
  late final String section;
  late final String level;
  late final String content;
  late final String equation;
  late final String img;
  late final String result;
  late final String a;
  late final String b;
  late final String c;
  late final String d;
  QuizModel({
    required this.id,
    required this.topicId,
    required this.section,
    required this.content,
    required this.equation,
    required this.img,
    required this.result,
    required this.a,
    required this.b,
    required this.c,
    required this.d,
});


  QuizModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        topicId = result["topicId"],
        section = result["section"],
        content = result["content"],
        equation = result["equation"],
        img = result["img"],
        result = result["result"],
        a= result["a"],
        b = result["b"],
        c= result["c"],
        d = result["d"];
  // solutions = json.decode(result["solutions"]).cast<String>().toList();
  Map<String, Object> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'section' : section,

      'content': content,
      'equation' : equation,
      'img': img,
      'result' : result,
      'a': a,
      'b' : b,
      'c': c,
      'd' : d
    };
  }
  factory QuizModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return QuizModel(
      id: snapshot.id,
      topicId: data?['topicId'],
      section : data?['section'],
      content: data?['content'],
      equation: data?['equation'],
      img: data?["img"],
      result: data?['result'],
      a: data?['a'],
      b: data?['b'],
      c: data?['c'],
      d: data?['d'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if ( topicId!= null) "topicId": topicId,
      if (section!=null) "section" : section,
      if (content != null) "content": content,
      if (equation != null) "equation": equation,
      if (img != null) "img": img,
      if (result != null) "result": result,
      if (a != null) "a": a,
      if (b != null) "b": b,
      if (c != null) "c": c,
      if (d != null) "d": d,

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