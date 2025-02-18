import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../../../providers/log_provider.dart';
import '../../../providers/zone_provider.dart';
import '../../../api/models/log.dart' as api;
import '../../../models/log.dart';
import '../../../api/models/zone.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/loading_states.dart';

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
  ViewType _viewType = ViewType.table;
  api.LogGrouping _grouping = api.LogGrouping.month;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();
  Set<int> _selectedZones = {};

  @override
  void initState() {
    super.initState();
    // Schedule the initial load after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zones = ref.watch(zonesNotifierProvider);
    
    // Watch the providers without triggering fetches in the select
    final logs = _viewType == ViewType.graph
        ? ref.watch(logNotifierProvider)
        : ref.watch(tableLogNotifierProvider);

    final dateFormat = DateFormat('MMM d, y');

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    });
                    _loadData();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.primary;
                        }
                        return null;
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.surface;
                        }
                        return Theme.of(context).colorScheme.onSurface;
                      },
                    ),
                    iconColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return Theme.of(context).colorScheme.surface;
                        }
                        return Theme.of(context).colorScheme.onSurface;
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Date range selection
                Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          'From: ${dateFormat.format(_startDate.toLocal())}',
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
                            });
                            _loadData();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: TextButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          'To: ${dateFormat.format(_endDate.toLocal())}',
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
                            });
                            _loadData();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (_viewType == ViewType.graph) ...[
                  const SizedBox(height: 16),
                  // Grouping options for graph view
                  SegmentedButton<api.LogGrouping>(
                    segments: const [
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
                      });
                      _loadData();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context).colorScheme.primary;
                          }
                          return null;
                        },
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context).colorScheme.surface;
                          }
                          return Theme.of(context).colorScheme.onSurface;
                        },
                      ),
                      iconColor: MaterialStateProperty.resolveWith<Color?>(
                        (states) {
                          if (states.contains(MaterialState.selected)) {
                            return Theme.of(context).colorScheme.surface;
                          }
                          return Theme.of(context).colorScheme.onSurface;
                        },
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
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
              ],
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await _loadData();
            },
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
                  onPrimaryAction: () => _loadData(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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

  Widget _buildTableView(List<ZoneLog> logs) {
    final zonesAsync = ref.watch(zonesNotifierProvider);
    final dateFormat = DateFormat('MMM d, y h:mm a');

    return zonesAsync.when(
      data: (zones) {
        // Filter logs based on selected zones
        final filteredLogs = _selectedZones.isEmpty 
          ? logs 
          : logs.where((log) => _selectedZones.contains(log.zoneId - 1)).toList();

        return ListView.builder(
          itemCount: filteredLogs.length,
          itemBuilder: (context, index) {
            final zoneLog = filteredLogs[index];
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
            final entries = zoneLog.entries;

            if (entries.isEmpty) return const SizedBox.shrink();

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(zoneName),
                subtitle: Text('${entries.length} entries'),
                shape: const Border(),  // Remove default border
                maintainState: true,  // Keep state when collapsed
                children: entries.map((entry) {
                  final scheduleText = entry.isManual
                      ? 'Manual'
                      : entry.isQuickSchedule
                          ? 'Quick'
                          : 'Schedule ${entry.scheduleId}';

                  return ListTile(
                    title: Text(dateFormat.format(entry.date.toLocal())),
                    subtitle: Text(
                      'Duration: ${entry.duration.inMinutes}:${(entry.duration.inSeconds % 60).toString().padLeft(2, '0')} • $scheduleText',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildAdjustmentChip(
                          'Seasonal: ${entry.seasonalAdjustment}%',
                          entry.seasonalAdjustment,
                          tooltip: 'Seasonal adjustment factor',
                        ),
                        const SizedBox(width: 4),
                        _buildAdjustmentChip(
                          'Weather: ${entry.weatherAdjustment}%',
                          entry.weatherAdjustment,
                          tooltip: 'Weather-based adjustment factor',
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

  Widget _buildAdjustmentChip(String label, int adjustment, {String? tooltip}) {
    Color? color;
    if (adjustment != 100 && adjustment != -1) {
      color = adjustment < 100 ? Colors.red[100] : Colors.green[100];
    }

    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: adjustment == -1 ? Colors.grey[100] : color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        adjustment == -1 ? 'N/A' : label,
        style: TextStyle(
          color: adjustment == -1 ? Colors.grey[600] : null,
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: chip,
      );
    }

    return chip;
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

        // Get all selected zones or all enabled zones if none selected
        final filteredZones = _selectedZones.isEmpty
            ? zones.where((z) => z.isEnabled).toList()
            : zones.where((z) => _selectedZones.contains(z.id)).toList();

        // Collect all data points and find global max value
        final allPoints = <List<GraphPoint>>[];
        Duration globalMax = Duration.zero;
        
        for (final zone in filteredZones) {
          final zoneId = zone.id + 1; // Convert back to API zone ID
          final points = graphData[zoneId] ?? [];
          allPoints.add(points);
          
          final zoneMax = points.fold<Duration>(
            Duration.zero,
            (max, point) => point.value > max ? point.value : max,
          );
          if (zoneMax > globalMax) globalMax = zoneMax;
        }

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zone Runtime',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 400,
                  child: LayoutBuilder(
                    builder: (context, constraints) => CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: GraphPainter(
                        allSeries: allPoints,
                        zones: filteredZones,
                        maxValue: globalMax,
                        grouping: _grouping,
                        startDate: _startDate,
                        endDate: _endDate,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }

  Widget _buildZoneFilter(List<Zone> zones) {
    final enabledZones = zones.where((zone) => zone.isEnabled).toList();
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Filter by Zones',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: PopupMenuButton<int?>(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            _selectedZones.isEmpty 
              ? 'All Zones' 
              : '${_selectedZones.length} Zone${_selectedZones.length == 1 ? '' : 's'} Selected'
          ),
        ),
        itemBuilder: (context) => [
          PopupMenuItem<int?>(
            value: null,
            child: const Text('All Zones'),
            onTap: () {
              setState(() {
                _selectedZones.clear();
              });
              _loadData();
            },
          ),
          ...enabledZones.map((zone) => PopupMenuItem<int?>(
            value: zone.id,
            enabled: false,  // Disable item selection to prevent menu from closing
            child: StatefulBuilder(
              builder: (context, setItemState) => InkWell(
                onTap: () {
                  setState(() {
                    setItemState(() {
                      if (_selectedZones.contains(zone.id)) {
                        _selectedZones.remove(zone.id);
                      } else {
                        _selectedZones.add(zone.id);
                      }
                    });
                  });
                  _loadData();
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: _selectedZones.contains(zone.id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedZones.add(zone.id);
                          } else {
                            _selectedZones.remove(zone.id);
                          }
                        });
                        _loadData();
                      },
                    ),
                    Text(zone.name),
                  ],
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<List<GraphPoint>> allSeries;
  final List<Zone> zones;
  final Duration maxValue;
  final api.LogGrouping grouping;
  final DateTime startDate;
  final DateTime endDate;
  final List<Color> _colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];

  GraphPainter({
    required this.allSeries,
    required this.zones,
    required this.maxValue,
    required this.grouping,
    required this.startDate,
    required this.endDate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    
    // Draw y-axis labels
    double leftOffset = 0;
    for (var i = 0; i <= 5; i++) {
      final value = (maxValue.inMinutes * i / 5).round();
      textPainter.text = TextSpan(
        text: '$value min',
        style: const TextStyle(fontSize: 10, color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(0, size.height - (i * size.height / 5) - textPainter.height / 2),
      );
      if (textPainter.width > leftOffset) {
        leftOffset = textPainter.width;
      }
    }
    leftOffset += 5;

    // Draw axes
    canvas.drawLine(
      Offset(leftOffset, size.height),
      Offset(size.width, size.height),
      axisPaint,
    );
    canvas.drawLine(
      Offset(leftOffset, 0),
      Offset(leftOffset, size.height),
      axisPaint,
    );


    if (allSeries.isEmpty || maxValue == Duration.zero) return;

    // Calculate x-axis scale and labels
    final xAxisData = _calculateXAxis(size.width - leftOffset);
    final xScale = xAxisData['scale'] as double;
    final xLabels = xAxisData['labels'] as List<String>;

    // Calculate dynamic bar sizing based on number of series
    final barWidth = (xScale * 0.8) / allSeries.length;
    final barSpacing = xScale * 0.2 / (allSeries.length + 1);

    // Calculate y-scale
    final yScale = size.height / maxValue.inMinutes;

    // Draw x-axis labels
    for (var i = 0; i < xLabels.length; i++) {
      final xPos = (i * xScale) + (xScale / 2);
      textPainter.text = TextSpan(
        text: xLabels[i],
        style: const TextStyle(fontSize: 10, color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(leftOffset + xPos - textPainter.width / 2, size.height + 4),
      );
    }

    // Draw bars for each data series
    for (var seriesIndex = 0; seriesIndex < allSeries.length; seriesIndex++) {
      final series = allSeries[seriesIndex];
      final color = _colors[seriesIndex % _colors.length];
      final barPaint = Paint()
        ..color = color.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      for (var bucketIndex = 0; bucketIndex < series.length; bucketIndex++) {
        final totalDuration = series[bucketIndex].value;
        final bucketCenter = leftOffset + (bucketIndex * xScale) + (xScale / 2);
        final barOffset = bucketCenter - (barWidth * allSeries.length / 2) + 
                         (seriesIndex * (barWidth + barSpacing));

        double barHeight = totalDuration.inMinutes * yScale;
        if (barHeight < 2) {
          barHeight = 2;
        }
        
        canvas.drawRect(
          Rect.fromLTRB(
            barOffset,
            size.height - barHeight,
            barOffset + barWidth,
            size.height,
          ),
          barPaint,
        );
      }
    }


    // Draw legend
    const legendSquareSize = 12.0;
    var legendX = size.width - 120;
    var legendY = 8.0;
    
    for (var i = 0; i < zones.length; i++) {
      final color = _colors[i % _colors.length];
      canvas.drawRect(
        Rect.fromLTWH(legendX, legendY, legendSquareSize, legendSquareSize),
        Paint()..color = color,
      );
      
      textPainter.text = TextSpan(
        text: zones[i].name,
        style: const TextStyle(fontSize: 10, color: Colors.black),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(legendX + legendSquareSize + 4, legendY));
      
      legendY += legendSquareSize + 4;
    }
  }

  /// Groups data points into buckets based on current grouping
  List<Duration> _bucketData(List<GraphPoint> series, int bucketCount) {
    final buckets = List<Duration>.filled(bucketCount, Duration.zero);
    
    for (final point in series) {
      final bucketIndex = _getBucketIndex(point.timestamp, bucketCount);
      buckets[bucketIndex] += point.value;
    }
    
    return buckets;
  }

  int _getBucketIndex(DateTime timestamp, int bucketCount) {
    switch (grouping) {
      case api.LogGrouping.hour:
        return timestamp.hour;
      case api.LogGrouping.dayOfWeek:
        return timestamp.weekday - 1; // 0-6 for Monday-Sunday
      case api.LogGrouping.month:
        return timestamp.month - 1; // 0-11 for January-December
      default:
        final daysFromStart = timestamp.difference(startDate).inDays;
        return daysFromStart.clamp(0, bucketCount - 1);
    }
  }

  Map<String, dynamic> _calculateXAxis(double width) {
    final labels = <String>[];
    int bucketCount;
    
    switch (grouping) {
      case api.LogGrouping.hour:
        bucketCount = 24;
        labels.addAll(List.generate(24, (i) => '${i.toString().padLeft(2, '0')}:00'));
        break;
      case api.LogGrouping.dayOfWeek:
        bucketCount = 7;
        labels.addAll(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']);
        break;
      case api.LogGrouping.month:
        bucketCount = 12;
        labels.addAll(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']);
        break;
      default:
        bucketCount = endDate.difference(startDate).inDays + 1;
        final dateFormat = DateFormat('MMM d');
        labels.addAll(List.generate(bucketCount, (i) => 
          dateFormat.format(startDate.add(Duration(days: i)))));
        break;
    }

    return {
      'scale': width / bucketCount,
      'labels': labels,
      'bucketCount': bucketCount,
    };
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) {
    return allSeries != oldDelegate.allSeries ||
        maxValue != oldDelegate.maxValue ||
        grouping != oldDelegate.grouping ||
        startDate != oldDelegate.startDate ||
        endDate != oldDelegate.endDate;
  }
} 