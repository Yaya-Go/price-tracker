import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String id;
  final String name;
  final Timestamp lastModified;
  final Timestamp createdAt;
  final String createdBy;

  Location({
    required this.id,
    required this.name,
    required this.lastModified,
    required this.createdAt,
    required this.createdBy,
  });

  factory Location.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Location(
      id: doc.id,
      name: data['name'] ?? '',
      lastModified: data['lastModified'] ?? Timestamp.now(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'lastModified': lastModified,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}
