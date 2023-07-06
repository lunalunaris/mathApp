import 'dart:convert';
import 'dart:ffi';

class Section{

  late final String id;
  late final String name;
  late final String levelId;
  late final Bool completed;

  Section({
    required this.id,
    required this.name,
    required this.levelId,
    required this.completed
  });

  Section.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        levelId = result["levelId"],
        completed = result["completed"];
  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'sectionId': levelId,
      'completed': completed
    };
  }

}