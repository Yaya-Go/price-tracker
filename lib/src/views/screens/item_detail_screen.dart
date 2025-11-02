import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:price_tracker/src/models/item_model.dart';
import 'package:price_tracker/src/models/price_model.dart';
import 'package:price_tracker/src/services/firestore_service.dart';
import 'package:intl/intl.dart';

class ItemDetailScreen extends StatelessWidget {
  final String itemId;
  const ItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: const Text('Item Details')),
      body: StreamBuilder<Item>(
        stream: firestoreService.getItem(itemId),
        builder: (context, itemSnapshot) {
          if (itemSnapshot.hasError) {
            return Center(child: Text('Error: ${itemSnapshot.error}'));
          }
          if (itemSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!itemSnapshot.hasData) {
            return const Center(child: Text('Item not found.'));
          }

          final item = itemSnapshot.data!;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: StreamBuilder<List<Price>>(
                  stream: firestoreService.getPrices(itemId),
                  builder: (context, priceSnapshot) {
                    if (priceSnapshot.hasError) {
                      return Center(child: Text('Error: ${priceSnapshot.error}'));
                    }
                    if (priceSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!priceSnapshot.hasData || priceSnapshot.data!.isEmpty) {
                      return const Center(child: Text('No prices recorded yet.'));
                    }

                    final prices = priceSnapshot.data!;
                    return ListView.builder(
                      itemCount: prices.length,
                      itemBuilder: (context, index) {
                        final price = prices[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text('\$${price.value.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
                            subtitle: Text(DateFormat.yMMMd().format(price.createdAt.toDate())),
                            trailing: Text(price.locationId), // In a real app, you'd fetch the location name
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/item/$itemId/add-price'),
        tooltip: 'Add Price',
        child: const Icon(Icons.add),
      ),
    );
  }
}
