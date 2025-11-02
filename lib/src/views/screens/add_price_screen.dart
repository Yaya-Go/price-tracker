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
  final _valueController = TextEditingController();
  String? _selectedLocationId;

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Price')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formHey,
          child: Column(
            children: [
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: 'Price', prefixIcon: Icon(Icons.attach_money)),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter a price' : null,
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<Location>>(
                stream: firestoreService.getLocations(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final locations = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedLocationId,
                    hint: const Text('Select Location'),
                    onChanged: (value) {
                      setState(() {
                        _selectedLocationId = value;
                      });
                    },
                    items: locations.map((location) {
                      return DropdownMenuItem(value: location.id, child: Text(location.name));
                    }).toList(),
                    validator: (value) => value == null ? 'Please select a location' : null,
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newPrice = Price(
                      id: '', // Firestore will generate an ID
                      itemId: widget.itemId,
                      value: double.parse(_valueController.text),
                      locationId: _selectedLocationId!,
                      lastModified: Timestamp.now(),
                      createdAt: Timestamp.now(),
                      createdBy: authProvider.user!.uid,
                    );
                    await firestoreService.addPrice(widget.itemId, newPrice);
                    context.pop();
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
