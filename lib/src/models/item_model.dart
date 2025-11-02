import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final String categoryId;
  final Timestamp lastModified;
  final Timestamp createdAt;
  final String mode;
  final String createdBy;
  final Map<String, dynamic>? usage;

  Item({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.lastModified,
    required this.createdAt,
    required this.mode,
    required this.createdBy,
    this.usage,
  });

  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id,
      name: data['name'] ?? '',
      categoryId: data['categoryId'] ?? '',
      lastModified: data['lastModified'] ?? Timestamp.now(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      mode: data['mode'] ?? 'private',
      createdBy: data['createdBy'] ?? '',
      usage: data['usage'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'categoryId': categoryId,
      'lastModified': lastModified,
      'createdAt': createdAt,
      'mode': mode,
      'createdBy': createdBy,
      'usage': usage,
    };
  }
}
