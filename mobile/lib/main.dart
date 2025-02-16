import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation/app_router.dart';
import 'navigation/route_parser.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Sprinklers Pi',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: const Color(0xFF94cccd),
          primary: const Color(0xFF057257),
          surface: const Color(0xFFf9fbfa),
          onSurface: const Color(0xFF141414),
          secondary: const Color(0xFF032e3f),
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          color: const Color(0xFFf9fbfa),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 6),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Color(0xFF141414),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF141414),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF141414),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF032e3f),
          size: 24,
        ),
      ),
      routerDelegate: AppRouterDelegate(ref),
      routeInformationParser: AppRouteInformationParser(),
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: child,
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
