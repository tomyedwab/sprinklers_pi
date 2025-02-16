# Sprinklers Pi API Documentation

## Overview
The Sprinklers Pi system provides a RESTful API for controlling and monitoring the irrigation system. All endpoints use HTTP GET requests and return JSON responses unless otherwise specified.

## Zone Management

### Get Zones
**Endpoint**: `/json/zones`  
**Method**: GET  
**Description**: Retrieves all configured zones and their current states.  
**Response Structure**:
```json
{
  "zones": [
    {
      "name": "string",      // Zone name (up to 19 chars)
      "enabled": "on|off",   // Zone enabled status
      "state": "on|off",     // Current running state
      "pump": "on|off"       // Pump association
    }
  ]
}
```
**Notes**:
- Zone IDs are 0-based internally but map to letters starting at 'b' in the API
- Zone 1 (index 0) maps to 'zb' in manual control and 'b' in settings
- Zone 2 (index 1) maps to 'zc' in manual control and 'c' in settings
- And so on...

**Possible Errors**:
- Communications failure

### Set Zones
**Endpoint**: `/bin/setZones`  
**Method**: GET  
**Parameters**:
- `z{b-z}name`: Zone name (string, max 19 chars)
- `z{b-z}e`: Zone enabled status ("on"/"off")
- `z{b-z}p`: Pump setting ("on"/"off")

Where {b-z} represents the zone ID (b=1, c=2, etc.)

**Notes**:
- Returns an empty response on success
- All zone parameters must be included in each request, even for zones not being modified

## Schedule Management

### Get All Schedules
**Endpoint**: `/json/schedules`  
**Method**: GET  
**Response Structure**:
```json
{
  "Table": [
    {
      "id": "number",        // Schedule ID
      "name": "string",      // Schedule name
      "e": "on|off",        // Enabled status
      "next": "string"      // Next run time description
    }
  ]
}
```

### Get Schedule Details
**Endpoint**: `/json/schedule`  
**Method**: GET  
**Parameters**:
- `id`: Schedule ID (number)  
**Response Structure**:
```json
{
  "name": "string",         // Schedule name
  "enabled": "on|off",      // Schedule enabled status
  "type": "on|off",        // Day-based (on) or Interval-based (off)
  "interval": "number",     // Days between runs (1-20)
  "restrict": "0|1|2",     // 0=None, 1=Odd days, 2=Even days
  "d1": "on|off",          // Sunday enabled
  "d2": "on|off",          // Monday enabled
  "d3": "on|off",          // Tuesday enabled
  "d4": "on|off",          // Wednesday enabled
  "d5": "on|off",          // Thursday enabled
  "d6": "on|off",          // Friday enabled
  "d7": "on|off",          // Saturday enabled
  "times": [
    {
      "t": "string",       // Time in HH:MM format
      "e": "on|off"        // Time slot enabled
    }
  ],
  "zones": [
    {
      "duration": "number", // Run time in minutes (0-255)
      "e": "on|off"        // Zone enabled in schedule
    }
  ]
}
```

### Set Schedule
**Endpoint**: `/bin/setSched`  
**Method**: GET  
**Parameters**:
- `id`: Schedule ID (-1 for new)
- `name`: Schedule name
- `enable`: Schedule enabled ("on"/"off")
- `type`: Schedule type ("on"=Day-based, "off"=Interval)
- `interval`: Days between runs (1-20)
- `restrict`: Day restrictions (0=None, 1=Odd, 2=Even)
- `d1`-`d7`: Day enabled status ("on"/"off")
- `t1`-`t3`: Start times (HH:MM)
- `e1`-`e3`: Time slot enabled ("on"/"off")
- `z{a-z}`: Zone duration (0-255 minutes)

### Delete Schedule
**Endpoint**: `/bin/delSched`  
**Method**: GET  
**Parameters**:
- `id`: Schedule ID to delete

## Manual Control

### Manual Zone Control
**Endpoint**: `/bin/manual`  
**Method**: GET  
**Parameters**:
- `zone`: Zone ID (zb-zz)
- `state`: Desired state ("on"/"off")

**Notes**:
- Zone IDs start at 'zb' for Zone 1, 'zc' for Zone 2, etc.
- Returns an empty response on success

### Quick Schedule
**Endpoint**: `/bin/setQSched`  
**Method**: GET  
**Parameters**:
- `sched`: Schedule ID or "-1" for custom
- `z{a-z}`: Zone duration for custom schedule (0-255 minutes)

## System Settings

### Get Settings
**Endpoint**: `/json/settings`  
**Method**: GET  
**Response Structure**:
```json
{
  "ip": "string",          // System IP address
  "netmask": "string",     // Network mask
  "gateway": "string",     // Network gateway
  "webport": "number",     // Web interface port
  "apikey": "string",      // Weather API key
  "wutype": "zip|pws",    // Weather location type
  "zip": "string",        // ZIP code (if wutype=zip)
  "pws": "string",        // PWS ID (if wutype=pws)
  "NTPip": "string",      // NTP server IP
  "NTPoffset": "number",  // Timezone offset
  "sadj": "number",       // Seasonal adjustment (0-200)
  "ot": "0|1|2|3"        // Output type
}
```

### Save Settings
**Endpoint**: `/bin/settings`  
**Method**: GET  
**Parameters**: All fields from settings structure above

### Get System State
**Endpoint**: `/json/state`  
**Method**: GET  
**Description**: Retrieves the current system state including version, running status, and active zone information.  
**Response Structure**:
```json
{
  "version": "string",       // System version
  "run": "on|off",          // Schedule running status
  "zones": "number",        // Number of enabled zones
  "schedules": "number",    // Number of schedules
  "timenow": "number",      // Current Unix timestamp
  "events": "number",       // Number of events
  "onzone": "string",       // Currently active zone name (if any)
  "offtime": "number"       // Seconds until current zone turns off (99999 for manual)
}
```

## Weather Integration

### Weather Check
**Endpoint**: `/json/wcheck`  
**Method**: GET  
**Response Structure**:
```json
{
  "noprovider": "true|false",    // No weather provider configured
  "keynotfound": "true|false",   // Invalid API key
  "valid": "true|false",         // Valid weather data
  "resolvedIP": "string",        // Weather service IP
  "scale": "number",             // Weather adjustment %
  "meantempi": "number",         // Mean temperature (F)
  "minhumidity": "number",       // Min humidity %
  "maxhumidity": "number",       // Max humidity %
  "precip": "number",            // Yesterday's precipitation
  "precip_today": "number",      // Today's precipitation
  "wind_mph": "number",          // Wind speed
  "UV": "number"                 // UV index (x10)
}
```

## System Maintenance

### System Reset
**Endpoint**: `/bin/reset`  
**Method**: GET  
**Description**: Restarts all services while maintaining settings

### Factory Reset
**Endpoint**: `/bin/factory`  
**Method**: GET  
**Description**: Resets all settings to factory defaults

### Chatter Box
**Endpoint**: `/bin/chatter`  
**Method**: GET  
**Parameters**:
- `zone`: Zone ID (zb-zz)
- `state`: Test state ("on"/"off") - Note: This parameter is required but does not affect functionality

**Description**: Test system communication for a specific zone. Used for debugging communication issues and monitoring system responses.

**Notes**:
- Zone IDs follow the same mapping as manual control (zb=Zone 1, zc=Zone 2, etc.)
- The state parameter is required by the API but does not affect the test functionality
- Check system logs to monitor the response

## Logging

### Graph Data
**Endpoint**: `/json/logs`  
**Method**: GET  
**Parameters**:
- `sdate`: Start timestamp (Unix timestamp in seconds)
- `edate`: End timestamp (Unix timestamp in seconds)
- `g`: Grouping (h=Hour, d=DOW, m=Month, n=None)

**Response Structure**:
```json
{
  "1": [                   // Zone ID as key (1-based)
    [
      1234567890000,      // Timestamp in milliseconds
      300                 // Duration in seconds
    ],
    // ... more data points
  ],
  "2": [
    // ... data points for zone 2
  ]
  // ... more zones
}
```

**Notes**:
- Response format varies based on grouping parameter
- Timestamps are in milliseconds for graph data
- Data is organized by zone ID (1-based)
- Each data point is an array of [timestamp, duration]
- Empty zones are omitted from response

### Table Data
**Endpoint**: `/json/tlogs`  
**Method**: GET  
**Parameters**:
- `sdate`: Start timestamp (Unix timestamp in seconds)
- `edate`: End timestamp (Unix timestamp in seconds)

**Response Structure**:
```json
{
  "logs": [
    {
      "zone": "number",          // Zone number (1-based)
      "entries": [
        {
          "date": "number",      // Unix timestamp in seconds
          "duration": "number",   // Run duration in seconds
          "schedule": "number",   // Schedule ID (-1=Manual, 100=Quick)
          "seasonal": "number",   // Seasonal adjustment percentage
          "wunderground": "number" // Weather adjustment percentage
        }
      ]
    }
  ]
}
```

**Notes**:
- Table data includes additional context for each run
- Timestamps are in seconds for table data
- Schedule ID special values:
  - -1: Manual run
  - 100: Quick schedule
  - Other: Regular schedule ID
- Adjustment percentages are relative to 100 (e.g., 80 = 80% reduction)
- Zones with no entries in the time range are omitted
- Entries are sorted by date in descending order

## Error Handling
All endpoints may return HTTP error codes:
- 400: Bad Request (invalid parameters)
- 404: Not Found
- 500: Internal Server Error

JSON responses may include error details in the response body. 