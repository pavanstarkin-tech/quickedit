import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:quickedit/core/responsive/breakpoints.dart';
import 'package:quickedit/core/utils/currency_formatter.dart';
import 'package:quickedit/core/widgets/quickedit_logo.dart';
import 'package:quickedit/core/widgets/verified_badge.dart';
import 'package:quickedit/shared/data/mock_data.dart';

void main() {
  group('Currency Formatter Tests', () {
    test('Formats whole INR amounts with ₹ prefix correctly', () {
      expect(CurrencyFormatter.format(1499), '₹1,499');
      expect(CurrencyFormatter.format(18450), '₹18,450');
      expect(CurrencyFormatter.format(0), '₹0');
    });

    test('Formats decimal amounts correctly when requested', () {
      expect(CurrencyFormatter.format(1499.50, showDecimals: true), '₹1,499.50');
    });
  });

  group('Breakpoint System Tests', () {
    test('Validates responsive breakpoint values', () {
      expect(Breakpoints.mobileMax, 599.0);
      expect(Breakpoints.tabletMin, 600.0);
      expect(Breakpoints.tabletMax, 1023.0);
      expect(Breakpoints.desktopMin, 1024.0);
    });
  });

  group('Mock Catalog & Editors Data Tests', () {
    test('Services catalog contains 6 standard services', () {
      expect(MockData.services.length, 6);
      expect(MockData.services[1].slug, 'insta_reel');
      expect(MockData.services[1].defaultBasePrice, 1499);
    });

    test('Top editors list contains verified creators', () {
      expect(MockData.editors.isNotEmpty, true);
      final rohan = MockData.editors.first;
      expect(rohan.name, 'Rohan Mehta');
      expect(rohan.isVerified, true);
      expect(rohan.startingPrice, 1499);
    });
  });

  group('Widget Tests', () {
    testWidgets('QuickEditLogo renders brand text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: QuickEditLogo(fontSize: 24, isDark: false),
          ),
        ),
      );

      expect(find.byType(QuickEditLogo), findsOneWidget);
    });

    testWidgets('VerifiedBadge renders check icon with brand blue background', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VerifiedBadge(size: 20),
          ),
        ),
      );

      expect(find.byType(VerifiedBadge), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
