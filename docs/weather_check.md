# Weather Check (WCheck.htm)

## Overview
The Weather Check page provides diagnostic information about the weather service integration and displays current weather data used for automatic schedule adjustments. This tool is essential for troubleshooting weather-based watering adjustments.

## Features

### Connection Status
- Displays weather provider connectivity status
- Shows resolved IP address of weather service
- Indicates API key validity
- Reports overall communication status

### Weather Data Display

#### Yesterday's Metrics
- **Temperature**:
  - Mean temperature in Fahrenheit and Celsius
- **Humidity**:
  - Minimum humidity percentage
  - Maximum humidity percentage
- **Precipitation**:
  - Rainfall in inches and millimeters
- **Wind**:
  - Speed in mph and meters per second

#### Today's Metrics
- **Precipitation**:
  - Current day's rainfall in inches and millimeters
- **UV Index**:
  - Current UV radiation level (scaled by 10)

### System Adjustments
- **Overall Scale**: Current weather-based adjustment percentage
  - Affects all watering durations
  - Based on weather conditions

## Technical Details
- Data retrieved from `/json/wcheck` endpoint
- Automatic unit conversion (imperial/metric)
- Real-time data updates
- Error handling for various failure conditions

## Error States
1. **No Provider**: Weather provider not defined in config.h
2. **Invalid Key**: Weather provider API key is not valid
3. **Invalid Response**: Weather provider returned invalid data
4. **Communications Failure**: Unable to reach weather service

## Use Cases
1. Verify weather service configuration
2. Debug weather-based watering adjustments
3. Monitor current weather conditions
4. Validate weather data accuracy 