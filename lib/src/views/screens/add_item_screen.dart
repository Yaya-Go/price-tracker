import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:price_tracker/src/models/category_model.dart';
import 'package:price_tracker/src/models/item_model.dart';
import 'package:price_tracker/src/models/location_model.dart';
import 'package:price_tracker/src/models/price_model.dart';
import 'package:price_tracker/src/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:price_tracker/src/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  Category? _selectedCategory;
  Location? _selectedLocation;
  String _mode = 'private';

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Item Name', prefixIcon: Icon(Icons.shopping_cart)),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<Category>>(
                stream: firestoreService.getCategories(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final categories = snapshot.data!;
                  return DropdownButtonFormField<Category>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: categories.map((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) => value == null ? 'Please select a category' : null,
                  );
                },
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _mode,
                decoration: const InputDecoration(labelText: 'Mode'),
                onChanged: (value) {
                  setState(() {
                    _mode = value!;
                  });
                },
                items: const [
                  DropdownMenuItem(value: 'private', child: Text('Private')),
                  DropdownMenuItem(value: 'public', child: Text('Public')),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final router = GoRouter.of(context);
                    final newItem = Item(
                      id: '', // Firestore will generate an ID
                      name: _nameController.text,
                      categoryId: _selectedCategory!.id,
                      lastModified: Timestamp.now(),
                      createdAt: Timestamp.now(),
                      mode: _mode,
                      createdBy: authProvider.user!.uid,
                    );
                    final newItemId = await firestoreService.addItem(newItem);

                    final newPrice = Price(
                      id: '',
                      itemId: newItemId,
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
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
