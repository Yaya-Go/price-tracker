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
        .where('createdBy', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Item.fromFirestore(doc)).toList());
  }

  Stream<Item> getItem(String itemId) {
    return _db.collection('items').doc(itemId).snapshots().map((doc) => Item.fromFirestore(doc));
  }

  Future<String> addItem(Item item) async {
    final docRef = await _db.collection('items').add(item.toFirestore());
    return docRef.id;
  }

  Future<void> updateItem(Item item) {
    return _db.collection('items').doc(item.id).update(item.toFirestore());
  }

  Future<void> deleteItem(String itemId) {
    return _db.collection('items').doc(itemId).delete();
  }

  // Category operations
  Stream<List<Category>> getCategories() {
    return _db.collection('categories').orderBy('name').snapshots().map((snapshot) =>
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

  Future<void> seedCategories() async {
    final categoriesCollection = _db.collection('categories');
    final snapshot = await categoriesCollection.limit(1).get();

    if (snapshot.docs.isEmpty) {
      final List<String> presetCategories = [
        'Electronics',
        'Food & Drink',
        'Restaurant',
        'Entertainment',
        'Travel',
        'Clothing',
        'Petrol',
        'Household',
        'Grocery',
        'Other',
      ];

      for (final categoryName in presetCategories) {
        final newCategory = Category(
          id: '', // Firestore will generate
          name: categoryName,
          lastModified: Timestamp.now(),
          createdAt: Timestamp.now(),
          createdBy: 'system',
        );
        await categoriesCollection.add(newCategory.toFirestore());
      }
    }
  }


  // Location operations
  Stream<List<Location>> getLocations() {
    return _db.collection('locations').orderBy('name').snapshots().map((snapshot) =>
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

  Future<void> seedLocations() async {
    final locationsCollection = _db.collection('locations');
    final snapshot = await locationsCollection.limit(1).get();

    if (snapshot.docs.isEmpty) {
      final List<String> presetLocations = [
        'Walmart',
        'Target',
        'Costco',
        'Amazon',
        'Best Buy',
        'Home Depot',
        'Lowes',
        'Walgreens',
        'CVS',
        'Kroger',
      ];

      for (final locationName in presetLocations) {
        final newLocation = Location(
          id: '', // Firestore will generate
          name: locationName,
          lastModified: Timestamp.now(),
          createdAt: Timestamp.now(),
          createdBy: 'system',
        );
        await locationsCollection.add(newLocation.toFirestore());
      }
    }
  }


  // Price operations
  Stream<List<Price>> getPrices(String itemId) {
    return _db
        .collection('prices')
        .where('itemId', isEqualTo: itemId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Price.fromFirestore(doc)).toList());
  }

  Future<void> addPrice(Price price) {
    return _db.collection('prices').add(price.toFirestore());
  }
}
