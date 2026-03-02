import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:untitled/firebase_options.dart';
import 'package:untitled/core/utils/quran_utils.dart';
import 'package:untitled/core/providers/example_provider.dart';

/// Main entry point for Quran Madrasa application.
///
/// Initializes Firebase services, configures Firestore offline persistence,
/// loads Quran metadata, and runs the app with Riverpod state management.
void main() async {
  // Ensure Flutter bindings are initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configure Firestore offline persistence
  // This enables the app to work offline and syncs data when connection is restored
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Load Quran metadata from assets
  // This initializes the QuranData utility with all 114 surahs
  await QuranData.initialize();

  // Log successful Firebase initialization
  print('✓ Firebase initialized successfully');
  print('✓ Quran metadata loaded: ${QuranData.getSurahs().length} surahs');

  // Configure Crashlytics error handlers
  // This captures all Flutter errors and async errors for crash reporting
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Handle async errors not caught by Flutter framework
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Run the app with Riverpod ProviderScope for state management
  runZonedGuarded(
    () => runApp(const ProviderScope(child: MyApp())),
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Madrasa',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PlaceholderScreen(),
    );
  }
}

/// Placeholder home screen - will be replaced with actual app in later phases.
class PlaceholderScreen extends ConsumerWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(exampleGreetingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Madrasa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(greeting),
            const SizedBox(height: 8),
            const Text(
              '114 Surahs Loaded',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
