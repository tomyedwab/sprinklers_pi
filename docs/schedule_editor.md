# Schedule Editor (ShSched.htm)

## Overview
The Schedule Editor provides a comprehensive interface for creating and modifying watering schedules. It allows users to configure complex watering patterns with multiple time slots and zone-specific durations.

## Features

### Basic Settings
- **Schedule Name**: Custom name up to 19 characters
- **Enable/Disable**: Toggle to activate or deactivate the schedule
- **Schedule Type**: Choose between Day-based or Interval-based scheduling

### Day-based Scheduling
- **Days of Week**: Select specific days (Sunday through Saturday)
- **Restrictions**:
  - None (run on all selected days)
  - Odd Days only
  - Even Days only

### Interval-based Scheduling
- **Interval**: Set days between watering (1-20 days)
- Automatically alternates with day-based scheduling

### Time Settings
- Up to 3 start times per schedule
- Each time slot can be individually enabled/disabled
- Time input uses 24-hour format
- Independent control of each time slot

### Zone Duration Control
- Individual duration settings for each enabled zone
- Duration range: 0-255 minutes
- Only enabled zones are displayed
- Custom names from zone configuration are shown

## Controls
- **Save**: Applies changes and returns to schedule list
- **Cancel**: Discards changes and returns to schedule list
- **Delete**: Removes the schedule (only available for existing schedules)

## Technical Details
- Uses AJAX for dynamic loading and saving
- Endpoints:
  - Load schedule: `/json/schedule?id=ID`
  - Save schedule: `/bin/setSched`
  - Delete schedule: `/bin/delSched`
- Form validation ensures proper data entry
- Real-time UI updates based on user selections

## State Management
- Schedule settings are preserved between sessions
- Changes are applied immediately upon saving
- Error handling includes user notifications
- Automatic refresh of main schedule list after changes 