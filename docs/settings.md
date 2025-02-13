# Settings (Settings.htm)

## Overview
The Settings page provides configuration options for network connectivity, weather services, time synchronization, and system behavior. These settings are crucial for proper system operation and weather-based adjustments.

## Features

### Network Configuration
- **IP Address**: System IP address
- **Netmask**: Network subnet mask
- **Gateway**: Network gateway address
- **Web Port**: Port for web interface (0-32767)

### Weather Service Configuration
- **API Key**: Weather service API key
- **API ID**: Additional API identifier
- **API Secret**: API authentication secret
- **Location Type**: Choose between:
  - ZIP Code (US postal code)
  - PWS (Personal Weather Station)
- **Location Settings**:
  - ZIP Code (if ZIP selected)
  - PWS ID (if PWS selected)
  - Location Name (custom identifier)

### Time Synchronization
- **NTP IP**: Network Time Protocol server address
- **Timezone Offset**: UTC offset (-12 to +14 hours)

### System Adjustments
- **Seasonal Adjust**: Percentage adjustment (0-200%)
  - Affects all watering durations
  - Base value is 100%
  - Values below 100% reduce watering time
  - Values above 100% increase watering time

### Output Configuration
- **None**: No direct hardware control
- **Direct Positive**: Direct positive logic control
- **Direct Negative**: Direct negative logic control
- **OpenSprinkler**: OpenSprinkler hardware interface

## Technical Details
- Settings loaded via `/json/settings` endpoint
- Changes saved via `/bin/settings` endpoint
- Dynamic form field visibility based on configuration
- Real-time validation of input values
- Settings persist across system restarts

## Important Notes
- Changes only take effect after clicking "OK"
- Invalid settings may affect system operation
- Network changes may require system restart
- Weather service requires valid API credentials
- Time settings affect scheduling accuracy 