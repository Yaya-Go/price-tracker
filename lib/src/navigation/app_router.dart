import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:price_tracker/src/providers/auth_provider.dart';
import 'package:price_tracker/src/views/screens/add_item_screen.dart';
import 'package:price_tracker/src/views/screens/add_price_screen.dart';
import 'package:price_tracker/src/views/screens/admin_screen.dart';
import 'package:price_tracker/src/views/screens/forgot_password_screen.dart';
import 'package:price_tracker/src/views/screens/home_screen.dart';
import 'package:price_tracker/src/views/screens/item_detail_screen.dart';
import 'package:price_tracker/src/views/screens/login_screen.dart';
import 'package:price_tracker/src/views/screens/my_items_screen.dart';
import 'package:price_tracker/src/views/screens/register_screen.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/my-items',
      builder: (context, state) => const MyItemsScreen(),
    ),
    GoRoute(
      path: '/add-item',
      builder: (context, state) => const AddItemScreen(),
    ),
    GoRoute(
      path: '/item/:id',
      builder: (context, state) => ItemDetailScreen(itemId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/item/:id/add-price',
      builder: (context, state) => AddPriceScreen(itemId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminScreen(),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loggedIn = authProvider.user != null;
    final loggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/forgot-password';

    if (!loggedIn) {
      return loggingIn ? null : '/login';
    }

    if (loggingIn) {
      return '/';
    }

    return null;
  },
);
