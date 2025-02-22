import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/schedule.dart';
import '../../../providers/schedule_provider.dart';
import '../../../providers/zone_provider.dart';
import '../../../widgets/standard_error_widget.dart';
import '../../../widgets/confirmation_dialogs.dart';

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
  late final int? _id;
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
  late bool _isWeatherAdjusted;
  late List<ScheduleTime> _times;
  late List<ScheduleZone> _zones;

  // Validation state
  String? _nameError;
  String? _daysError;
  String? _timesError;
  bool _isValid = true;

  // Track original state for change detection
  late final String _originalName;
  late final bool _originalEnabled;
  late final bool _originalDayBased;
  late final int _originalInterval;
  late final DayRestriction _originalRestriction;
  late final bool _originalSundayEnabled;
  late final bool _originalMondayEnabled;
  late final bool _originalTuesdayEnabled;
  late final bool _originalWednesdayEnabled;
  late final bool _originalThursdayEnabled;
  late final bool _originalFridayEnabled;
  late final bool _originalSaturdayEnabled;
  late final bool _originalWeatherAdjusted;
  late final List<ScheduleTime> _originalTimes;
  late final List<ScheduleZone> _originalZones;

  bool get _hasChanges {
    if (_nameController.text != _originalName) return true;
    if (_isEnabled != _originalEnabled) return true;
    if (_isDayBased != _originalDayBased) return true;
    if (_interval != _originalInterval) return true;
    if (_restriction != _originalRestriction) return true;
    if (_isSundayEnabled != _originalSundayEnabled) return true;
    if (_isMondayEnabled != _originalMondayEnabled) return true;
    if (_isTuesdayEnabled != _originalTuesdayEnabled) return true;
    if (_isWednesdayEnabled != _originalWednesdayEnabled) return true;
    if (_isThursdayEnabled != _originalThursdayEnabled) return true;
    if (_isFridayEnabled != _originalFridayEnabled) return true;
    if (_isSaturdayEnabled != _originalSaturdayEnabled) return true;
    if (_isWeatherAdjusted != _originalWeatherAdjusted) return true;
    
    // Compare times
    if (_times.length != _originalTimes.length) return true;
    for (var i = 0; i < _times.length; i++) {
      if (_times[i].time != _originalTimes[i].time) return true;
    }
    
    // Compare zones
    if (_zones.length != _originalZones.length) return true;
    for (var i = 0; i < _zones.length; i++) {
      if (_zones[i].isEnabled != _originalZones[i].isEnabled) return true;
      if (_zones[i].duration != _originalZones[i].duration) return true;
    }
    
    return false;
  }

  @override
  void initState() {
    super.initState();
    final schedule = widget.schedule;
    if (schedule != null) {
      // Initialize current state
      _id = schedule.id;
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
      _isWeatherAdjusted = schedule.isWeatherAdjusted;
      _times = schedule.times.where((t) => t.isEnabled).map((t) => 
        ScheduleTime(time: t.time, isEnabled: true)
      ).toList();
      _zones = List.filled(schedule.zones.length, const ScheduleZone(duration: 0, isEnabled: false));
      for (var i = 0; i < schedule.zones.length; i++) {
        if (i < schedule.zones.length) {
          _zones[i] = schedule.zones[i];
        }
      }

      // Store original state
      _originalName = schedule.name;
      _originalEnabled = schedule.isEnabled;
      _originalDayBased = schedule.type == ScheduleType.dayBased;
      _originalInterval = schedule.interval;
      _originalRestriction = schedule.restriction;
      _originalSundayEnabled = schedule.days[0];
      _originalMondayEnabled = schedule.days[1];
      _originalTuesdayEnabled = schedule.days[2];
      _originalWednesdayEnabled = schedule.days[3];
      _originalThursdayEnabled = schedule.days[4];
      _originalFridayEnabled = schedule.days[5];
      _originalSaturdayEnabled = schedule.days[6];
      _originalWeatherAdjusted = schedule.isWeatherAdjusted;
      _originalTimes = schedule.times.where((t) => t.isEnabled).map((t) => 
        ScheduleTime(time: t.time, isEnabled: true)
      ).toList();
      _originalZones = List.from(_zones);
    } else {
      // Initialize new schedule state
      _id = null;
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
      _isWeatherAdjusted = true;
      _times = [const ScheduleTime(time: '06:00', isEnabled: true)];
      _zones = [];

      // For new schedules, original state matches initial state
      _originalName = '';
      _originalEnabled = true;
      _originalDayBased = true;
      _originalInterval = 1;
      _originalRestriction = DayRestriction.none;
      _originalSundayEnabled = false;
      _originalMondayEnabled = false;
      _originalTuesdayEnabled = false;
      _originalWednesdayEnabled = false;
      _originalThursdayEnabled = false;
      _originalFridayEnabled = false;
      _originalSaturdayEnabled = false;
      _originalWeatherAdjusted = true;
      _originalTimes = [const ScheduleTime(time: '06:00', isEnabled: true)];
      _originalZones = [];
    }

    // Add listener for real-time validation
    _nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateName);
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    setState(() {
      if (_nameController.text.isEmpty) {
        _nameError = 'Please enter a schedule name';
      } else if (_nameController.text.length > 19) {
        _nameError = 'Schedule name must be 19 characters or less';
      } else {
        _nameError = null;
      }
      _validateForm();
    });
  }

  void _validateDays() {
    setState(() {
      if (_isDayBased && !_isSundayEnabled && !_isMondayEnabled && 
          !_isTuesdayEnabled && !_isWednesdayEnabled && !_isThursdayEnabled && 
          !_isFridayEnabled && !_isSaturdayEnabled) {
        _daysError = 'Please select at least one day';
      } else {
        _daysError = null;
      }
      _validateForm();
    });
  }

  void _validateTimes() {
    setState(() {
      if (_times.isEmpty) {
        _timesError = 'Please add at least one start time';
      } else {
        // Check for overlapping times
        final sortedTimes = List<ScheduleTime>.from(_times)
          ..sort((a, b) => a.time.compareTo(b.time));
        
        for (var i = 0; i < sortedTimes.length - 1; i++) {
          final currentTime = _parseTime(sortedTimes[i].time);
          final nextTime = _parseTime(sortedTimes[i + 1].time);
          
          // Calculate total minutes for each schedule
          final currentEndMinutes = currentTime + _calculateTotalDuration();
          
          if (currentEndMinutes > nextTime) {
            _timesError = 'Schedule times overlap';
            break;
          } else {
            _timesError = null;
          }
        }
      }
      _validateForm();
    });
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  int _calculateTotalDuration() {
    return _zones.where((z) => z.isEnabled).fold(0, (sum, zone) => sum + zone.duration);
  }

  void _validateForm() {
    setState(() {
      _isValid = _nameError == null && _daysError == null && _timesError == null;
    });
  }

  void _onDayChanged() {
    _validateDays();
  }

  void _onTimeChanged() {
    _validateTimes();
  }

  Future<void> _save() async {
    _validateName();
    _validateDays();
    _validateTimes();

    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_nameError ?? _daysError ?? _timesError ?? 'Please fix validation errors'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Clean up zones:
    // - Set disabled zones to zero duration
    // - Treat zero duration as disabled
    final cleanedZones = _zones.map((zone) => 
      zone.isEnabled && zone.duration > 0
          ? zone
          : zone.copyWith(isEnabled: false, duration: 0)
    ).toList();

    final schedule = ScheduleDetail(
      id: _id,
      name: _nameController.text,
      isEnabled: _isEnabled,
      type: _isDayBased ? ScheduleType.dayBased : ScheduleType.intervalBased,
      interval: _interval,
      restriction: _restriction,
      isWeatherAdjusted: _isWeatherAdjusted,
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
      zones: cleanedZones,
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
          SnackBar(
            content: StandardErrorWidget(
              message: 'Failed to save schedule: $e',
              type: ErrorType.network,
              showRetry: true,
              onPrimaryAction: _save,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNew = widget.schedule == null;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Discard Changes?'),
              content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Discard'),
                ),
              ],
            ),
          );
          if (shouldPop == true) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isNew ? 'New Schedule' : 'Edit Schedule'),
          actions: [
            if (!isNew)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => ConfirmScheduleDeleteDialog(
                      scheduleName: _nameController.text,
                      onConfirm: () async {
                        if (widget.schedule?.id != null) {
                          try {
                            await ref
                                .read(scheduleListNotifierProvider.notifier)
                                .deleteSchedule(widget.schedule!.id!);
                            if (mounted) {
                              Navigator.of(context).pop(true);
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: StandardErrorWidget(
                                    message: 'Failed to delete schedule: $e',
                                    type: ErrorType.network,
                                    showRetry: true,
                                    onPrimaryAction: () async {
                                      if (widget.schedule?.id != null) {
                                        await ref
                                            .read(scheduleListNotifierProvider.notifier)
                                            .deleteSchedule(widget.schedule!.id!);
                                        if (mounted) {
                                          Navigator.of(context).pop(true);
                                        }
                                      }
                                    },
                                  ),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                  );

                  if (confirmed == true && mounted) {
                    Navigator.of(context).pop(true);
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
              decoration: InputDecoration(
                labelText: 'Schedule Name',
                errorText: _nameError,
                helperText: 'Maximum 19 characters',
                counterText: '${_nameController.text.length}/19',
              ),
              maxLength: 19,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Schedule'),
              value: _isEnabled,
              onChanged: (value) => setState(() => _isEnabled = value),
            ),
            SwitchListTile(
              title: const Text('Weather Adjust'),
              subtitle: const Text('Automatically adjust watering time based on weather conditions'),
              value: _isWeatherAdjusted,
              onChanged: (value) => setState(() => _isWeatherAdjusted = value),
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
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(MaterialState.selected)) {
                              return theme.colorScheme.primary;
                            }
                            return null;
                          },
                        ),
                        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(MaterialState.selected)) {
                              return theme.colorScheme.surface;
                            }
                            return theme.colorScheme.onSurface;
                          },
                        ),
                        iconColor: MaterialStateProperty.resolveWith<Color?>(
                          (states) {
                            if (states.contains(MaterialState.selected)) {
                              return theme.colorScheme.surface;
                            }
                            return theme.colorScheme.onSurface;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isDayBased) ...[
                      Text('Days', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 8),
                      if (_daysError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            _daysError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      Wrap(
                        spacing: 8,
                        children: [
                          FilterChip(
                            label: const Text('Sun'),
                            selected: _isSundayEnabled,
                            onSelected: (value) {
                              setState(() {
                                _isSundayEnabled = value;
                                _onDayChanged();
                              });
                            },
                            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _isSundayEnabled 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Mon'),
                            selected: _isMondayEnabled,
                            onSelected: (value) {
                              setState(() {
                                _isMondayEnabled = value;
                                _onDayChanged();
                              });
                            },
                            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _isMondayEnabled 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Tue'),
                            selected: _isTuesdayEnabled,
                            onSelected: (value) {
                              setState(() {
                                _isTuesdayEnabled = value;
                                _onDayChanged();
                              });
                            },
                            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _isTuesdayEnabled 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Wed'),
                            selected: _isWednesdayEnabled,
                            onSelected: (value) {
                              setState(() {
                                _isWednesdayEnabled = value;
                                _onDayChanged();
                              });
                            },
                            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _isWednesdayEnabled 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Thu'),
                            selected: _isThursdayEnabled,
                            onSelected: (value) {
                              setState(() {
                                _isThursdayEnabled = value;
                                _onDayChanged();
                              });
                            },
                            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _isThursdayEnabled 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Fri'),
                            selected: _isFridayEnabled,
                            onSelected: (value) {
                              setState(() {
                                _isFridayEnabled = value;
                                _onDayChanged();
                              });
                            },
                            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _isFridayEnabled 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Sat'),
                            selected: _isSaturdayEnabled,
                            onSelected: (value) {
                              setState(() {
                                _isSaturdayEnabled = value;
                                _onDayChanged();
                              });
                            },
                            selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _isSaturdayEnabled 
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            ),
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
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return theme.colorScheme.primary;
                              }
                              return null;
                            },
                          ),
                          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return theme.colorScheme.surface;
                              }
                              return theme.colorScheme.onSurface;
                            },
                          ),
                          iconColor: MaterialStateProperty.resolveWith<Color?>(
                            (states) {
                              if (states.contains(MaterialState.selected)) {
                                return theme.colorScheme.surface;
                              }
                              return theme.colorScheme.onSurface;
                            },
                          ),
                        ),
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
                      children: [
                        Text(
                          'Start Times',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        if (_timesError != null)
                          Text(
                            _timesError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _times.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(_times[index].time),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                        DateTime.parse('2000-01-01 ${_times[index].time}:00'),
                                      ),
                                    );
                                    if (time != null && mounted) {
                                      setState(() {
                                        _times[index] = ScheduleTime(
                                          time: '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                          isEnabled: true,
                                        );
                                        _onTimeChanged();
                                      });
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _times.removeAt(index);
                                      _onTimeChanged();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.add_alarm),
                        label: const Text('Add Start Time'),
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: const TimeOfDay(hour: 6, minute: 0),
                          );
                          if (time != null && mounted) {
                            setState(() {
                              _times.add(ScheduleTime(
                                time: '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                                isEnabled: true,
                              ));
                              _onTimeChanged();
                            });
                          }
                        },
                      ),
                    ),
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
                      data: (zones) {
                        // Get list of enabled zones
                        final enabledZones = zones.where((z) => z.isEnabled).toList();
                        
                        if (enabledZones.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No enabled zones available.\nEnable zones in the Zones tab.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Zone durations list
                            ...enabledZones.map((zone) {
                              final index = zones.indexOf(zone);
                              final scheduleZone = _zones.length > index
                                  ? _zones[index]
                                  : ScheduleZone(
                                      duration: 15,
                                      isEnabled: false,
                                    );
                              
                              // Ensure _zones has enough entries
                              while (_zones.length <= index) {
                                _zones.add(ScheduleZone(
                                  duration: 15,
                                  isEnabled: false,
                                ));
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: scheduleZone.isEnabled && scheduleZone.duration > 0,
                                      onChanged: (value) => setState(() {
                                        _zones[index] = scheduleZone.copyWith(
                                          isEnabled: value ?? false,
                                          // Set a default duration of 15 minutes when enabling
                                          duration: value == true && scheduleZone.duration == 0 ? 15 : scheduleZone.duration,
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
                                        enabled: scheduleZone.isEnabled && scheduleZone.duration > 0,
                                        decoration: const InputDecoration(
                                          suffixText: 'min',
                                          isDense: true,
                                        ),
                                        onChanged: (value) {
                                          final minutes = int.tryParse(value) ?? 0;
                                          setState(() {
                                            _zones[index] = scheduleZone.copyWith(
                                              duration: minutes.clamp(0, 255),
                                              // Disable the zone if duration is set to 0
                                              isEnabled: minutes > 0 && scheduleZone.isEnabled,
                                            );
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
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
                onPressed: () async {
                  if (_hasChanges) {
                    final shouldDiscard = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Discard Changes?'),
                        content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Discard'),
                          ),
                        ],
                      ),
                    );
                    if (shouldDiscard != true) return;
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _hasChanges ? _save : null,
                child: const Text('Save'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
} 