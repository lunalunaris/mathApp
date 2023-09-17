import 'package:cloud_firestore/cloud_firestore.dart';

class PracticeModel {
  late final String id;
  late final String topicId;
  late final String content;
  late final String equation;
  late final String img;
  late final String result;
  late final String solutions;
  late final String section;
  late final String lang;
  late final int photoSolution;

  PracticeModel(
      {required this.id,
      required this.topicId,
      required this.content,
      required this.equation,
      required this.img,
      required this.result,
      required this.solutions,
  required this.photoSolution
     });

  PracticeModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        topicId = result["topicId"],
        content = result["content"],
        equation = result["equation"],
        img = result["img"].result = result["result"],
        solutions = result["solutions"],
        photoSolution = result["photoSolution"]
  ;

  Map<String, Object> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'content': content,
      'equation': equation,
      'img': img,
      'result': result,
      'solutions': solutions,
      'photoSolution': photoSolution
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
        solutions: data?['solutions'],
        photoSolution: data?['photoSolution']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (topicId != null) "topicId": topicId,
      if (content != null) "content": content,
      if (equation != null) "equation": equation,
      if (img != null) "img": img,
      if (result != null) "result": result,
      if (solutions!=null) "solutions": solutions,
      if (photoSolution!=null) "photoSolution": photoSolution
    };
  }
}
