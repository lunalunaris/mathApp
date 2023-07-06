import 'dart:convert';
import 'dart:ffi';

class Practice{

  late final String id;
  late final String topicId;
  late final String content;
  late final String img;
  late final String result;
  late final List<String> solutions;
  Practice({
    required this.id,
    required this.topicId,
    required this.content,
    required this.img,
    required this.result,
    required this.solutions,
  });

  Practice.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        topicId = result["topicId"],
        content = result["content"],
        img = result["img"].
        result = result["result"],
        solutions = json.decode(result["solutions"]).cast<String>().toList();
  Map<String, Object> toMap() {
    return {
      'id': id,
      'topicId': topicId,
      'content': content,
      'img': img,
      'result' : result,
      'solutions' : solutions.toString()
    };
  }

}