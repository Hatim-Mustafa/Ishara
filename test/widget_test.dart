import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ishara/main.dart';
import 'package:ishara/models/guidance.dart';
import 'package:ishara/widgets/guidance_field.dart';

void main() {
  testWidgets('Welcome screen shows brand and start action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const IsharaApp());
    await tester.pumpAndSettle();

    expect(find.text('Ishara'), findsOneWidget);
    expect(find.text('Tell us where to go'), findsOneWidget);
    expect(find.text('What the colors mean'), findsOneWidget);
  });

  testWidgets('Start opens the voice destination screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const IsharaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tell us where to go'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Destination'), findsOneWidget);
  });

  testWidgets('Guidance field renders every state without overflow', (
    WidgetTester tester,
  ) async {
    for (final Guidance guidance in demoWalk) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GuidanceField(guidance: guidance)),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(GuidanceField), findsOneWidget);
    }
  });
}
