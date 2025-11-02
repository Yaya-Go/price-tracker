import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:price_tracker/src/providers/auth_provider.dart';
import 'package:price_tracker/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Tracker'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          if (authProvider.user != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => authProvider.signOut(),
              tooltip: 'Logout',
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Price Tracker',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            if (authProvider.user == null)
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Login or Register'),
              )
            else
              Column(
                children: [
                  Text('You are logged in as ${authProvider.user!.email}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/my-items'),
                    child: const Text('View My Items'),
                  ),
                  ElevatedButton(
                    onPressed: () => context.go('/admin'),
                    child: const Text('Admin Panel'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
