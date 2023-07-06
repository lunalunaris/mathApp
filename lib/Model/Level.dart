import 'dart:convert';
import 'dart:ffi';

class Level{

  late final String id;
  late final String name;
  late final Bool completed;

  Level({
    required this.id,
    required this.name,
    required this.completed
  });

  Level.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        name = result["name"],
        completed = result["completed"];
  Map<String, Object> toMap() {
    return {
      'id': id,
      'name': name,
      'completed': completed
    };
  }

}