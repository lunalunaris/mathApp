import 'package:cloud_firestore/cloud_firestore.dart';

class SectionModel {
  late final String id;
  late final String name;
  late final String level;
  late final String lang;

  SectionModel(
      {required this.id,
      required this.name,
      required this.level,
      required this.lang});

  SectionModel.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        level = result["level"],
        lang = result["lang"];

  SectionModel.fromDbMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        level = result["level"];

  Map<String, Object> toMap() {
    return {'id': id, 'name': name, 'level': level, 'lang': lang};
  }
  Map<String, Object> toDbMap(){
    return {'id': id, 'name': name, 'level': level};
  }

  factory SectionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return SectionModel(
      id: snapshot.id,
      name: data?['name'],
      level: data?['level'],
      lang: data?['lang'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (level != null) "level": level,
      if (lang != null) "section": lang,
    };
  }
}
