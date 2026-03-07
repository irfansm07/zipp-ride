import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zipp_flutter/main.dart';

void main() {
  testWidgets('ZipRide app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ZipRideApp());
    expect(find.text('ZipRide'), findsOneWidget);
  });
}
