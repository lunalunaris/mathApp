import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QuizModel {
  late final String id;
  late final String topicId;
  late final String section;
  late final String level;
  late final String content;
  late final String equation;
  late final String img;
  late final String result;
  late final String solutions;
  late final String lang;

  QuizModel(
      {required this.id,
      required this.topicId,
      required this.section,
      required this.content,
      required this.equation,
      required this.img,
      required this.result,
      required this.solutions});

  QuizModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        topicId = result["topicId"],
        section = result["section"],
        content = result["content"],
        equation = result["equation"],
        img = result["img"],
        result = result["result"],
        solutions = result["solutions"];

  // solutions = json.decode(result["solutions"]).cast<String>().toList();
  Map<String, Object> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'section': section,
      'content': content,
      'equation': equation,
      'img': img,
      'result': result,
      'solutions': solutions,
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
      section: data?['section'],
      content: data?['content'],
      equation: data?['equation'],
      img: data?["img"],
      result: data?['result'],
      solutions: data?['solutions'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (topicId != null) "topicId": topicId,
      if (section != null) "section": section,
      if (content != null) "content": content,
      if (equation != null) "equation": equation,
      if (img != null) "img": img,
      if (result != null) "result": result,
      if (solutions != null) "solutions": solutions,
    };
  }
}
