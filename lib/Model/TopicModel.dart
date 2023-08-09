import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  late final String id;
  late final String name;
  late final String sectionId;
  late final String lang;

  TopicModel.empty();

  TopicModel(
      {required this.id,
      required this.name,
      required this.sectionId,
      required this.lang});

  factory TopicModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return TopicModel(
      id: snapshot.id,
      name: data?['name'],
      sectionId: data?['section'],
      lang: data?['lang'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (sectionId != null) "section": sectionId,
      if (lang != null) "lang": lang,
    };
  }

  TopicModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        sectionId = result["sectionId"],
        lang = result["lang"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'sectionId': sectionId,
      'lang': lang
    };
  }
}
