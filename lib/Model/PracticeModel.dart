import 'dart:convert';
import 'dart:ffi';

class PracticeModel{

  late final String id;
  late final String topicId;
  late final String content;
  late final String img;
  late final String result;
  late final List<String> solutions;
  PracticeModel({
    required this.id,
    required this.topicId,
    required this.content,
    required this.img,
    required this.result,
    required this.solutions,
  });

  PracticeModel.fromMap(Map<String, dynamic> result)
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
  String getId(){
    return id;
  }
  String getTopic(){
    return topicId;
  }
  String getContent(){
    return content;
  }
  String getImg(){
    return img;
  }
  String getResult(){
    return result;
  }
  List<String> getSolutions(){
    return solutions;
  }

}