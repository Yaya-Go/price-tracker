import 'package:flutter/material.dart';
import 'package:price_tracker/src/models/category_model.dart';
import 'package:price_tracker/src/models/item_model.dart';
import 'package:price_tracker/src/models/location_model.dart';
import 'package:price_tracker/src/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:price_tracker/src/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = Provider.of<FirestoreService>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.shopping_cart), text: 'Items'),
              Tab(icon: Icon(Icons.category), text: 'Categories'),
              Tab(icon: Icon(Icons.location_on), text: 'Locations'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildItemsTab(context, firestoreService),
            _buildCategoriesTab(context, firestoreService),
            _buildLocationsTab(context, firestoreService),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTab(BuildContext context, FirestoreService firestoreService) {
    return StreamBuilder<List<Item>>(
      stream: firestoreService.getItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No items found.'));
        }

        final items = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(item.name, style: Theme.of(context).textTheme.titleMedium),
                subtitle: Text('Created by: ${item.createdBy}'), // Added to show who created the item
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueAccent),
                      onPressed: () => context.go('/item/${item.id}'), // Navigate to item detail page
                      tooltip: 'Edit Item',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => firestoreService.deleteItem(item.id),
                      tooltip: 'Delete Item',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoriesTab(
      BuildContext context, FirestoreService firestoreService) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<List<Category>>(
        stream: firestoreService.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(category.name, style: Theme.of(context).textTheme.titleMedium),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () =>
                            _showCategoryDialog(context, firestoreService, authProvider, category),
                        tooltip: 'Edit Category',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => firestoreService.deleteCategory(category.id),
                        tooltip: 'Delete Category',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, firestoreService, authProvider),
        tooltip: 'Add Category',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLocationsTab(
      BuildContext context, FirestoreService firestoreService) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: StreamBuilder<List<Location>>(
        stream: firestoreService.getLocations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No locations found.'));
          }

          final locations = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(location.name, style: Theme.of(context).textTheme.titleMedium),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () =>
                            _showLocationDialog(context, firestoreService, authProvider, location),
                        tooltip: 'Edit Location',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => firestoreService.deleteLocation(location.id),
                        tooltip: 'Delete Location',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLocationDialog(context, firestoreService, authProvider),
        tooltip: 'Add Location',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, FirestoreService firestoreService, AuthProvider authProvider, [Category? category]) {
    final nameController = TextEditingController(text: category?.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(category == null ? 'Add Category' : 'Edit Category'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final now = Timestamp.now();
                  if (category == null) {
                    firestoreService.addCategory(Category(id: '', name: nameController.text, lastModified: now, createdAt: now, createdBy: authProvider.user!.uid));
                  } else {
                    firestoreService.updateCategory(Category(id: category.id, name: nameController.text, lastModified: now, createdAt: category.createdAt, createdBy: category.createdBy));
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationDialog(BuildContext context, FirestoreService firestoreService, AuthProvider authProvider, [Location? location]) {
    final nameController = TextEditingController(text: location?.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(location == null ? 'Add Location' : 'Edit Location'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Location Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final now = Timestamp.now();
                  if (location == null) {
                    firestoreService.addLocation(Location(id: '', name: nameController.text, lastModified: now, createdAt: now, createdBy: authProvider.user!.uid));
                  } else {
                    firestoreService.updateLocation(Location(id: location.id, name: nameController.text, lastModified: now, createdAt: location.createdAt, createdBy: location.createdBy));
                  }
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
