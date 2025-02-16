# Flutter Migration Plan

## Overview
This document outlines the plan to convert the existing Sprinklers Pi web interface into a Flutter mobile application for Android, iOS, and web platforms. The migration will maintain all existing functionality while providing a native cross-platform experience.

## FLUTTER-1: Project Setup and Infrastructure Epic

FLUTTER-101: Development Environment Setup (Assigned: Luis Rodriguez. Status: Done)
- Set up Flutter SDK and Dart development environment
- Configure Android Studio/VS Code with Flutter plugins
- Create new Flutter project with null safety enabled
- Set up static analysis and code formatting (dartfmt)
- Configure testing framework (Flutter test)

FLUTTER-102: API Integration Layer (Assigned: David Kim. Status: Done)
- Create API client service using Dio or http package
- Implement Dart type definitions and models using freezed
- Create API endpoint constants
- Implement error handling middleware
- Add network status monitoring using Connectivity Plus

FLUTTER-103: State Management Setup (Assigned: Maya Patel. Status: Done)
- Implement Provider/Riverpod or Bloc for state management
- Create state models for:
  - Zone states
  - Schedule management
  - System settings
  - Weather data
- Set up Hive or SharedPreferences for offline capabilities

## FLUTTER-2: Core Widgets and Navigation Epic

FLUTTER-201: Navigation Structure (Assigned: Maya Patel. Status: Done)
- Implement Flutter Navigation 2.0
- Create bottom navigation bar for main sections:
  - Dashboard
  - Zones
  - Schedules
  - Settings
- Implement named routes for detailed views

FLUTTER-202: Shared Widgets (Assigned: David Kim. Status: Done)
1. **Zone Toggle Widget** (`ZoneToggleWidget`)
   - Handles 0-based ID ↔ API ID conversion (0→'za')
   - Visual states: Active/Inactive/Disabled
   - Pump association indicator
   - Unified tap/long-press handling
   - Required props: `zoneId`, `isEnabled`, `isRunning`, `hasPumpAssociation`
2. **Duration Picker** (`DurationPickerDialog`)
   - Combines TimePicker with duration limits
   - Validation: 1-360 minutes
   - API serialization helpers: `durationToApiFormat()`/`apiFormatToDuration()`
   - Preset quick-select buttons (15/30/60 mins)
3. **Day-of-Week Selector** (`DayOfWeekSelector`)
   - Compact 7-day grid layout
   - Multi-select support
   - Visual states: Selected/Disabled/Partial
   - Localization-ready (start week on Monday/Sunday)
   - Compact mode for dialog embedding
4. **Loading States** 
   - `ShimmerEffect` widget with configurable shimmer
   - `SkeletonCard` for dashboard items
   - `LoadingErrorRetry` with error message + retry button
5. **Confirmation Dialogs**
   - `ConfirmActionDialog` base component
   - Specialized versions:
     - `ConfirmZoneStopDialog`
     - `ConfirmScheduleDeleteDialog`
     - `ConfirmWeatherProviderChangeDialog`
6. **Error Messaging** (`StandardErrorWidget`)
   - Consistent error display
   - Retry/Cancel actions
   - Supports icon variants (network error vs validation error)
7. **Shared Widget Infrastructure**
   - `shared_widgets/` directory structure
   - Widget documentation (usage examples in Storybook format)
   - Test coverage (widget tests + golden tests)
   - Theme integration (uses ThemeData from FLUTTER-203)
### Out of Scope
- Form input fields (covered by FLUTTER-306)
- Navigation elements (covered by FLUTTER-201)
- Theme styling (handled by FLUTTER-203)

FLUTTER-203: Theme and Styling (Assigned: Aisha Mohammed. Status: Done)
- Create consistent Material/Cupertino design system
- Implement light/dark theme support using ThemeData
- Define color palette and typography
- Create custom icons using Flutter Icons
- Implement responsive and adaptive layouts

## FLUTTER-3: Feature Implementation Epic

FLUTTER-301: Dashboard Screen (Assigned: Maya Patel. Status: Done)
- System status display
- Active zone indicator
- Quick access controls
- Upcoming schedule display
- Weather information widget

FLUTTER-302: Zone Management (Assigned: David Kim, Status: Done)
- Zone list view
- Zone configuration screen
- Manual zone control
- Pump association settings
- Real-time status updates

FLUTTER-303: Schedule Management (Assigned: Maya Patel, Status: Done)
- Schedule list view
- Schedule creation/editing
- Time slot management
- Zone duration settings
- Schedule type selection (Day/Interval)
- Day restriction settings

FLUTTER-304: Quick Schedule Feature (Assigned: David Kim, Status: Done)
- Schedule selection
- Custom duration inputs
- Zone selection
- Immediate execution

FLUTTER-305: Logging and Diagnostics (Assigned: David Kim, Status: Done)
- Log viewer with filtering
- Graph visualization
- Weather diagnostics
- Chatter box functionality
- System maintenance options

FLUTTER-306: Application settings (Assigned: Maya Patel, Status: Done)
- Network settings
- Weather provider setup
- System adjustments
- Time synchronization
- Output configuration

## FLUTTER-4: Connection & Login

FLUTTER-401: Connection settings (Assigned: Luis Rodriguez, Status: Done)
- Local storage of connection settings
- Connection settings view

FLUTTER-402: Authentication (Assigned: Luis Rodriguez)
- Detect 302 response codes in API responses
- Web view for facilitating login
- Shared cookies between web view and API client
- Logout button on Settings screen

## FLUTTER-5: Background Services & Offline Support

FLUTTER-501: Background Services (Assigned: Luis Rodriguez)
- Push notifications using Firebase Cloud Messaging for:
  - Active watering
  - Schedule completion
  - System warnings
  - Weather alerts
- Background status monitoring using WorkManager

FLUTTER-502: Offline Support (Assigned: David Kim)
- Local data caching with Hive/SQLite
- Offline schedule viewing
- Queue changes for sync
- Conflict resolution

FLUTTER-503: Security Implementation (Assigned: Luis Rodriguez)
- Implement authentication
- Secure API communication
- Local data encryption
- Access control

FLUTTER-504: Performance Optimization (Assigned: Maya Patel)
- Implement lazy loading with ListView.builder
- Optimize large lists with Flutter's built-in virtualization
- Cache management
- Memory usage optimization using DevTools

## FLUTTER-6: Testing and Deployment Epic

FLUTTER-601: Testing Implementation (Assigned: James Wilson)
- Widget tests
- Integration tests with Flutter Driver
- Golden image tests
- Performance testing with DevTools
- Platform compatibility testing

FLUTTER-602: Beta Testing Management (Assigned: Sarah Chen)
- Internal testing phase
- Firebase App Distribution setup
- User feedback collection
- Bug tracking and fixes

FLUTTER-603: Documentation (Assigned: Sarah Chen)
- API integration docs
- Widget documentation
- Setup instructions
- User guide
- Troubleshooting guide

FLUTTER-604: Release Preparation (Assigned: Luis Rodriguez)
- Play Store and App Store listings
- Web deployment setup
- Marketing materials
- Release notes
- Version management
- Update strategy

## Timeline Estimates
- Phase 1: 2 weeks
- Phase 2: 3 weeks
- Phase 3: 6 weeks
- Phase 4: 4 weeks
- Phase 5: 3 weeks

Total estimated time: 18 weeks

## Success Criteria
1. All existing web UI functionality available across platforms
2. Improved user experience for touch interfaces
3. Offline capability for core functions
4. Real-time updates and notifications
5. Comprehensive test coverage
6. Successful deployment to Play Store, App Store, and web
