// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simplecalc/main.dart';

void main() {
  testWidgets('calculates a basic sum', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    await tester.pump();

    expect(find.byKey(const Key('calculator-display')), findsOneWidget);
    expect(find.text('5'), findsNWidgets(2));
  });

  testWidgets('calculates 2 plus 2', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('='));
    await tester.pump();

    final display = tester.widget<Text>(
      find.byKey(const Key('calculator-display')),
    );
    expect(display.data, '4');
  });

  testWidgets('calculates a random multiplication', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('7'));
    await tester.tap(find.text('×'));
    await tester.tap(find.text('6'));
    await tester.tap(find.text('='));
    await tester.pump();

    final display = tester.widget<Text>(
      find.byKey(const Key('calculator-display')),
    );
    expect(display.data, '42');
  });

  testWidgets('calculates a decimal division', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('8'));
    await tester.tap(find.text('.'));
    await tester.tap(find.text('4'));
    await tester.tap(find.text('÷'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('='));
    await tester.pump();

    final display = tester.widget<Text>(
      find.byKey(const Key('calculator-display')),
    );
    expect(display.data, '4.2');
  });

  testWidgets('calculates a chained operation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('9'));
    await tester.tap(find.text('-'));
    await tester.tap(find.text('4'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('='));
    await tester.pump();

    final display = tester.widget<Text>(
      find.byKey(const Key('calculator-display')),
    );
    expect(display.data, '7');
  });
}
