import 'package:cloud_firestore/cloud_firestore.dart';

class TheoryModel {
  late final String id;
  late final String topicId;
  late final String img;
  late final String section;
  late final String lang;

  TheoryModel(
      {required this.id,
      required this.topicId,
      required this.img,
      required this.section,
      required this.lang});

  TheoryModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        topicId = result["topicId"],
        img = result["img"],
        section = result["section"],
        lang = result["lang"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'img': img,
      'section': section,
      'lang': lang
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
        section: data?['section'],
        lang: data?['lang']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (topicId != null) "topicId": topicId,
      if (img != null) "img": img,
      if (section != null) "section": section,
      if (lang != null) "lang": lang,
    };
  }
}
