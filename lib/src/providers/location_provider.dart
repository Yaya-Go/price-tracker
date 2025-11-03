import 'package:flutter/material.dart';
import 'package:price_tracker/src/models/location_model.dart';
import 'package:price_tracker/src/services/firestore_service.dart';

class LocationProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  Map<String, Location> _locations = {};

  LocationProvider(this._firestoreService) {
    _firestoreService.getLocations().listen((locations) {
      _locations = {for (var loc in locations) loc.id: loc};
      notifyListeners();
    });
  }

  Map<String, Location> get locations => _locations;

  String getLocationName(String locationId) {
    return _locations[locationId]?.name ?? 'Unknown Location';
  }
}
