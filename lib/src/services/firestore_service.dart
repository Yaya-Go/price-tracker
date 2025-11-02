import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:price_tracker/src/models/item_model.dart';
import 'package:price_tracker/src/models/price_model.dart';
import 'package:price_tracker/src/models/category_model.dart';
import 'package:price_tracker/src/models/location_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Item operations
  Stream<List<Item>> getItems() {
    return _db.collection('items').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  }

  Stream<List<Item>> getUserItems(String userId) {
    return _db
        .collection('items')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  }

  Stream<Item> getItem(String itemId) {
    return _db.collection('items').doc(itemId).snapshots().map((doc) => Item.fromFirestore(doc));
  }

  Future<void> addItem(Item item) {
    return _db.collection('items').add(item.toFirestore());
  }

  Future<void> updateItem(Item item) {
    return _db.collection('items').doc(item.id).update(item.toFirestore());
  }

  Future<void> deleteItem(String itemId) {
    return _db.collection('items').doc(itemId).delete();
  }

  // Category operations
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList());
  }

  Future<void> addCategory(Category category) {
    return _db.collection('categories').add(category.toFirestore());
  }

  Future<void> updateCategory(Category category) {
    return _db.collection('categories').doc(category.id).update(category.toFirestore());
  }

  Future<void> deleteCategory(String categoryId) {
    return _db.collection('categories').doc(categoryId).delete();
  }


  // Location operations
  Stream<List<Location>> getLocations() {
    return _db.collection('locations').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Location.fromFirestore(doc)).toList());
  }

    Future<void> addLocation(Location location) {
    return _db.collection('locations').add(location.toFirestore());
  }

  Future<void> updateLocation(Location location) {
    return _db.collection('locations').doc(location.id).update(location.toFirestore());
  }

  Future<void> deleteLocation(String locationId) {
    return _db.collection('locations').doc(locationId).delete();
  }


  // Price operations
  Stream<List<Price>> getPrices(String itemId) {
    return _db
        .collection('items')
        .doc(itemId)
        .collection('prices')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Price.fromFirestore(doc)).toList());
  }

  Future<void> addPrice(String itemId, Price price) {
    return _db.collection('items').doc(itemId).collection('prices').add(price.toFirestore());
  }
}
