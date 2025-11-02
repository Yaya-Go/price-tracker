import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:price_tracker/src/models/item_model.dart';
import 'package:price_tracker/src/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:price_tracker/src/providers/auth_provider.dart';

class MyItemsScreen extends StatelessWidget {
  const MyItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/add-item'),
            tooltip: 'Add Item',
          ),
        ],
      ),
      body: StreamBuilder<List<Item>>(
        stream: firestoreService.getUserItems(authProvider.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'You have not added any items yet. Press the + button to add one.',
                textAlign: TextAlign.center,
              ),
            );
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(item.name, style: Theme.of(context).textTheme.titleLarge),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.go('/item/${item.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
