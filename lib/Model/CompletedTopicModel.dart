import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedTopicModel {
  late final String topicId;
  late final String userId;

  CompletedTopicModel({
    required this.topicId,
    required this.userId,
  });

  CompletedTopicModel.fromMap(Map<String, dynamic> result)
      : topicId = result["topicId"],
        userId = result["userId"];

  Map<String, Object> toMap() {
    return {
      'topicId': topicId,
      'userId': userId,
    };
  }

  factory CompletedTopicModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CompletedTopicModel(
      topicId: data?['topicId'],
      userId: data?["userId"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (topicId != null) "topicId": topicId,
      if (userId != null) "userId": userId,
    };
  }
}
