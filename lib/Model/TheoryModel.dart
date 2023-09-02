import 'package:cloud_firestore/cloud_firestore.dart';

class TheoryModel {
  late final String id;
  late final String topicId;
  late final String img;

  TheoryModel(
      {required this.id,
      required this.topicId,
      required this.img,});

  TheoryModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        topicId = result["topicId"],
        img = result["img"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'img': img,
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
        img: data?["img"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (topicId != null) "topicId": topicId,
      if (img != null) "img": img,
    };
  }
}
