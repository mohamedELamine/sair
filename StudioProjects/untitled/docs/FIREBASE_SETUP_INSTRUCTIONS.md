# Firebase Setup Instructions

## T004: Enable Firebase Services in Console

These steps must be completed manually in the Firebase Console at:
https://console.firebase.google.com/project/androidmadrasasystem

### 1. Authentication

- Navigate to **Authentication** → **Sign-in method**
- Enable **Email/Password** provider
- Click **Save**

### 2. Firestore Database

- Navigate to **Firestore Database**
- Click **Create database**
- Select **Production mode** (or Test mode for development)
- Select region: **us-central1** (or closest to your location)
- Click **Create**

### 3. Cloud Functions

- Navigate to **Functions**
- Click **Upgrade to Blaze plan**
- Set budget alert: **$10/month** (safety threshold)
- Complete the upgrade process

### 4. Cloud Messaging (FCM)

- Navigate to **Cloud Messaging**
- Verify it shows **Enabled** status (default)
- Check that server key is accessible

### 5. Cloud Storage

- Navigate to **Storage**
- Click **Get started**
- Select the same region as Firestore (e.g., **us-central1**)
- Select **Test mode** for development
- Click **Done**

### 6. Crashlytics

- Navigate to **Crashlytics**
- Click **Enable Crashlytics**
- Follow the setup wizard
- Click **Done**

### Verification

After completing all steps, verify that all services show **Active** status in the Firebase Console overview.

---

## T005: Verify Firebase Connection with Test Write/Read

After completing T004, update `lib/main.dart` with the following test code to verify Firebase connectivity:

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Test Firebase connectivity
  await _testFirebaseConnection();

  runApp(const MyApp());
}

Future<void> _testFirebaseConnection() async {
  final firestore = FirebaseFirestore.instance;

  try {
    // Write test
    await firestore.collection('test_collection').doc('test_doc').set({
      'test': true,
      'timestamp': FieldValue.serverTimestamp(),
    });
    print('✅ Test write successful');

    // Read test
    final doc = await firestore.collection('test_collection').doc('test_doc').get();
    print('✅ Test read successful: ${doc.data()}');

    // Cleanup
    await firestore.collection('test_collection').doc('test_doc').delete();
    print('✅ Test cleanup successful');
  } catch (e) {
    print('❌ Firebase connection test failed: $e');
  }
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

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quran Madrasa'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Project Setup in Progress...'),
          ],
        ),
      ),
    );
  }
}
```

### Verification Steps

1. Run the app: `flutter run`
2. Check the console output for:
   - ✅ Test write successful
   - ✅ Test read successful
   - ✅ Test cleanup successful
3. Check Firebase Console → Firestore → Data to see the write operation
4. Verify no authentication or permission errors

### After Verification

Remove the test code from `main.dart` and restore the placeholder version for production.

---

## Important Notes

### iOS Development

- Install CocoaPods: `sudo gem install cocoapods`
- Run: `cd ios && pod install && cd ..`
- This is required for iOS development with Firebase

### Android Development

- The `google-services.json` file is already in place at `android/app/google-services.json`
- No additional setup required

### Project Configuration

- **Project ID**: `androidmadrasasystem`
- **iOS Bundle ID**: `com.madrasa.quran`
- **Android Package**: `com.madrasa.quran`

---

## Next Steps

After completing T004 and T005, Phase 01 will be complete. You can then proceed to Phase 02: Core Utilities & Quran Metadata.
