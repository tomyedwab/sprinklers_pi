# Advanced (Advanced.htm)

## Overview
The Advanced page provides access to system diagnostics, debugging tools, and system-level operations. This page contains powerful features that should be used with caution as they can significantly affect system operation.

## Features

### Weather Provider Diagnostics
- Access detailed weather provider information
- Test weather service connectivity
- View raw weather data
- Troubleshoot weather-based adjustments

### Chatter Box
- System messaging interface
- View system events and notifications
- Debug communication issues
- Monitor system status

### System Operations

#### Reset System
- Performs a complete system reset
- Requires confirmation before execution
- Maintains configuration but restarts all services
- Endpoint: `/bin/reset`
- Use when system becomes unresponsive

#### Factory Defaults
- Resets all settings to factory default values
- Requires confirmation before execution
- **WARNING**: This will erase all custom configurations
- Endpoint: `/bin/factory`
- Use for complete system restoration

## Technical Details
- All operations require user confirmation
- AJAX-based execution of commands
- Error handling with user notifications
- Immediate feedback on operation status

## Security Considerations
- Access to these features should be restricted
- Operations can disrupt system functionality
- Factory reset cannot be undone
- System reset may cause temporary service interruption

## Use Cases
1. Troubleshooting weather-based adjustments
2. Debugging system issues
3. Complete system restoration
4. Emergency system recovery 