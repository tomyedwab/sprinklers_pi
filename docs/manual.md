# Manual Control (Manual.htm)

## Overview
The Manual Control page provides direct, real-time control over individual sprinkler zones. It allows users to manually turn zones on and off without creating or modifying schedules.

## Features

### Zone Controls
- Individual on/off toggle switches for each enabled zone
- Displays custom zone names for easy identification
- Only shows enabled zones (disabled zones are hidden)
- Exclusive operation - only one zone can be active at a time

### Interface Elements
- Compact slider switches for each zone
- Mini-sized controls for efficient space usage
- Real-time state updates
- Simple back navigation to main dashboard

## Technical Details
- Uses AJAX to load zone data from `/json/zones`
- Controls zones through `/bin/manual` endpoint
- Dynamic control generation based on enabled zones
- Automatic state management ensures only one zone runs at a time
- Real-time feedback on zone state changes

## Operation Logic
- When turning on a zone:
  1. All other zones are automatically turned off
  2. The selected zone is activated
- Zone states are updated immediately upon user interaction
- Error handling includes communication failure notifications

## Security
- Only enabled zones are accessible through manual control
- Changes take effect immediately but don't affect scheduled operations 