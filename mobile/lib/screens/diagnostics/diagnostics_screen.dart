import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/log_viewer.dart';
import 'widgets/weather_diagnostics.dart';
import 'widgets/system_maintenance.dart';
import 'widgets/chatter_box.dart';
import '../../theme/app_theme.dart';
import '../../theme/spacing.dart';

class DiagnosticsScreen extends ConsumerStatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  ConsumerState<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends ConsumerState<DiagnosticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const _tabCount = 4;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  void _initializeTabController() {
    try {
      _tabController = TabController(length: _tabCount, vsync: this);
    } catch (e) {
      debugPrint('Error initializing tab controller: $e');
      // Re-throw to let the error boundary handle it
      throw Exception('Failed to initialize diagnostics screen: $e');
    }
  }

  @override
  void dispose() {
    try {
      _tabController.dispose();
    } catch (e) {
      debugPrint('Error disposing tab controller: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = AppTheme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Diagnostics',
          style: appTheme.cardTitleStyle,
        ),
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: appTheme.mutedTextColor,
          indicatorColor: theme.colorScheme.primary,
          labelStyle: appTheme.valueTextStyle,
          unselectedLabelStyle: appTheme.subtitleTextStyle,
          tabs: const [
            Tab(
              icon: Icon(Icons.list_alt),
              text: 'Logs',
            ),
            Tab(
              icon: Icon(Icons.cloud),
              text: 'Weather',
            ),
            Tab(
              icon: Icon(Icons.build),
              text: 'System',
            ),
            Tab(
              icon: Icon(Icons.message),
              text: 'Chatter',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LogViewer(),
          WeatherDiagnostics(),
          SystemMaintenance(),
          ChatterBox(),
        ],
      ),
    );
  }
} 