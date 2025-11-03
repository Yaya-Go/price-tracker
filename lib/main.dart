import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:price_tracker/src/config/theme.dart';
import 'package:price_tracker/src/navigation/app_router.dart';
import 'package:price_tracker/src/providers/auth_provider.dart';
import 'package:price_tracker/src/providers/location_provider.dart';
import 'package:price_tracker/src/providers/theme_provider.dart';
import 'package:price_tracker/src/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final firestoreService = FirestoreService();
  await firestoreService.seedCategories();
  await firestoreService.seedLocations();
  runApp(MyApp(firestoreService: firestoreService));
}

class MyApp extends StatelessWidget {
  final FirestoreService firestoreService;
  const MyApp({super.key, required this.firestoreService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirestoreService>.value(value: firestoreService),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider(context.read<FirestoreService>())),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Price Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
