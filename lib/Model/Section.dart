// import 'dart:convert';
// import 'dart:ffi';
//
// class Section{
//
//   late final String id;
//   late final String name;
//   late final String levelId;
//   late final Bool completed;
//
//   Section({
//     required this.id,
//     required this.name,
//     required this.levelId,
//     required this.completed
//   });
//
//   Section.fromMap(Map<String, dynamic> result)
//       : id = result["id"],
//         name = result["name"],
//         levelId = result["levelId"],
//         completed = result["completed"];
//   Map<String, Object> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'sectionId': levelId,
//       'completed': completed
//     };
//   }
//   factory Topic.fromFirestore(
//       DocumentSnapshot<Map<String, dynamic>> snapshot,
//       SnapshotOptions? options,
//       ) {
//     final data = snapshot.data();
//     return Topic(
//       id: snapshot.id,
//       name: data?['name'],
//       sectionId: data?['section'],
//       level: data?['level'],
//     );
//   }
//   Map<String, dynamic> toFirestore() {
//     return {
//       if (name != null) "name": name,
//       if (sectionId != null) "section": sectionId,
//       if (level != null) "level": level,
//
//     };
//   }
// }