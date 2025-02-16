import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/log_provider.dart';
import '../../../providers/zone_provider.dart';
import '../../../api/models/log.dart' as api;
import '../../../models/log.dart';
import '../../../api/models/zone.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/loading_states.dart';

// TODO: Fix graph x axis scaling

enum ViewType {
  graph,
  table,
}

class LogViewer extends ConsumerStatefulWidget {
  const LogViewer({super.key});

  @override
  ConsumerState<LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends ConsumerState<LogViewer> {
  final TextEditingController _searchController = TextEditingController();
  String _filter = '';
  ViewType _viewType = ViewType.table;
  api.LogGrouping _grouping = api.LogGrouping.none;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  Set<int> _selectedZones = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (_viewType == ViewType.graph) {
      await ref.read(logNotifierProvider.notifier).fetchDateRange(
        startDate: _startDate,
        endDate: _endDate,
        grouping: _grouping,
      );
    } else {
      await ref.read(tableLogNotifierProvider.notifier).fetchDateRange(
        startDate: _startDate,
        endDate: _endDate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final zones = ref.watch(zonesNotifierProvider);
    final logs = _viewType == ViewType.graph
        ? ref.watch(logNotifierProvider)
        : ref.watch(tableLogNotifierProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // View type toggle
              SegmentedButton<ViewType>(
                segments: const [
                  ButtonSegment(
                    value: ViewType.graph,
                    icon: Icon(Icons.bar_chart),
                    label: Text('Graph'),
                  ),
                  ButtonSegment(
                    value: ViewType.table,
                    icon: Icon(Icons.table_chart),
                    label: Text('Table'),
                  ),
                ],
                selected: {_viewType},
                onSelectionChanged: (selected) {
                  setState(() {
                    _viewType = selected.first;
                    _loadData();
                  });
                },
              ),
              const SizedBox(height: 8),
              // Date range selection
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        'From: ${_startDate.toLocal().toString().split(' ')[0]}',
                      ),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: DateTime(2000),
                          lastDate: _endDate,
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                            _loadData();
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        'To: ${_endDate.toLocal().toString().split(' ')[0]}',
                      ),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _endDate = date;
                            _loadData();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (_viewType == ViewType.graph) ...[
                const SizedBox(height: 8),
                // Grouping options for graph view
                SegmentedButton<api.LogGrouping>(
                  segments: const [
                    ButtonSegment(
                      value: api.LogGrouping.none,
                      label: Text('None'),
                    ),
                    ButtonSegment(
                      value: api.LogGrouping.hour,
                      label: Text('Hour'),
                    ),
                    ButtonSegment(
                      value: api.LogGrouping.dayOfWeek,
                      label: Text('DOW'),
                    ),
                    ButtonSegment(
                      value: api.LogGrouping.month,
                      label: Text('Month'),
                    ),
                  ],
                  selected: {_grouping},
                  onSelectionChanged: (selected) {
                    setState(() {
                      _grouping = selected.first;
                      _loadData();
                    });
                  },
                ),
              ],
              const SizedBox(height: 8),
              // Zone filters
              zones.when(
                data: (zones) => _buildZoneFilter(zones),
                loading: () => const SizedBox(height: 52),  // Match filter height
                error: (_, __) => StandardErrorWidget(
                  message: 'Failed to load zones',
                  type: ErrorType.network,
                  showRetry: true,
                  onPrimaryAction: () => ref.refresh(zonesNotifierProvider),
                ),
              ),
              // Search filter (only for table view)
              if (_viewType == ViewType.table) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Filter Logs',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _filter.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _filter = '';
                              });
                            },
                          )
                        : null,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _filter = value;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: logs.when(
              data: (data) {
                if (_viewType == ViewType.table) {
                  return _buildTableView(data as List<ZoneLog>);
                } else {
                  return _buildGraphView(data as Map<int, List<GraphPoint>>);
                }
              },
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SkeletonCard(
                    height: 60,
                    showHeader: false,
                    contentLines: 2,
                  ),
                ),
              ),
              error: (error, stackTrace) => Center(
                child: StandardErrorWidget(
                  message: 'Failed to load logs: $error',
                  type: ErrorType.network,
                  showRetry: true,
                  onPrimaryAction: _loadData,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableView(List<ZoneLog> logs) {
    final zonesAsync = ref.watch(zonesNotifierProvider);

    return zonesAsync.when(
      data: (zones) {
        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            final zoneLog = logs[index];
            final zoneName = zones.firstWhere(
              (z) => z.id == zoneLog.zoneId - 1,
              orElse: () => Zone(
                id: zoneLog.zoneId - 1,
                name: 'Zone ${zoneLog.zoneId}',
                isEnabled: true,
                state: false,
                isPumpAssociated: false,
              ),
            ).name;
            final entries = zoneLog.entries
                .where((entry) =>
                    _filter.isEmpty ||
                    entry.date.toString().toLowerCase().contains(_filter.toLowerCase()))
                .toList();

            if (entries.isEmpty) return const SizedBox.shrink();

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(zoneName),
                subtitle: Text('${entries.length} entries'),
                children: entries.map((entry) {
                  final scheduleText = entry.isManual
                      ? 'Manual'
                      : entry.isQuickSchedule
                          ? 'Quick'
                          : 'Schedule ${entry.scheduleId}';

                  return ListTile(
                    title: Text(entry.date.toString()),
                    subtitle: Text(
                      'Duration: ${entry.duration.inMinutes}:${(entry.duration.inSeconds % 60).toString().padLeft(2, '0')} • $scheduleText',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAdjustmentChip(
                          'S: ${entry.seasonalAdjustment}%',
                          entry.seasonalAdjustment,
                        ),
                        const SizedBox(width: 4),
                        _buildAdjustmentChip(
                          'W: ${entry.weatherAdjustment}%',
                          entry.weatherAdjustment,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildAdjustmentChip(String label, int adjustment) {
    Color? color;
    if (adjustment != 100) {
      color = adjustment < 100 ? Colors.red[100] : Colors.green[100];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color != null
              ? color == Colors.red[100]
                  ? Colors.red[900]
                  : Colors.green[900]
              : null,
        ),
      ),
    );
  }

  Widget _buildGraphView(Map<int, List<GraphPoint>> graphData) {
    final zonesAsync = ref.watch(zonesNotifierProvider);

    return zonesAsync.when(
      data: (zones) {
        if (graphData.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        return ListView.builder(
          itemCount: graphData.length,
          itemBuilder: (context, index) {
            final zoneId = graphData.keys.elementAt(index);
            final points = graphData[zoneId]!;
            final zoneName = zones.firstWhere(
              (z) => z.id == zoneId - 1,
              orElse: () => Zone(
                id: zoneId - 1,
                name: 'Zone ${zoneId}',
                isEnabled: true,
                state: false,
                isPumpAssociated: false,
              ),
            ).name;

            if (points.isEmpty) return const SizedBox.shrink();

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zoneName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: _buildGraph(points),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildGraph(List<GraphPoint> points) {
    // Sort points by timestamp
    points.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Find max value for y-axis scaling
    final maxValue = points.fold<Duration>(
      Duration.zero,
      (max, point) => point.value > max ? point.value : max,
    );

    if (maxValue == Duration.zero) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return CustomPaint(
      painter: GraphPainter(
        points: points,
        maxValue: maxValue,
        grouping: _grouping,
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }

  Widget _buildZoneFilter(List<Zone> zones) {
    return Wrap(
      spacing: 8,
      children: zones
          .where((zone) => zone.isEnabled)
          .map(
            (zone) => FilterChip(
              label: Text(zone.name),
              selected: _selectedZones.contains(zone.id),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedZones.add(zone.id);
                  } else {
                    _selectedZones.remove(zone.id);
                  }
                });
              },
            ),
          )
          .toList(),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<GraphPoint> points;
  final Duration maxValue;
  final api.LogGrouping grouping;
  final DateTime startDate;
  final DateTime endDate;

  GraphPainter({
    required this.points,
    required this.maxValue,
    required this.grouping,
    required this.startDate,
    required this.endDate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.blue.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    // Draw axes
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width, size.height),
      paint,
    );
    canvas.drawLine(
      const Offset(0, 0),
      Offset(0, size.height),
      paint,
    );

    if (points.isEmpty) return;

    // Calculate x and y scales using the selected date range
    final timeRange = endDate.difference(startDate);
    final xScale = size.width / timeRange.inMilliseconds;
    final yScale = size.height / maxValue.inMinutes;

    // Move to first point
    final firstPoint = points.first;
    final startX = firstPoint.timestamp.difference(startDate).inMilliseconds * xScale;
    final startY = size.height - (firstPoint.value.inMinutes * yScale);
    path.moveTo(startX, startY);
    fillPath.moveTo(startX, size.height);
    fillPath.lineTo(startX, startY);

    // Draw lines between points
    for (var i = 1; i < points.length; i++) {
      final point = points[i];
      final x = point.timestamp.difference(startDate).inMilliseconds * xScale;
      final y = size.height - (point.value.inMinutes * yScale);
      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    // Complete fill path
    fillPath.lineTo(points.last.timestamp.difference(startDate).inMilliseconds * xScale, size.height);
    fillPath.close();

    // Draw fill and line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw time labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw x-axis labels (6 evenly spaced points)
    for (var i = 0; i <= 5; i++) {
      final timestamp = startDate.add(
        Duration(milliseconds: (timeRange.inMilliseconds * i ~/ 5)),
      );
      final x = (timestamp.difference(startDate).inMilliseconds * xScale);
      String label;
      switch (grouping) {
        case api.LogGrouping.hour:
          label = '${timestamp.hour}:00';
          break;
        case api.LogGrouping.dayOfWeek:
          label = _getDayName(timestamp.weekday);
          break;
        case api.LogGrouping.month:
          label = _getMonthName(timestamp.month);
          break;
        case api.LogGrouping.none:
          label = '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
          break;
      }

      textPainter.text = TextSpan(
        text: label,
        style: const TextStyle(fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height + 4),
      );
    }

    // Draw y-axis labels
    for (var i = 0; i <= 5; i++) {
      final value = (maxValue.inMinutes * i / 5).round();
      textPainter.text = TextSpan(
        text: '$value min',
        style: const TextStyle(fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width - 4, size.height - (i * size.height / 5) - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return points != oldDelegate.points ||
        maxValue != oldDelegate.maxValue ||
        grouping != oldDelegate.grouping ||
        startDate != oldDelegate.startDate ||
        endDate != oldDelegate.endDate;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return 'Mon';
      case DateTime.tuesday: return 'Tue';
      case DateTime.wednesday: return 'Wed';
      case DateTime.thursday: return 'Thu';
      case DateTime.friday: return 'Fri';
      case DateTime.saturday: return 'Sat';
      case DateTime.sunday: return 'Sun';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case DateTime.january: return 'Jan';
      case DateTime.february: return 'Feb';
      case DateTime.march: return 'Mar';
      case DateTime.april: return 'Apr';
      case DateTime.may: return 'May';
      case DateTime.june: return 'Jun';
      case DateTime.july: return 'Jul';
      case DateTime.august: return 'Aug';
      case DateTime.september: return 'Sep';
      case DateTime.october: return 'Oct';
      case DateTime.november: return 'Nov';
      case DateTime.december: return 'Dec';
      default: return '';
    }
  }
} 