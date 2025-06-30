import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:logistics_app/main.dart';
import 'package:logistics_app/presentation/providers/auth_provider.dart';
import 'package:logistics_app/presentation/providers/shipment_provider.dart';
import 'package:logistics_app/presentation/providers/log_provider.dart';
import 'package:logistics_app/presentation/screens/login_screen.dart';

void main() {
  group('Logistics App Tests', () {
    testWidgets('App should load without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const LogisticsApp());

      // Verify that the app loads
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Login screen should display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ShipmentProvider()),
            ChangeNotifierProvider(create: (_) => LogProvider()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: LoginScreen(),
            ),
          ),
        ),
      );

      // Verify login screen elements are present
      expect(find.text('Logistics Platform'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('Demo credentials should be displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ShipmentProvider()),
            ChangeNotifierProvider(create: (_) => LogProvider()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: LoginScreen(),
            ),
          ),
        ),
      );

      // Verify demo credentials are shown
      expect(find.text('Demo Credentials:'), findsOneWidget);
      expect(find.text('Admin: admin@example.com / password'), findsOneWidget);
      expect(find.text('User: user@example.com / password'), findsOneWidget);
    });
  });
} 