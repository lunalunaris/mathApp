import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedPracticeModel {
  late final String practiceId;
  late final String topicId;

  CompletedPracticeModel({
    required this.practiceId,
    required this.topicId,
  });

  CompletedPracticeModel.fromMap(Map<String, dynamic> result)
      : practiceId = result["practiceId"],
        topicId = result["topicId"];

  Map<String, Object> toMap() {
    return {'practiceId': practiceId, 'topicId': topicId};
  }

  factory CompletedPracticeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return CompletedPracticeModel(
      practiceId: data?['practiceId'],
      topicId: data?["topicId"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (practiceId != null) "practiceId": practiceId,
      if (topicId != null) "topicId": topicId,
    };
  }

}
