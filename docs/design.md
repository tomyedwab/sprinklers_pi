# Design Specification: Sprinkler Control Interface

## Color Palette
- Primary Background: `#94cccd` (Soft Teal)
- Accent Color: `#057257` (Deep Green)
- Card Background: `#f9fbfa` (Off-White)
- Text Color: `#141414` (Near Black)
- Icon Color: `#032e3f` (Deep Navy)

## System Controls Section
### Run Schedule Toggle
- Prominent switch component with white base color
- Accent color indicates active state
- Clear ON/OFF labeling
- Haptic feedback on toggle (mobile)

### Active Zone Display
- Large circular container with white background
- Animated sprinkler gif centered in circle
- Countdown timer below animation
- Progress ring using accent color `#86d8e6`
- Drop shadow: 
  - Offset: 2px Y-axis
  - Blur: 8px
  - Color: 15% opacity black
- Size: Approximately 40% of screen width

### Quick Actions
- "Manual Control" button
- "Quick Schedule" button
- Consistent styling with main interface
- Icon + text combination for clarity

## Information Cards
Cards use consistent styling across all sections:

### Card Design System
- Background: `#f9fbfa`
- Corner radius: 16px
- Padding: 16px
- Drop shadow:
  - Offset: 2px Y-axis
  - Blur: 6px
  - Color: 10% opacity black
- Icon alignment: Left-aligned
- Text alignment: Left-aligned with 12px spacing from icon

### 1. Upcoming Schedules Card
- Icon: Calendar symbol in `#032e3f`
- Title: "Upcoming Schedules"
- List view of scheduled runs
- Time indicators: "Today", "Tomorrow", or "X days"
- Scrollable if more than 3 items

### 2. System Status Card
- Icon: Status indicator in `#032e3f`
- Displays:
  - Current system time and date
  - Total zones configured
  - Total schedules configured
  - Software version
- Status indicators use appropriate colors for states

### 3. Navigation Menu Card
- Icon: Menu icon in `#032e3f`
- Quick access to main sections:
  - Schedules
  - Manual
  - Quick Schedule
  - Zones
  - Logs
  - Advanced
- Hover states use accent color

## Layout Specifications
- Active zone display centered in upper portion
- Status cards arranged on right side
- Navigation elements in fixed positions
- Spacing between cards: 12px
- Cards width: Approximately 30-35% of screen width
- Responsive behavior:
  - Cards stack vertically on mobile
  - Side-by-side layout on tablet/desktop
  - Controls maintain central position

## Typography Hierarchy
- Card Titles:
  - Size: 16px
  - Weight: 600 (semibold)
  - Color: `#141414`
- Card Content:
  - Size: 14px
  - Weight: 400 (regular)
  - Color: `#141414`
- System Status Text:
  - Size: 24px
  - Weight: 500 (medium)
  - Color: `#141414`
- Navigation Items:
  - Size: 16px
  - Weight: 500 (medium)
  - Color: `#141414`

## Accessibility Considerations
- Contrast ratio meets WCAG 2.1 AA standards
- Touch targets minimum 44x44px
- Icon + text combinations for better comprehension
- Sufficient spacing between interactive elements
- Clear visual hierarchy through size and weight
- Support for screen readers with proper ARIA labels
- Support for both light and dark themes

## Animation Guidelines
- Card hover: Subtle elevation increase
- Button interactions: Smooth transitions (200ms)
- Loading states: Gentle pulse animation
- State changes: Ease-in-out timing function
- Micro-interactions: Keep under 300ms for responsiveness
- Sprinkler animation: Smooth, continuous motion
- Progress indicators: Smooth updates

## Technical Implementation
- Built using jQuery Mobile 1.4.5 framework
- AJAX integration for real-time updates
- Responsive design principles
- Custom CSS for theming support
- Progressive enhancement for older browsers

This design system modernizes the existing interface while maintaining all core functionality, emphasizing clarity and ease of use while providing a modern, clean aesthetic appropriate for a smart home control interface. 