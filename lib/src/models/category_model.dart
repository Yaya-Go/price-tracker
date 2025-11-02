import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final Timestamp lastModified;
  final Timestamp createdAt;
  final String createdBy;

  Category({
    required this.id,
    required this.name,
    required this.lastModified,
    required this.createdAt,
    required this.createdBy,
  });

  factory Category.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Category(
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
