# Mobile App Bug Tracker

## Schedules Screen Issues

### Critical Issues

1. **Race Condition in Schedule Toggle**
   - The `onToggle` callback in `_ScheduleListCard` directly updates the schedule without waiting for API response
   - No loading state during toggle operation
   - Could lead to UI state being out of sync with server state
   - Should show loading indicator and handle errors during toggle

2. **Memory Leak in Schedule Details Provider**
   - The `scheduleDetailsProvider` is watched for each schedule card
   - No cleanup/disposal of unused providers
   - Could accumulate memory usage with many schedules
   - Should implement proper provider disposal or use a different state management approach

3. **Inconsistent Error Handling**
   - Some errors show in SnackBar (schedule save)
   - Others show inline (schedule details loading)
   - No retry mechanism for failed schedule loads
   - Should standardize error handling approach across the screen

### Moderate Issues

4. **Inefficient Schedule List Updates**
   - The entire schedule list rebuilds when any schedule is toggled
   - Each schedule card watches its own details provider
   - Should use more granular state management
   - Consider using `ConsumerWidget` for individual cards

5. **Incomplete Form Validation**
   - Schedule name length limit (19 chars) only checked on save
   - No real-time validation feedback
   - No validation for overlapping schedule times
   - Should implement real-time validation with immediate feedback

6. **Time Format Inconsistency**
   - Schedule times stored in 24-hour format ("HH:MM")
   - Displayed using system locale format
   - Could cause confusion in time selection
   - Should standardize time display format or clearly indicate format

### Minor Issues

9. **Redundant State Management**
   - Schedule edit modal maintains its own state copy
   - Duplicates data from provider
   - Complex change detection logic
   - Should leverage existing state management

10. **Code Duplication**
    - Day formatting logic duplicated between list and edit views
    - Time formatting repeated in multiple places
    - Should extract common formatting logic to utilities

## Settings Screen Issues

### Critical Issues

1. **Potential Memory Leak in Form Controllers**
   - Form controllers are initialized in `initState` but listeners are never removed
   - Each controller's listener adds to `_hasUnsavedChanges` state
   - Should remove listeners in dispose method to prevent memory leaks
   - Add `removeListener(_onFormChanged)` for each controller in dispose

2. **Race Condition in Settings Update**
   - `ref.listen` updates form when settings change but doesn't check if user has unsaved changes
   - Could overwrite user's unsaved changes if settings are refreshed
   - Should prompt user before overwriting unsaved changes
   - Consider tracking original and current values separately

### Moderate Issues

4. **Inconsistent Error Handling**
   - Form validation errors show in SnackBar
   - Save errors show in SnackBar with retry
   - Network errors show in StandardErrorWidget
   - Should standardize error presentation across the screen

5. **State Management Complexity**
   - Both local state (`_hasUnsavedChanges`) and form controllers are used
   - Settings are stored in provider but also cached in form
   - Complex interaction between form state and provider state
   - Consider using FormProvider or similar to simplify state management

6. **Logout Flow Issues**
   - Cookie deletion and settings reset could fail independently
   - No error handling for cookie deletion
   - Navigation happens after async operations without mounted check
   - Should handle errors and ensure proper cleanup order

7. **Theme Usage Inconsistency**
   - Direct theme color access scattered throughout the code
   - Some colors hardcoded (e.g., Colors.white in logout button)
   - Inconsistent use of opacity values
   - Should extract theme values to constants or theme extension

### Potential Improvements

12. **Loading State Enhancement**
    - Skeleton loading doesn't match final layout exactly
    - No loading indicator during save operation
    - No partial form disable during operations
    - Consider more granular loading states

## Diagnostics Screen Issues

### Critical Issues

1. **Tab Controller Memory Leak Risk**
   - The `_tabController` in `DiagnosticsScreen` is only disposed in `dispose()`
   - If the screen rebuilds without being disposed, new controllers could be created without disposing old ones
   - Should dispose existing controller in `initState` before creating a new one
   - Add proper error handling for tab controller initialization

2. **Missing Error Handling in Log Viewer**
   - No error handling for failed log data fetches
   - No retry mechanism for network failures
   - No error state UI for failed data loads
   - Should implement proper error handling and recovery

### Moderate Issues

3. **Inconsistent Tab Styling**
   - Tab colors use direct theme access with opacity (`theme.colorScheme.secondary.withOpacity(0.7)`)
   - Inconsistent with app's theme extension pattern
   - Hard-coded opacity values could cause contrast issues
   - Should use theme extension for consistent styling

5. **Missing Loading States**
   - No loading indicators when switching tabs
   - No skeleton UI while data loads
   - Could appear unresponsive during data fetches
   - Should add proper loading feedback

## Connection Settings Screen Issues

### Minor Issues

8. **Theme Usage Inconsistency**
   - Direct theme color access scattered throughout the code
   - Some colors hardcoded (e.g., Colors.white)
   - Inconsistent use of opacity values
   - Should extract theme values to constants or theme extension

9. **Code Duplication**
   - Card decoration code duplicated between error and welcome states
   - Gradient configuration repeated
   - Theme text style access repeated
   - Should extract common widgets and styles