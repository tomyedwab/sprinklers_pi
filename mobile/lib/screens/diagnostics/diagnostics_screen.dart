import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/log_viewer.dart';
import 'widgets/weather_diagnostics.dart';
import 'widgets/system_maintenance.dart';
import 'widgets/chatter_box.dart';

class DiagnosticsScreen extends ConsumerStatefulWidget {
  const DiagnosticsScreen({super.key});

  @override
  ConsumerState<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends ConsumerState<DiagnosticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Diagnostics',
          style: theme.textTheme.titleLarge,
        ),
        elevation: 2,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.secondary,
          unselectedLabelColor: theme.colorScheme.secondary.withOpacity(0.7),
          indicatorColor: theme.colorScheme.primary,
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