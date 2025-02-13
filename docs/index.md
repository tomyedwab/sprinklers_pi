# Main Dashboard (index.htm)

## Overview
The main dashboard serves as the central control interface for the Sprinklers Pi system. It provides real-time status information and quick access to all major functions of the sprinkler system.

## Features

### System Controls
- **Run Schedules Toggle**: A slider switch to turn the entire scheduling system on/off
- **Active Zone Display**: Shows currently running zone with an animated sprinkler gif and countdown timer
- **Upcoming Schedules**: Displays a list of scheduled runs sorted by time, showing "Today", "Tomorrow", or number of days until next run

### Navigation Menu
The main menu provides access to the following sections:
1. **Schedules**: View and manage watering schedules
2. **Manual**: Manual control of zones
3. **Quick Schedule**: Set up quick one-time watering schedules
4. **Zones**: Configure and manage sprinkler zones
5. **Logs**: View system activity logs
6. **Advanced**: Access advanced system settings

### Status Information
- Displays current system time and date
- Shows total number of configured zones
- Shows total number of configured schedules
- Displays current software version

## Technical Details
- Built using jQuery Mobile 1.4.5 framework
- Uses AJAX to fetch real-time system state and schedule information
- Responsive design that works on both desktop and mobile devices
- Supports both light and dark themes through custom CSS 