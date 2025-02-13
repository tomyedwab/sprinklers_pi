# Sprinklers Pi Frontend Documentation

## Overview
This documentation covers the web-based frontend interface of the Sprinklers Pi system. The frontend provides a comprehensive interface for managing and monitoring your irrigation system, with features ranging from basic zone control to advanced weather-based scheduling.

## Pages

### Core Functions
1. [Main Dashboard](index.md) - Central control interface and system status
2. [Zones Configuration](zones.md) - Configure and manage sprinkler zones
3. [Manual Control](manual.md) - Direct control of individual zones
4. [Schedules](schedules.md) - Manage watering schedules
5. [Schedule Editor](schedule_editor.md) - Create and modify detailed schedules
6. [Quick Schedule](quick_schedule.md) - One-time or immediate watering schedules

### System Management
7. [Settings](settings.md) - System configuration and preferences
8. [Logs](logs.md) - Activity monitoring and analysis
9. [Advanced](advanced.md) - System maintenance and debugging

### Diagnostic Tools
10. [Weather Check](weather_check.md) - Weather service diagnostics
11. [Chatter Box](chatter_box.md) - Hardware connection testing

## Technical Architecture

### Frontend Framework
- Built with jQuery Mobile 1.4.5
- Responsive design for desktop and mobile
- Support for light and dark themes

### Backend Communication
- RESTful API endpoints
- AJAX for real-time updates
- JSON data format

### Key Endpoints
- Zone Control: `/json/zones`, `/bin/manual`
- Scheduling: `/json/schedules`, `/bin/setSched`
- System: `/json/settings`, `/bin/settings`
- Weather: `/json/wcheck`
- Logging: `/json/logs`, `/json/tlogs`

## Getting Started
1. Start with the [Main Dashboard](index.md) to understand the basic interface
2. Configure your [Zones](zones.md) to match your physical setup
3. Set up [Schedules](schedules.md) for automated watering
4. Use [Settings](settings.md) to configure weather integration and system preferences
5. Monitor system activity through [Logs](logs.md)

## Important Notes
- Always use the "OK" or "Save" buttons to apply changes
- Test new configurations using Manual Control or Quick Schedule
- Back up your settings before using Factory Reset
- Monitor weather adjustments to optimize water usage 