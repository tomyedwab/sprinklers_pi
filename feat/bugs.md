# Mobile App Bug Tracker

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