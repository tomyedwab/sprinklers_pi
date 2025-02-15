import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/schedule.dart';
import '../../../providers/schedule_provider.dart';
import '../../../providers/zone_provider.dart';

class ScheduleEditModal extends ConsumerStatefulWidget {
  final ScheduleDetail? schedule;

  const ScheduleEditModal({
    super.key,
    this.schedule,
  });

  @override
  ConsumerState<ScheduleEditModal> createState() => _ScheduleEditModalState();
}

class _ScheduleEditModalState extends ConsumerState<ScheduleEditModal> {
  late final TextEditingController _nameController;
  late bool _isEnabled;
  late bool _isDayBased;
  late int _interval;
  late DayRestriction _restriction;
  late bool _isSundayEnabled;
  late bool _isMondayEnabled;
  late bool _isTuesdayEnabled;
  late bool _isWednesdayEnabled;
  late bool _isThursdayEnabled;
  late bool _isFridayEnabled;
  late bool _isSaturdayEnabled;
  late List<ScheduleTime> _times;
  late List<ScheduleZone> _zones;

  @override
  void initState() {
    super.initState();
    final schedule = widget.schedule;
    if (schedule != null) {
      _nameController = TextEditingController(text: schedule.name);
      _isEnabled = schedule.isEnabled;
      _isDayBased = schedule.type == ScheduleType.dayBased;
      _interval = schedule.interval;
      _restriction = schedule.restriction;
      _isSundayEnabled = schedule.days[0];
      _isMondayEnabled = schedule.days[1];
      _isTuesdayEnabled = schedule.days[2];
      _isWednesdayEnabled = schedule.days[3];
      _isThursdayEnabled = schedule.days[4];
      _isFridayEnabled = schedule.days[5];
      _isSaturdayEnabled = schedule.days[6];
      _times = List.of(schedule.times);
      _zones = List.of(schedule.zones);
    } else {
      _nameController = TextEditingController();
      _isEnabled = true;
      _isDayBased = true;
      _interval = 1;
      _restriction = DayRestriction.none;
      _isSundayEnabled = false;
      _isMondayEnabled = false;
      _isTuesdayEnabled = false;
      _isWednesdayEnabled = false;
      _isThursdayEnabled = false;
      _isFridayEnabled = false;
      _isSaturdayEnabled = false;
      _times = [
        const ScheduleTime(time: '06:00', isEnabled: true),
      ];
      _zones = [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_validateForm()) return;

    final schedule = ScheduleDetail(
      id: widget.schedule?.id ?? 0,  // API will assign real ID for new schedules
      name: _nameController.text,
      isEnabled: _isEnabled,
      type: _isDayBased ? ScheduleType.dayBased : ScheduleType.intervalBased,
      interval: _interval,
      restriction: _restriction,
      isWeatherAdjusted: false,  // Not implemented in UI yet
      days: [
        _isSundayEnabled,
        _isMondayEnabled,
        _isTuesdayEnabled,
        _isWednesdayEnabled,
        _isThursdayEnabled,
        _isFridayEnabled,
        _isSaturdayEnabled,
      ],
      times: _times,
      zones: _zones,
    );

    try {
      await ref
          .read(scheduleListNotifierProvider.notifier)
          .saveSchedule(schedule);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save schedule: $e')),
        );
      }
    }
  }

  bool _validateForm() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a schedule name')),
      );
      return false;
    }

    if (_nameController.text.length > 19) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule name must be 19 characters or less')),
      );
      return false;
    }

    if (_isDayBased && !_isSundayEnabled && !_isMondayEnabled && 
        !_isTuesdayEnabled && !_isWednesdayEnabled && !_isThursdayEnabled && 
        !_isFridayEnabled && !_isSaturdayEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one day')),
      );
      return false;
    }

    if (_times.isEmpty || !_times.any((t) => t.isEnabled)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one enabled time')),
      );
      return false;
    }

    if (!_zones.any((z) => z.isEnabled)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable at least one zone')),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNew = widget.schedule == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'New Schedule' : 'Edit Schedule'),
        actions: [
          if (!isNew)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Schedule'),
                    content: Text('Are you sure you want to delete "${_nameController.text}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && mounted) {
                  try {
                    await ref
                        .read(scheduleListNotifierProvider.notifier)
                        .deleteSchedule(widget.schedule!.id);
                    if (mounted) {
                      Navigator.of(context).pop(true);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete schedule: $e')),
                      );
                    }
                  }
                }
              },
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Basic Settings
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Schedule Name',
              helperText: 'Maximum 19 characters',
            ),
            maxLength: 19,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Enable Schedule'),
            value: _isEnabled,
            onChanged: (value) => setState(() => _isEnabled = value),
          ),
          const SizedBox(height: 16),
          
          // Schedule Type
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Schedule Type', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Day-based'),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Interval'),
                      ),
                    ],
                    selected: {_isDayBased},
                    onSelectionChanged: (value) => setState(() {
                      _isDayBased = value.first;
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (_isDayBased) ...[
                    Text('Days', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: const Text('Sun'),
                          selected: _isSundayEnabled,
                          onSelected: (value) => setState(() => _isSundayEnabled = value),
                        ),
                        FilterChip(
                          label: const Text('Mon'),
                          selected: _isMondayEnabled,
                          onSelected: (value) => setState(() => _isMondayEnabled = value),
                        ),
                        FilterChip(
                          label: const Text('Tue'),
                          selected: _isTuesdayEnabled,
                          onSelected: (value) => setState(() => _isTuesdayEnabled = value),
                        ),
                        FilterChip(
                          label: const Text('Wed'),
                          selected: _isWednesdayEnabled,
                          onSelected: (value) => setState(() => _isWednesdayEnabled = value),
                        ),
                        FilterChip(
                          label: const Text('Thu'),
                          selected: _isThursdayEnabled,
                          onSelected: (value) => setState(() => _isThursdayEnabled = value),
                        ),
                        FilterChip(
                          label: const Text('Fri'),
                          selected: _isFridayEnabled,
                          onSelected: (value) => setState(() => _isFridayEnabled = value),
                        ),
                        FilterChip(
                          label: const Text('Sat'),
                          selected: _isSaturdayEnabled,
                          onSelected: (value) => setState(() => _isSaturdayEnabled = value),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Restrictions', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SegmentedButton<DayRestriction>(
                      segments: const [
                        ButtonSegment(
                          value: DayRestriction.none,
                          label: Text('None'),
                        ),
                        ButtonSegment(
                          value: DayRestriction.oddDays,
                          label: Text('Odd Days'),
                        ),
                        ButtonSegment(
                          value: DayRestriction.evenDays,
                          label: Text('Even Days'),
                        ),
                      ],
                      selected: {_restriction},
                      onSelectionChanged: (value) => setState(() {
                        _restriction = value.first;
                      }),
                    ),
                  ] else ...[
                    Text('Interval', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _interval.toDouble(),
                            min: 1,
                            max: 20,
                            divisions: 19,
                            label: '$_interval days',
                            onChanged: (value) => setState(() {
                              _interval = value.round();
                            }),
                          ),
                        ),
                        Text('$_interval days'),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Times
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start Times', style: theme.textTheme.titleMedium),
                      if (_times.length < 3)
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() {
                            _times.add(const ScheduleTime(
                              time: '06:00',
                              isEnabled: true,
                            ));
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._times.asMap().entries.map((entry) {
                    final index = entry.key;
                    final time = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: time.isEnabled,
                            onChanged: (value) => setState(() {
                              _times[index] = time.copyWith(isEnabled: value ?? false);
                            }),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () async {
                                final result = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay(
                                    hour: int.parse(time.time.split(':')[0]),
                                    minute: int.parse(time.time.split(':')[1]),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    _times[index] = time.copyWith(
                                      time: '${result.hour.toString().padLeft(2, '0')}:'
                                          '${result.minute.toString().padLeft(2, '0')}',
                                    );
                                  });
                                }
                              },
                              child: Text(time.time),
                            ),
                          ),
                          if (_times.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => setState(() {
                                _times.removeAt(index);
                              }),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Zones
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Zone Durations', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ref.watch(zonesNotifierProvider).when(
                    data: (zones) => Column(
                      children: zones.asMap().entries.map((entry) {
                        final index = entry.key;
                        final zone = entry.value;
                        final scheduleZone = _zones.length > index
                            ? _zones[index]
                            : ScheduleZone(
                                duration: 15,  // Default 15 minutes
                                isEnabled: false,
                              );
                        
                        // Ensure _zones has enough entries
                        while (_zones.length <= index) {
                          _zones.add(ScheduleZone(
                            duration: 15,  // Default 15 minutes
                            isEnabled: false,
                          ));
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Checkbox(
                                value: scheduleZone.isEnabled,
                                onChanged: (value) => setState(() {
                                  _zones[index] = scheduleZone.copyWith(
                                    isEnabled: value ?? false,
                                  );
                                }),
                              ),
                              Expanded(
                                child: Text(zone.name),
                              ),
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  initialValue: scheduleZone.duration.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    suffixText: 'min',
                                    isDense: true,
                                  ),
                                  onChanged: (value) {
                                    final minutes = int.tryParse(value) ?? 0;
                                    setState(() {
                                      _zones[index] = scheduleZone.copyWith(
                                        duration: minutes.clamp(0, 255),
                                      );
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Failed to load zones: $error'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: _save,
              child: const Text('Save'),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
} 