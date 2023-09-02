import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/PracticeModel.dart';

import '../Model/QuizModel.dart';
import '../Model/SectionModel.dart';
import '../Model/TheoryModel.dart';
import '../Model/TopicModel.dart';

class SqliteHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'questions_db.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE Practice(id TEXT PRIMARY KEY, topicId TEXT, content TEXT, img TEXT, '
                ' equation TEXT, resultImg TEXT, result TEXT, solutions TEXT);'
            'CREATE TABLE Theory(id TEXT PRIMARY KEY, img TEXT);'
            'CREATE TABLE Quiz(id TEXT PRIMARY KEY, content TEXT, equation TEXT, img TEXT, result TEXT,'
                'SECTION TEXT, solutions TEXT,topicId TEXT);'
            'CREATE TABLE topics(id TEXT PRIMARY KEY, name TEXT, section TEXT, completed BOOLEAN);'
            'CREATE TABLE sections(id TEXT PRIMARY KEY, name TEXT, level TEXT, completed BOOLEAN);'
            'CREATE TABLE level(id TEXT PRIMARY KEY, name TEXT);');
      },
    );
  }

// ---------------------- user end ---------------------------

  //+++++++getters++++++

    Future<List<PracticeModel>> getPracticeModelsByTopic(String topic) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
      await db.query("Practice", where: "topicId = ?", whereArgs: [topic]);
    return queryResult.map((e) => PracticeModel.fromMap(e)).toList();
  }
  Future<List<QuizModel>> getQuizModelsByTopic(String topic) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
    await db.query("Quiz", where: "topicId = ?", whereArgs: [topic]);
    return queryResult.map((e) => QuizModel.fromMap(e)).toList();
  }
  Future<List<TheoryModel>> getTheoryModelsByTopic(String topic) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
    await db.query("Theory", where: "topicId = ?", whereArgs: [topic]);
    return queryResult.map((e) => TheoryModel.fromMap(e)).toList();
  }

  Future<String?> getCurrentLevel() async {
    final Database db = await initializeDB();
    var response = await db.query("level");
    return response.isNotEmpty ? response.first.toString() : null;
  }

  Future<List<SectionModel>> getSectionsByLevel(String level) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query("sections", where: "level = ?", whereArgs: [level]);
    return queryResult.map((e) => SectionModel.fromDbMap(e)).toList();
  }

  Future<List<TopicModel>> getTopicsBySection(String sectionId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .query("topics", where: "section = ?", whereArgs: [sectionId]);
    return queryResult.map((e) => TopicModel.fromDbMap(e)).toList();
  }


  //++++++setters++++++++++



//// update all tables, delete by name, delete by id, delete all
  Future<void> insertPracticeModel(PracticeModel practiceModel) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'Practice',
      practiceModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> insertQuizModel(QuizModel quizModel) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'Quiz',
      quizModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<void> insertTheoryModel(TheoryModel theoryModel) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'Theory',
      theoryModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertTopic(TopicModel topic) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'topics',
      topic.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSection(SectionModel section) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'sections',
      section.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertLevel(String level) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'levels',
      {"name":level},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  //+++++++++++delete++++++++++++
  Future<int> deleteById(String id, String table) async {
    final Database db = await initializeDB();
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
  Future<int> deleteByName(String name, String table) async {
    final Database db = await initializeDB();
    return await db.delete(table, where: 'name = ?', whereArgs: [name]);
  }
  Future<int> deleteAll(String table) async {
    final Database db = await initializeDB();
    return await db.delete(table);
  }


  //+++++++OTHER++++++++++

Future<bool> isPracticeSaved(String id) async {
  final Database db = await initializeDB();
  var response = await db.query("Practice", where: "id = ?", whereArgs: [id]);
  return response.isNotEmpty;
}
  Future<bool> isQuizSaved(String topicId) async {
    final Database db = await initializeDB();
    var response = await db.query("Quiz", where: "topicId = ?", whereArgs: [topicId]);
    return response.isNotEmpty;
  }
  Future<bool> isTheorySaved(String topicId) async {
    final Database db = await initializeDB();
    var response = await db.query("Theory", where: "topicId = ?", whereArgs: [topicId]);
    return response.isNotEmpty;
  }


  // Future<List> getCompletedAll() async {
  //   final Database db = await initializeDB();
  //   List<Map> tasks = await db.query("completed");
  //   return tasks;
  // }
  //
  // Future<bool> isCompleted(taskId) async {
  //   final Database db = await initializeDB();
  //   List<Map> tasks =
  //   await db.query("completed", where: "id = ?", whereArgs: [taskId]);
  //   if (tasks.length > 0) {
  //     return true;
  //   }
  //   return false;
  // }

}

// Future<void> insertCompletedTask(String id) async {
//   final Database db = await initializeDB();
//   int result = 0;
//   Map<String, dynamic> tmp = {"id": id};
//   result = await db.insert(
//     'completed',
//     tmp,
//     conflictAlgorithm: ConflictAlgorithm.replace,
//   );
// }

// Future<List> queryAll() async {
//   Database db = await database;
//   List<Map> names = await db.rawQuery('select Name.name, count(Date.date) from Name left join Date using(id) group by Name.name');
//   if (names.length > 0) {
//     return names;     }
//   return null;   }

// Future<PracticeModel?> getPracticeModelByTopic(String topic) async {
//   final Database db = await initializeDB();
//   var response =
//       await db.query("Practice", where: "topicId = ?", whereArgs: [topic]);
//   return response.isNotEmpty ? PracticeModel.fromMap(response.first) : null;
// }

// Future<List<PracticeModel>> getPracticeModelByTopicId(String id) async {
//   final Database db = await initializeDB();
//   final List<Map<String, Object?>> queryResult = await db.rawQuery(
//       'select * from savedPracticeModel from join topics on topics.id = savedPracticeModel.topicId where topics.id = "${id}"');
//   return queryResult.map((e) => PracticeModel.fromMap(e)).toList();
// }

// Future<List<Level>> getAllLevels() async {
//   final Database db = await initializeDB();
//   final List<Map<String, Object?>> queryResult = await db.query("level");
//   return queryResult.map((e) => Level.fromMap(e)).toList();
// }
//   Future<List<PracticeModel>> getPracticeModelsByTopic(String topic) async {
//     final Database db = await initializeDB();
//     final List<Map<String, Object?>> queryResult =
//         await db.query('savedPracticeModel');
//     return queryResult.map((e) => PracticeModel.fromMap(e)).toList();
//   }