import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/project_repository.dart';
import '../../../../data/models/course_model.dart';
import '../../../../core/utils/navigation_triggers.dart';
import 'course_detail_state.dart';

/// ViewModel for managing course details and lesson navigation.
///
/// Handles loading course data, navigating between lessons,
/// and calculating estimated reading times.
class CourseDetailViewModel
    extends StateNotifier<CourseDetailState> {
  final ProjectRepository _projectRepository;

  CourseDetailViewModel(this._projectRepository)
      : super(const CourseDetailState());

  /// Load a course by project ID.
  Future<void> loadCourse(String projectId) async {
    state = state.copyWith(
      isLoading: true,
      error: CourseDetailState.nullValue,
      currentLessonIndex: 0,
    );

    final result = await _projectRepository.getCourse(projectId);
    if (!mounted) return;

    result.fold(
      (course) {
        // Calculate estimated reading time for the first lesson
        final lessons = course.sortedLessons;
        final estimatedMinutes = lessons.isNotEmpty
            ? _calculateReadingTime(lessons[0].content)
            : 0;

        state = state.copyWith(
          course: course,
          isLoading: false,
          estimatedReadingMinutes: estimatedMinutes,
        );
      },
      (error) {
        state = state.copyWith(
          isLoading: false,
          error: error,
        );
      },
    );
  }

  /// Initialize ViewModel with existing course data (no API call).
  ///
  /// Used when course data is already available from ProjectDetailsViewModel
  /// to avoid redundant API calls.
  void initializeWithCourse(CourseModel course) {
    // Calculate estimated reading time for the first lesson
    final lessons = course.sortedLessons;
    final estimatedMinutes = lessons.isNotEmpty
        ? _calculateReadingTime(lessons[0].content)
        : 0;

    state = state.copyWith(
      course: course,
      isLoading: false,
      currentLessonIndex: 0,
      estimatedReadingMinutes: estimatedMinutes,
      error: CourseDetailState.nullValue,
    );
  }

  /// Navigate to a specific lesson by index.
  void goToLesson(int lessonIndex) {
    final course = state.course;
    if (course == null || !course.hasLessons) return;

    final lessons = course.sortedLessons;
    if (lessonIndex < 0 || lessonIndex >= lessons.length) return;

    final lesson = lessons[lessonIndex];
    final estimatedMinutes = _calculateReadingTime(lesson.content);

    state = state.copyWith(
      currentLessonIndex: lessonIndex,
      estimatedReadingMinutes: estimatedMinutes,
    );
  }

  /// Navigate to the next lesson.
  void goToNextLesson() {
    if (!state.hasNextLesson) return;
    goToLesson(state.currentLessonIndex + 1);
  }

  /// Navigate to the previous lesson.
  void goToPreviousLesson() {
    if (!state.hasPreviousLesson) return;
    goToLesson(state.currentLessonIndex - 1);
  }

  /// Calculate estimated reading time based on content length.
  ///
  /// Assumes average reading speed of 200 words per minute.
  int _calculateReadingTime(String content) {
    if (content.isEmpty) return 1;

    // Count words (split by whitespace)
    final wordCount = content.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;

    // Average reading speed: 200 words per minute
    const wordsPerMinute = 200;
    final minutes = (wordCount / wordsPerMinute).ceil();

    // Return at least 1 minute
    return minutes.clamp(1, 60);
  }

  /// Navigate to the quiz screen.
  void navigateToQuiz() {
    state = state.copyWith(
      navigationTrigger: CourseNavigationTrigger.toQuiz,
    );
  }

  /// Navigate back.
  void navigateBack() {
    state = state.copyWith(
      navigationTrigger: CourseNavigationTrigger.back,
    );
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(error: CourseDetailState.nullValue);
  }

  /// Reset navigation trigger.
  void resetNavigationTrigger() {
    state = state.copyWith(navigationTrigger: CourseNavigationTrigger.none);
  }

  /// Reset state when navigating away.
  void reset() {
    state = const CourseDetailState();
  }
}

/// Provider for CourseDetailViewModel.
/// Auto-disposes when the screen is popped to prevent data leakage.
final courseDetailViewModelProvider = StateNotifierProvider.autoDispose<
    CourseDetailViewModel, CourseDetailState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return CourseDetailViewModel(repository);
});
