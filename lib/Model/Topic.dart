import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';


class Topic {
  late final String id;
  late final String name;
  late final String sectionId;
  late final String level;
  Topic.empty();
  Topic({
    required this.id,
    required this.name,
    required this.sectionId,
    required this.level
  });

  factory Topic.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Topic(
      id: snapshot.id,
      name: data?['name'],
      sectionId: data?['section'],
      level: data?['level'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (sectionId != null) "section": sectionId,
      if (level != null) "level": level,

    };
  }

  Topic.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        sectionId = result["sectionId"],
        level = result["level"];
  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'sectionId': sectionId,
      'level': level
    };
  }

}