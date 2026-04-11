# Quiz Questions Page Implementation

**Feature:** Interactive Quiz with Timer and Progress Tracking
**Date:** April 2026
**Status:** ✅ Implemented

## Overview

The Quiz Questions Page provides an interactive quiz interface with real-time timer, progress tracking, and a comprehensive result view. Users can navigate between questions, see their progress, and receive detailed results including score, correct answers, and time taken.

## Architecture

### Components

| File | Purpose |
|------|---------|
| `lib/presentation/viewmodels/quiz_questions/quiz_questions_state.dart` | Immutable state with question tracking, timer, result calculation |
| `lib/presentation/viewmodels/quiz_questions/quiz_questions_viewmodel.dart` | Business logic for question navigation, timer management, quiz submission |
| `lib/presentation/pages/quiz/quiz_questions_page.dart` | UI with timer, progress stepper, question options, result view |

### State Management

**QuizQuestionsState Properties:**
- `quiz`: Current quiz data
- `currentQuestionIndex`: Active question (0-based)
- `selectedOptionIndex`: Selected option for current question
- `selectedAnswers`: List of all selected answers
- `isLoading`: Loading state
- `error`: Error message
- `viewState`: Current view (questions or result)
- `result`: Quiz result data (when completed)
- `elapsedTime`: Time taken so far
- `isTimerRunning`: Timer status

**Computed Properties:**
- `currentQuestion`: Get current question object
- `hasPreviousQuestion`: Can navigate backward
- `hasNextQuestion`: Can navigate forward
- `totalQuestions`: Total number of questions
- `progress`: Completion percentage (0.0 to 1.0)
- `isCurrentQuestionAnswered`: Check if current question has answer
- `areAllQuestionsAnswered`: Check if all questions answered
- `formattedElapsedTime`: Timer display (MM:SS format)

**QuizResult Class:**
- `totalQuestions`: Number of questions
- `correctAnswers`: Number of correct answers
- `timeTaken`: Duration taken to complete
- `scorePercentage`: Calculated score (0.0 to 1.0)
- `formattedScore`: Score as string (e.g., "85%")

## UI Features

### 1. Top Bar (AppBar)
- Project name as title
- Live timer display showing elapsed time (MM:SS format)
- Timer icon with primary color accent

### 2. Progress Stepper
- **Combined component** (matches course page style):
  - Horizontal track line connecting all question dots
  - Progress fill showing completed portion
  - Interactive dots for each question:
    - Current question: Larger (32px), primary color
    - Answered questions: Checkmark icon
    - Unanswered questions: Question number
    - Future questions: Smaller (24px), neutral color
  - Tap any dot to jump directly to that question
- Question counter (e.g., "Question 3 of 10")
- Percentage completion display

### 3. Question Content
- Question card with numbered label
- Question text
- Multiple choice options:
  - Letter labels (A, B, C, D...)
  - Visual selection feedback
  - Selected option highlighted with primary color
  - Disabled state when not selected

### 4. Navigation Controls
- Previous button (disabled on first question)
- Next/Submit button:
  - Shows "Next" for questions 1 to N-1
  - Shows "Submit" on last question
  - Disabled until an option is selected
- Bottom-aligned with SafeArea padding

### 5. Result View
- Trophy icon with celebration
- Score percentage (large display)
- Score breakdown card:
  - Correct answers count
  - Time taken (formatted)
- Action buttons:
  - Review Answers (returns to questions)
  - Retry Quiz (resets and starts over)

## Navigation Flow

```
Project Detail Page
    ↓ (tap "Start Quiz" in QuizSection)
Quiz Questions Page
    ↓ (answer questions, tap Next)
Navigate through questions
    ↓ (tap dots in stepper)
Jump to any question
    ↓ (complete all questions, tap Submit)
Result View
    ↓ (tap Review Answers or Retry Quiz)
Back to questions or restart
```

## Routes

| Route | Parameters | Purpose |
|-------|-----------|---------|
| `/projects/:projectId/quiz` | `projectId` (path), `quiz` (extra), `projectName` (extra) | Take quiz for a project |

**Example:** Navigate with cached data:
```dart
context.push(
  '/projects/$projectId/quiz',
  extra: {
    'quiz': quizModel,  // Optional: pass to avoid API call
    'projectName': 'My Project',
  },
);
```

## Key Design Decisions

### 1. Timer Implementation
- **Decision**: Auto-start timer when quiz loads, stop on submit
- **Rationale**: Track actual time taken, prevent gaming the system
- **Implementation**: `Timer.periodic` with 1-second intervals, stored in state
- **Display**: MM:SS format in app bar with icon

### 2. Progress Stepper
- **Decision**: Match course page design for consistency
- **Rationale**: Familiar UX, visual consistency across app
- **Implementation**: Same component structure as course page
- **States**: Current (large, primary), Answered (checkmark), Unanswered (number)

### 3. Answer Tracking
- **Decision**: Store all answers in state list, allow changing answers
- **Rationale**: Users may want to review and change answers before submitting
- **Implementation**: `selectedAnswers` list with -1 for unanswered
- **Validation**: Must select option before proceeding (Next/Submit disabled)

### 4. Result Calculation
- **Decision**: Calculate on submit, show comprehensive results
- **Rationale**: Immediate feedback, detailed breakdown
- **Implementation**: Compare selected answers with correct answers
- **Display**: Percentage, count, and time taken

### 5. Review vs Retry
- **Decision**: Separate actions for reviewing and restarting
- **Rationale**: Users may want to review answers before retaking
- **Implementation**: "Review Answers" returns to questions, "Retry Quiz" resets

## Integration Points

### Updated Files
1. `lib/core/router/app_router.dart` - Added quiz route with projectName support
2. `lib/presentation/pages/projects/widgets/quiz_section.dart` - Added projectId, projectName, navigation
3. `lib/presentation/pages/projects/project_detail_page.dart` - Pass projectName to QuizSection
4. `lib/presentation/pages/projects/widgets/course_section.dart` - Added projectName parameter
5. `lib/presentation/pages/course/course_detail_page.dart` - Pass projectName to quiz navigation

### Data Flow
- **From Project Details**: Quiz data passed via `extra` parameter to avoid redundant API call
- **From Course Details**: Project name passed to maintain consistent toolbar title
- **Answer Tracking**: All answers stored in state until submission
- **Timer**: Starts on load, stops on submit/restart/dispose

### Dependencies
- Uses existing `ProjectRepository.getQuiz()` API
- Follows MVVM pattern with Riverpod StateNotifier
- Integrates with GoRouter for navigation
- Timer management with Dart's `Timer` class

## Timer Management

### Lifecycle
```dart
// Start: Automatic when page loads (in initState)
// Stop: When quiz is submitted
// Reset: When user clicks "Retry Quiz"
// Dispose: When user leaves the page
```

### State Updates
- Timer updates `elapsedTime` every second
- `isTimerRunning` flag prevents multiple timers
- Timer cancelled in `dispose()` to prevent memory leaks

## Result Calculation

### Scoring Algorithm
```dart
correctCount = 0
for each question:
  if selectedAnswer == correctAnswer:
    correctCount++

scorePercentage = correctCount / totalQuestions
```

### Display
- Large percentage display (e.g., "85%")
- Correct answers count (e.g., "8/10")
- Time taken formatted (e.g., "3m 45s")

## Future Enhancements

- [ ] Question explanations after quiz completion
- [ ] Answer review with correct/incorrect highlighting
- [ ] Time limit per question (optional)
- [ ] Difficulty-based question ordering
- [ ] Skip question feature (mark for review)
- [ ] Share results feature
- [ ] Historical quiz performance
- [ ] Spaced repetition integration
- [ ] Dark mode optimization

## Testing Checklist

- [x] Quiz loads successfully
- [x] Timer starts automatically and updates every second
- [x] Progress stepper displays correctly
- [x] Question navigation works (Previous/Next)
- [x] Jump to question via dots works
- [x] Option selection works with visual feedback
- [x] Must select option before proceeding
- [x] Submit button appears on last question
- [x] Result calculation is accurate
- [x] Timer stops on submit
- [x] Result view displays correctly
- [x] Review Answers returns to questions
- [x] Retry Quiz resets everything
- [x] Project name displays correctly in toolbar
- [x] Error handling for missing quiz
- [x] Timer cleanup on page dispose

## Files Changed

### Created
- `lib/presentation/viewmodels/quiz_questions/quiz_questions_state.dart`
- `lib/presentation/viewmodels/quiz_questions/quiz_questions_viewmodel.dart`
- `lib/presentation/pages/quiz/quiz_questions_page.dart`

### Modified
- `lib/core/router/app_router.dart` (added quiz route, projectName support)
- `lib/presentation/pages/projects/widgets/quiz_section.dart` (added projectId, projectName, navigation)
- `lib/presentation/pages/projects/widgets/course_section.dart` (added projectName parameter)
- `lib/presentation/pages/projects/project_detail_page.dart` (pass projectName to sections)
- `lib/presentation/pages/course/course_detail_page.dart` (pass projectName to quiz)

## Related Documentation

- [Course Detail Page Implementation](course_detail_page.md) - Similar progress stepper design
- [API Design](04_api_design.md) - Quiz API endpoints
- [Flutter MVP Implementation Guide](mvp/FLUTTER_MVP_IMPLEMENTATION_GUIDE.md) - MVVM pattern

---

**Last Updated:** April 11, 2026
**Implemented By:** Claude Code
