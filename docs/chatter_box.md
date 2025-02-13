# Chatter Box (ChatterBox.htm)

## Overview
The Chatter Box is a diagnostic tool that helps identify and verify physical connections between the controller and sprinkler valves/solenoids. It rapidly cycles a selected zone on and off, creating an audible and tactile feedback that helps locate and verify connections.

## Features

### Zone Testing
- Lists all enabled zones
- Individual buttons for each zone
- Shows custom zone names
- Rapid cycling of selected zone
- Audible/tactile feedback

### Interface
- Simple button-based interface
- Only displays enabled zones
- Clear visual feedback
- Easy navigation
- Mobile-friendly design

## Technical Details
- Loads zone data from `/json/zones` endpoint
- Controls zones through `/bin/chatter` endpoint
- Dynamic button generation based on enabled zones
- Real-time zone state updates
- Error handling for communication failures

## Use Cases
1. **Initial Setup**:
   - Identify which valve is connected to each zone
   - Verify wiring connections
   - Map physical locations to zone names

2. **Troubleshooting**:
   - Test valve operation
   - Verify solenoid functionality
   - Check electrical connections
   - Diagnose wiring issues

3. **Maintenance**:
   - Confirm system operation
   - Validate repairs
   - Test replacement parts

## Important Notes
- Only enabled zones are available for testing
- Rapid cycling may be audible through valves/solenoids
- Use sparingly to avoid wear on components
- Not intended for normal watering operation
- May require physical access to valves for verification 