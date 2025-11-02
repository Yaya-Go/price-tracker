import 'package:cloud_firestore/cloud_firestore.dart';

class Price {
  final String id;
  final String itemId;
  final double value;
  final String locationId;
  final Timestamp lastModified;
  final Timestamp createdAt;
  final String createdBy;

  Price({
    required this.id,
    required this.itemId,
    required this.value,
    required this.locationId,
    required this.lastModified,
    required this.createdAt,
    required this.createdBy,
  });

  factory Price.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Price(
      id: doc.id,
      itemId: data['itemId'] ?? '',
      value: (data['value'] ?? 0).toDouble(),
      locationId: data['locationId'] ?? '',
      lastModified: data['lastModified'] ?? Timestamp.now(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'itemId': itemId,
      'value': value,
      'locationId': locationId,
      'lastModified': lastModified,
      'createdAt': createdAt,
      'createdBy': createdBy,
    };
  }
}
