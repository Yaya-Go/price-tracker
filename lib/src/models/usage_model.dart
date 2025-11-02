import 'package:cloud_firestore/cloud_firestore.dart';

class Usage {
  final int totalCount;
  final Timestamp lastModified;
  final Timestamp createdAt;
  final String createdBy;

  Usage({
    required this.totalCount,
    required this.lastModified,
    required this.createdAt,
    required this.createdBy,
  });

  factory Usage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Usage(
      totalCount: data['totalCount'] ?? 0,
      lastModified: data['lastModified'] ?? Timestamp.now(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'totalCount': totalCount,
      'lastModified': lastModified,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}
