# Schedules (Scheds.htm)

## Overview
The Schedules page provides a central interface for managing all watering schedules in the system. It displays a list of all configured schedules and allows users to add new schedules or modify existing ones.

## Features

### Schedule List
- Displays all configured schedules
- Shows schedule names with visual indication of enabled/disabled status
- Disabled schedules are shown in italics with "(Disabled)" indicator
- Click any schedule to edit its details

### Controls
- **Back Button**: Returns to main dashboard
- **Add Button**: Creates a new schedule
- Each schedule entry links to detailed configuration page (ShSched.htm)

### Schedule Management
- View all configured schedules in one place
- Quick access to schedule details
- Visual status indicators
- Add new schedules easily

## Technical Details
- Loads schedule data from `/json/schedules` endpoint
- Dynamic list generation using jQuery Mobile listview
- Real-time updates when schedules are modified
- Seamless navigation to schedule editor

## State Management
- Schedule states (enabled/disabled) are visually reflected
- Changes in schedule configuration are immediately visible
- List automatically refreshes when returning to the page

## Navigation
- Direct access to individual schedule configuration
- Quick creation of new schedules
- Easy return to main dashboard 