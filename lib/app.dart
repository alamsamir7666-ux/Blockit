import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class BlockitApp extends StatelessWidget {
  const BlockitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blockit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        body: Center(child: Text('Blockit - Coming Soon')),
      ),
    );
  }
}
