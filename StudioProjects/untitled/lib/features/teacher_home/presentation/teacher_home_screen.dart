import 'package:flutter/material.dart';

/// Teacher Home Screen
/// 
/// Main screen for teachers after successful authentication
class TeacherHomeScreen extends StatelessWidget {
  const TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Text('Teacher Home'),
      ),
    );
  }
}
