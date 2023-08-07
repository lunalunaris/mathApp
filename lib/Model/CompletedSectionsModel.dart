import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedSectionsModel {
  late final String section;
  late final String userId;

  CompletedSectionsModel({
    required this.section,
    required this.userId,
  });

  CompletedSectionsModel.fromMap(Map<String, dynamic> result)
      : section = result["section"],
        userId = result["userId"];

  Map<String, Object> toMap() {
    return {
      'section': section,
      'userId': userId,
    };
  }

  factory CompletedSectionsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CompletedSectionsModel(
      section: data?['section'],
      userId: data?["userId"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (section != null) "section": section,
      if (userId != null) "userId": userId,
    };
  }
}
