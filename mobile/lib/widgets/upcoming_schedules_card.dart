import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/schedule_provider.dart';
import '../providers/system_state_provider.dart';
import '../models/schedule.dart';
import '../navigation/navigation_state.dart';
import '../navigation/app_router.dart';
import '../navigation/routes.dart';
import '../theme/spacing.dart';
import '../theme/app_theme.dart';

class UpcomingSchedulesCard extends ConsumerWidget {
  const UpcomingSchedulesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedulesAsync = ref.watch(scheduleListNotifierProvider);
    final systemStateAsync = ref.watch(systemStateNotifierProvider);
    final appTheme = AppTheme.of(context);

    return Card(
      child: Padding(
        padding: Spacing.cardPaddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Schedules',
              style: appTheme.cardTitleStyle,
            ),
            SizedBox(height: Spacing.contentSpacing),
            systemStateAsync.when(
              loading: () => const Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => Center(
                child: Icon(Icons.error, color: appTheme.disabledStateColor, size: 24),
              ),
              data: (state) => Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.isRunning ? 'System Enabled' : 'System Disabled',
                          style: TextStyle(
                            fontSize: 16,
                            color: state.isRunning ? appTheme.enabledStateColor : appTheme.disabledStateColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Switch(
                          value: state.isRunning,
                          onChanged: (value) {
                            ref.read(systemStateNotifierProvider.notifier).setEnabled(value);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.isRunning 
                        ? 'Schedules and manual watering are enabled'
                        : 'Scheduled watering is disabled; manual control only',
                      style: appTheme.statusTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            schedulesAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Error loading schedules: $error',
                    style: TextStyle(color: appTheme.disabledStateColor),
                  ),
                ),
              ),
              data: (schedules) {
                if (schedules.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No upcoming schedules',
                        style: TextStyle(color: appTheme.inactiveZoneColor),
                      ),
                    ),
                  );
                }

                // Filter enabled schedules with next run time
                final upcomingSchedules = schedules
                    .where((s) => s.isEnabled && s.nextRun != null)
                    .toList();

                if (upcomingSchedules.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No upcoming schedules',
                        style: TextStyle(color: appTheme.inactiveZoneColor),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: upcomingSchedules.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final schedule = upcomingSchedules[index];
                        return _buildScheduleItem(context, schedule);
                      },
                    ),
                    if (schedules.length > upcomingSchedules.length) ...[
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            final router = Router.of(context).routerDelegate as AppRouterDelegate;
                            router.setCurrentRoute(RouteLocation(AppRoute.schedules));
                          },
                          child: const Text('View All Schedules'),
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(BuildContext context, ScheduleListItem schedule) {
    final appTheme = AppTheme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.schedule,
            size: 24,
            color: appTheme.scheduleIconColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              schedule.name,
              style: appTheme.valueTextStyle,
            ),
          ),
          if (schedule.nextRun != null)
            Text(
              schedule.nextRun!,
              style: appTheme.subtitleTextStyle,
            ),
        ],
      ),
    );
  }
} 