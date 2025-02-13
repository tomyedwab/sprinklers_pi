# Logs (Logs.htm)

## Overview
The Logs page provides comprehensive visualization and analysis of sprinkler system activity. It offers both graphical and tabular views of watering history with various grouping and filtering options.

## Features

### View Types
- **Graph View**: Visual representation of watering data
- **Table View**: Detailed listing of watering events
- Toggle between views using radio buttons

### Graph View Features
- Interactive plot using Flot.js library
- Multiple grouping options:
  - **Hour**: Group by hour of day
  - **DOW**: Group by day of week
  - **Month**: Group by month
  - **None**: Show raw timeline
- Customizable zone selection
- Color-coded zones
- Resizable plot area

### Table View Features
- Organized by zones
- Collapsible sections for each zone
- Entry count display
- Detailed information for each watering event:
  - Time and date
  - Runtime duration (minutes:seconds)
  - Schedule type (M=Manual, Q=Quick, or schedule number)
  - Seasonal Adjustment (color-coded)
  - Weather Underground Adjustment (color-coded)

### Date Range Selection
- Start date picker
- End date picker
- Automatic date validation
- Default to last 7 days

### Controls
- **Back**: Return to main dashboard
- **Refresh**: Update displayed data
- Zone toggles for filtering

## Technical Details
- Endpoints:
  - Graph data: `/json/logs`
  - Table data: `/json/tlogs`
  - Zone information: `/json/zones`
- Dynamic data loading via AJAX
- Real-time graph updates
- Responsive design

## Data Visualization
### Graph Colors and Formatting
- Each zone has a unique color
- Bar charts for grouped data
- Line charts for timeline view
- Automatic scaling and labeling

### Table Formatting
- Color coding for adjustments:
  - Red background: Below 100%
  - Green background: Above 100%
  - No color: 100% or disabled (--) 