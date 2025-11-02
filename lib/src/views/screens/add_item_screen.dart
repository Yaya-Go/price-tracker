import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:price_tracker/src/models/category_model.dart';
import 'package:price_tracker/src/models/item_model.dart';
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
  String? _selectedCategoryId;
  String _mode = 'private';

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
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
                    return const CircularProgressIndicator();
                  }
                  final categories = snapshot.data!;
                  return DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    hint: const Text('Select Category'),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategoryId = value;
                      });
                    },
                    items: categories.map((category) {
                      return DropdownMenuItem(value: category.id, child: Text(category.name));
                    }).toList(),
                    validator: (value) => value == null ? 'Please select a category' : null,
                  );
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _mode,
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
                    final newItem = Item(
                      id: '', // Firestore will generate an ID
                      name: _nameController.text,
                      categoryId: _selectedCategoryId!,
                      lastModified: Timestamp.now(),
                      createdAt: Timestamp.now(),
                      mode: _mode,
                      createdBy: authProvider.user!.uid,
                    );
                    await firestoreService.addItem(newItem);
                    context.pop();
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
