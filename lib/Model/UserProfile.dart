import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  late final String id;
  late final String level;
  late final String role;

  UserProfile.empty();

  UserProfile(
      {required this.id,
        required this.level,
        required this.role,
});

  factory UserProfile.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return UserProfile(
      id: snapshot.id,
      level: data?['level'],
      role: data?['role'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (level != null) "level": level,
      if (role != null) "role": role,

    };
  }

  UserProfile.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        level = result["level"],
        role = result["role"];

  Map<String, Object> toMap() {
    return {
      'id': id,
      'level': level,
      'role': role,
    };
  }
}
