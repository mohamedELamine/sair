// Widget tests for Quran Madrasa application
// These tests verify that the app builds and displays the correct content

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:untitled/main.dart';
import 'package:untitled/core/providers/example_provider.dart';

void main() {
  testWidgets('App builds and displays greeting', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope for Riverpod
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify the app builds without errors
    expect(find.text('Quran Madrasa'), findsOneWidget);
    expect(find.text('Quran Madrasa Setup Complete'), findsOneWidget);
    expect(find.text('114 Surahs Loaded'), findsOneWidget);
  });
}
