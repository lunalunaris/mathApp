// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
//
// import '../Model/Level.dart';
// import '../Model/PracticeModel.dart';
//
// import '../Model/SectionModel.dart';
// import '../Model/TopicModel.dart';
//
// class SqliteHandler {
//   Future<Database> initializeDB() async {
//     String path = await getDatabasesPath();
//     return openDatabase(
//       join(path, 'questions_db.db'),
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute(
//             // 'CREATE TABLE savedPractice(id TEXT PRIMARY KEY, topicId TEXT, content TEXT, img TEXT, result TEXT, solutions TEXT);'
//
//             'CREATE TABLE completedTopic(id TEXT PRIMARY KEY);'
//             'CREATE TABLE completedSection(id '
//             // 'CREATE TABLE topics(id TEXT PRIMARY KEY, name TEXT, sectionId TEXT, completed BOOLEAN);'
//             // 'CREATE TABLE sections(id TEXT PRIMARY KEY, name TEXT, levelId TEXT, completed BOOLEAN);'
//             'CREATE TABLE level(id TEXT PRIMARY KEY, name TEXT)');
//       },
//     );
//   }
//
// // ---------------------- user end ---------------------------
//   Future<List<PracticeModel>> getPracticeModels() async {
//     final Database db = await initializeDB();
//     final List<Map<String, Object?>> queryResult =
//         await db.query('savedPracticeModel');
//     return queryResult.map((e) => PracticeModel.fromMap(e)).toList();
//   }
//
//   Future<PracticeModel?> getPracticeModelById(String id) async {
//     final Database db = await initializeDB();
//     var response =
//         await db.query("savedPracticeModel", where: "id = ?", whereArgs: [id]);
//     return response.isNotEmpty ? PracticeModel.fromMap(response.first) : null;
//   }
//
//   Future<List<PracticeModel>> getPracticeModelByTopicId(String id) async {
//     final Database db = await initializeDB();
//     final List<Map<String, Object?>> queryResult = await db.rawQuery(
//         'select * from savedPracticeModel from join topics on topics.id = savedPracticeModel.topicId where topics.id = "${id}"');
//     return queryResult.map((e) => PracticeModel.fromMap(e)).toList();
//   }
//
//   Future<List<Level>> getAllLevels() async {
//     final Database db = await initializeDB();
//     final List<Map<String, Object?>> queryResult = await db.query("levels");
//     return queryResult.map((e) => Level.fromMap(e)).toList();
//   }
//
//   Future<List<Section>> getSectionsByLevel(String levelId) async {
//     final Database db = await initializeDB();
//     final List<Map<String, Object?>> queryResult =
//         await db.query("sections", where: "levelId = ?", whereArgs: [levelId]);
//     return queryResult.map((e) => Section.fromMap(e)).toList();
//   }
//
//   Future<List<Topic>> getTopicsBySection(String sectionId) async {
//     final Database db = await initializeDB();
//     final List<Map<String, Object?>> queryResult = await db
//         .query("topics", where: "sectionId = ?", whereArgs: [sectionId]);
//     return queryResult.map((e) => Topic.fromMap(e)).toList();
//   }
//
//   Future<List> getCompletedAll() async {
//     final Database db = await initializeDB();
//     List<Map> tasks = await db.query("completed");
//     return tasks;
//   }
//
//   Future<bool> isCompleted(taskId) async {
//     final Database db = await initializeDB();
//     List<Map> tasks =
//         await db.query("completed", where: "id = ?", whereArgs: [taskId]);
//     if (tasks.length > 0) {
//       return true;
//     }
//     return false;
//   }
//
// //// update all tables, delete by name, delete by id, delete all
//   Future<void> insertSavedPracticeModel(PracticeModel practiceModel) async {
//     final Database db = await initializeDB();
//     int result = 0;
//     result = await db.insert(
//       'savedPracticeModel',
//       practiceModel.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<void> insertCompletedTask(String id) async {
//     final Database db = await initializeDB();
//     int result = 0;
//     Map<String, dynamic> tmp = {"id": id};
//     result = await db.insert(
//       'completed',
//       tmp,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<void> insertTopic(Topic topic) async {
//     final Database db = await initializeDB();
//     int result = 0;
//     result = await db.insert(
//       'topics',
//       topic.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<void> insertSection(Section section) async {
//     final Database db = await initializeDB();
//     int result = 0;
//     result = await db.insert(
//       'sections',
//       section.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<void> insertLevel(Level level) async {
//     final Database db = await initializeDB();
//     int result = 0;
//     result = await db.insert(
//       'levels',
//       level.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   Future<int> deleteById(String id, String table) async {
//     final Database db = await initializeDB();
//     return await db.delete(table, where: 'id = ?', whereArgs: [id]);
//   }
//   Future<int> deleteByName(String name, String table) async {
//     final Database db = await initializeDB();
//     return await db.delete(table, where: 'name = ?', whereArgs: [name]);
//   }
//   Future<int> deleteAll(String table) async {
//     final Database db = await initializeDB();
//     return await db.delete(table);
//   }
//
// }
//
// // Future<List> queryAll() async {
// //   Database db = await database;
// //   List<Map> names = await db.rawQuery('select Name.name, count(Date.date) from Name left join Date using(id) group by Name.name');
// //   if (names.length > 0) {
// //     return names;     }
// //   return null;   }
