# Course Detail Page Implementation

**Feature:** Interactive Course Viewer with Lesson Navigation
**Date:** April 2026
**Status:** ✅ Implemented

## Overview

The Course Detail Page provides an interactive, user-friendly interface for viewing AI-generated courses lesson by lesson. Users can navigate through lessons, track their progress, and jump to specific lessons directly from the course list.

## Architecture

### Components

| File | Purpose |
|------|---------|
| `lib/presentation/viewmodels/course_detail/course_detail_state.dart` | Immutable state with lesson tracking, progress calculation, reading time estimation |
| `lib/presentation/viewmodels/course_detail/course_detail_viewmodel.dart` | Business logic for lesson navigation, course loading, reading time calculation |
| `lib/presentation/pages/course/course_detail_page.dart` | UI with progress stepper, lesson content, navigation controls |
| `lib/core/utils/navigation_triggers.dart` | Added `CourseNavigationTrigger` enum for state-based navigation |

### State Management

**CourseDetailState Properties:**
- `course`: Current course data
- `currentLessonIndex`: Active lesson (0-based)
- `estimatedReadingMinutes`: Calculated reading time (~200 words/minute)
- `isLoading`: Loading state
- `error`: Error message
- `navigationTrigger`: For navigation to quiz/back

**Computed Properties:**
- `currentLesson`: Get current lesson object
- `hasPreviousLesson`: Can navigate backward
- `hasNextLesson`: Can navigate forward
- `totalLessons`: Total number of lessons
- `progress`: Completion percentage (0.0 to 1.0)
- `formattedReadingTime`: Human-readable time string

## UI Features

### 1. Top Bar (AppBar)
- Project name as title
- Quiz button (icon) for direct navigation to quiz screen

### 2. Progress Stepper
- **Combined component** (no flicker animation):
  - Horizontal track line connecting all lesson dots
  - Progress fill showing completed portion
  - Interactive dots for each lesson:
    - Current lesson: Larger (32px), primary color
    - Completed lessons: Checkmark icon
    - Future lessons: Smaller (24px), neutral color
  - Tap any dot to jump directly to that lesson
- Lesson counter (e.g., "Lesson 2 of 5")
- Percentage completion display

### 3. Lesson Content
- Estimated reading time badge (calculated from content length)
- Current lesson title
- Full lesson content with proper typography

### 4. Navigation Controls
- Previous button (disabled on first lesson)
- Next button (disabled on last lesson)
- Bottom-aligned with SafeArea padding

## Navigation Flow

```
Project Detail Page
    ↓ (tap lesson in CourseSection)
Course Detail Page (at specific lesson)
    ↓ (tap dots in stepper)
Navigate to any lesson
    ↓ (tap quiz button)
Quiz Questions Page (with timer and progress)
    ↓ (complete quiz, submit)
Quiz Result View
    ↓ (tap Back or navigate away)
Return to Course Detail Page
```

## Routes

| Route | Parameters | Purpose |
|-------|-----------|---------|
| `/projects/:projectId/course` | `projectId` (path), `lesson` (query), `projectName` (extra) | View course with optional starting lesson |

**Example:** `/projects/abc123/course?lesson=2` starts at lesson 3 (0-indexed)

## Key Design Decisions

### 1. Combined Progress Component
- **Decision**: Merge progress bar and dots into single component
- **Rationale**: Cleaner UI, less visual clutter, better UX
- **Implementation**: Stack with track line, progress fill, and interactive dots

### 2. No Animation on Transitions
- **Decision**: Remove flicker animations, keep minimal
- **Rationale**: Prevent visual distraction, improve perceived performance
- **Implementation**: Direct state changes without AnimatedContainer

### 3. Reading Time Estimation
- **Algorithm**: Word count ÷ 200 words/minute = minutes (clamped 1-60)
- **Assumption**: Average adult reading speed
- **Display**: "X min read" format with clock icon

### 4. Lesson Navigation
- **Jump-to-lesson**: Supported via query parameter and stepper taps
- **Navigation controls**: Previous/Next buttons at bottom
- **State persistence**: Current lesson tracked in ViewModel state

### 5. Project Name Display
- **Decision**: Show project name instead of course title in toolbar
- **Rationale**: Consistent branding across course and quiz pages
- **Implementation**: Pass `projectName` parameter through navigation chain

## Integration Points

### Updated Files
1. `lib/core/router/app_router.dart` - Added course detail route with projectName support
2. `lib/presentation/pages/projects/widgets/course_section.dart` - Added projectId and projectName parameters, navigation to course detail
3. `lib/presentation/pages/projects/project_detail_page.dart` - Pass projectId and projectName to CourseSection

### Dependencies
- Uses existing `ProjectRepository.getCourse()` API
- Follows MVVM pattern with Riverpod StateNotifier
- Integrates with GoRouter for navigation

## Future Enhancements

- [x] Quiz screen integration ✅ (Implemented April 2026)
- [ ] Lesson completion tracking (mark lessons as done)
- [ ] Bookmarks/highlighting within lessons
- [ ] Font size controls
- [ ] Dark mode optimization
- [ ] Lesson search within course
- [ ] Print/export lesson feature

## Testing Checklist

- [x] Course loads successfully
- [x] Progress stepper displays correctly
- [x] Lesson navigation works (Previous/Next)
- [x] Jump to lesson via dots works
- [x] Jump to lesson from course list works
- [x] Reading time calculation is reasonable
- [x] Buttons disable correctly at boundaries
- [x] State persists during navigation
- [x] Error handling for missing course
- [x] Integration with quiz screen ✅ (Implemented April 2026)
- [x] Project name displays correctly in toolbar

## Files Changed

### Created
- `lib/presentation/viewmodels/course_detail/course_detail_state.dart`
- `lib/presentation/viewmodels/course_detail/course_detail_viewmodel.dart`
- `lib/presentation/pages/course/course_detail_page.dart`

### Modified
- `lib/core/utils/navigation_triggers.dart` (added CourseNavigationTrigger)
- `lib/core/router/app_router.dart` (added route with projectName support)
- `lib/presentation/pages/projects/widgets/course_section.dart` (navigation + projectId + projectName)
- `lib/presentation/pages/projects/project_detail_page.dart` (pass projectId and projectName)

## Related Documentation

- [Quiz Questions Page Implementation](quiz_questions_page.md) - Quiz system with timer and results
- [API Design](04_api_design.md) - Course API endpoints
- [Flutter MVP Implementation Guide](mvp/FLUTTER_MVP_IMPLEMENTATION_GUIDE.md) - MVVM pattern

---

**Last Updated:** April 11, 2026
**Implemented By:** Claude Code
