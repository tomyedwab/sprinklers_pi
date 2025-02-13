# Zones Configuration (Zones.htm)

## Overview
The Zones page provides an interface for configuring individual sprinkler zones in the system. Each zone represents a separate section of the irrigation system that can be controlled independently.

## Features

### Zone Management
Each zone has the following configurable properties:
- **Name**: A customizable name for the zone (up to 19 characters)
- **Enabled/Disabled Status**: Toggle to enable or disable the zone
- **Pump Setting**: Option to associate a pump with the zone

### Interface Elements
- Zones are displayed in a collapsible list format
- Each zone is numbered sequentially (Zone 1, Zone 2, etc.)
- Disabled zones are visually distinguished with italic text
- Changes are saved using an "OK" button in the header

## Technical Details
- Uses AJAX to load zone configuration data from `/json/zones`
- Saves zone configuration through `/bin/setZones` endpoint
- Dynamic form generation based on number of configured zones
- Responsive collapsible UI elements using jQuery Mobile
- Form validation ensures proper data entry

## State Management
- Zone states are preserved between sessions
- Changes are applied immediately upon submission
- Error handling includes user notification on save failures 