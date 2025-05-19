// lib/simple_main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'simple_app.dart';
import 'data/providers/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const SimpleApp(),
    ),
  );
} 