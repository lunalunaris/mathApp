import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/Level.dart';
import '../Model/Practice.dart';
import '../Model/Section.dart';
import '../Model/Topic.dart';

class SqliteHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'questions_db.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE savedPractice(id TEXT PRIMARY KEY, topicId TEXT, content TEXT, img TEXT, result TEXT, solutions TEXT); '
            'CREATE TABLE completedTask(id TEXT PRIMARY KEY); '
            'CREATE TABLE topics(id TEXT PRIMARY KEY, name TEXT, sectionId TEXT, completed BOOLEAN);'
            'CREATE TABLE sections(id TEXT PRIMARY KEY, name TEXT, levelId TEXT, completed BOOLEAN);'
            'CREATE TABLE levels(id TEXT PRIMARY KEY, name TEXT, completed BOOLEAN)');
      },
    );
  }

// ---------------------- user end ---------------------------
  Future<List<Practice>> getPractices() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('savedPractice');
    return queryResult.map((e) => Practice.fromMap(e)).toList();
  }

  Future<Practice?> getPracticeById(String id) async {
    final Database db = await initializeDB();
    var response =
        await db.query("savedPractice", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Practice.fromMap(response.first) : null;
  }

  Future<List<Practice>> getPracticeByTopicId(String id) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.rawQuery(
        'select * from savedPractice from join topics on topics.id = savedPractice.topicId where topics.id = "${id}"');
    return queryResult.map((e) => Practice.fromMap(e)).toList();
  }

  Future<List<Level>> getAllLevels() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query("levels");
    return queryResult.map((e) => Level.fromMap(e)).toList();
  }

  Future<List<Section>> getSectionsByLevel(String levelId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query("sections", where: "levelId = ?", whereArgs: [levelId]);
    return queryResult.map((e) => Section.fromMap(e)).toList();
  }

  Future<List<Topic>> getTopicsBySection(String sectionId) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db
        .query("topics", where: "sectionId = ?", whereArgs: [sectionId]);
    return queryResult.map((e) => Topic.fromMap(e)).toList();
  }

  Future<List> getCompletedAll() async {
    final Database db = await initializeDB();
    List<Map> tasks = await db.query("completed");
    return tasks;
  }

  Future<bool> isCompleted(taskId) async {
    final Database db = await initializeDB();
    List<Map> tasks =
        await db.query("completed", where: "id = ?", whereArgs: [taskId]);
    if (tasks.length > 0) {
      return true;
    }
    return false;
  }

//// update all tables, delete by name, delete by id, delete all
  Future<void> insertSavedPractice(Practice practice) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'savedPractice',
      practice.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertCompletedTask(String id) async {
    final Database db = await initializeDB();
    int result = 0;
    Map<String, dynamic> tmp = {"id": id};
    result = await db.insert(
      'completed',
      tmp,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertTopic(Topic topic) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'topics',
      topic.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertSection(Section section) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'sections',
      section.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertLevel(Level level) async {
    final Database db = await initializeDB();
    int result = 0;
    result = await db.insert(
      'levels',
      level.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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

}

// Future<List> queryAll() async {
//   Database db = await database;
//   List<Map> names = await db.rawQuery('select Name.name, count(Date.date) from Name left join Date using(id) group by Name.name');
//   if (names.length > 0) {
//     return names;     }
//   return null;   }
