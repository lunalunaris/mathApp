import 'dart:convert';
import 'dart:ffi';

class Topic{

  late final String id;
  late final String name;
  late final String sectionId;
  late final Bool completed;

  Topic({
    required this.id,
    required this.name,
    required this.sectionId,
    required this.completed
  });


  Topic.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        sectionId = result["sectionId"],
        completed = result["completed"];
  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'sectionId': sectionId,
      'completed': completed
    };
  }

}