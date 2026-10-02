import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'theme.dart';

void main() {
  runApp(const IsharaApp());
}

class IsharaApp extends StatelessWidget {
  const IsharaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ishara',
      debugShowCheckedModeBanner: false,
      theme: buildIsharaTheme(),
      home: const WelcomeScreen(),
    );
  }
}
