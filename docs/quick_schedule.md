# Quick Schedule (QSched.htm)

## Overview
The Quick Schedule page provides a simplified interface for running one-time watering schedules. It allows users to either run an existing schedule once or create a custom quick run with specific zone durations.

## Features

### Schedule Selection
- **Existing Schedules**: Choose from any configured schedule
  - Shows all schedules (enabled and disabled)
  - Disabled schedules are marked with "(disabled)"
- **Custom Option**: Create a one-time custom watering pattern
  - Appears as "Custom" in the dropdown menu
  - Value of "-1" indicates custom schedule

### Custom Schedule Configuration
- Only appears when "Custom" is selected
- Configure duration for each enabled zone:
  - Zone number and name displayed
  - Duration range: 0-255 minutes
  - Individual sliders for each zone
  - Only enabled zones are shown

### Controls
- **OK Button**: Submits the quick schedule for immediate execution
- **Cancel Button**: Returns to main dashboard without changes

## Technical Details
- Uses AJAX for dynamic loading and execution
- Endpoints:
  - Load schedules: `/json/schedules`
  - Load zones: `/json/zones`
  - Execute quick schedule: `/bin/setQSched`
- Dynamic UI updates based on selection
- Error handling with user notifications

## State Management
- Schedule selection persists during page session
- Zone durations reset to 0 on page load
- Changes take effect immediately upon submission
- Automatic return to dashboard after successful execution

## Use Cases
1. Run an existing schedule immediately without modifying the original
2. Create a one-time custom watering pattern
3. Quick test of specific zones with custom durations 