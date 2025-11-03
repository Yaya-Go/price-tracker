import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:price_tracker/src/models/location_model.dart';
import 'package:price_tracker/src/models/price_model.dart';
import 'package:price_tracker/src/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:price_tracker/src/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPriceScreen extends StatefulWidget {
  final String itemId;
  const AddPriceScreen({super.key, required this.itemId});

  @override
  State<AddPriceScreen> createState() => _AddPriceScreenState();
}

class _AddPriceScreenState extends State<AddPriceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  Location? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Price')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StreamBuilder<List<Location>>(
                stream: firestoreService.getLocations(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final locations = snapshot.data!;
                  return DropdownButtonFormField<Location>(
                    value: _selectedLocation,
                    decoration: const InputDecoration(labelText: 'Location'),
                    items: locations.map((location) {
                      return DropdownMenuItem<Location>(
                        value: location,
                        child: Text(location.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedLocation = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a location' : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price', prefixIcon: Icon(Icons.attach_money)),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final router = GoRouter.of(context);
                    final newPrice = Price(
                      id: '',
                      itemId: widget.itemId,
                      value: double.parse(_priceController.text),
                      locationId: _selectedLocation!.id,
                      lastModified: Timestamp.now(),
                      createdAt: Timestamp.now(),
                      createdBy: authProvider.user!.uid,
                    );
                    await firestoreService.addPrice(newPrice);

                    router.pop();
                  }
                },
                child: const Text('Add Price'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
