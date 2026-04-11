import '../../../../data/models/course_model.dart';
import '../../../../core/utils/navigation_triggers.dart';

/// Marker object to allow setting nullable values in copyWith.
class NullValue {
  const NullValue();
}

/// Immutable state for the CourseDetailViewModel.
class CourseDetailState {
  final CourseModel? course;
  final int currentLessonIndex;
  final bool isLoading;
  final String? error;
  final CourseNavigationTrigger navigationTrigger;

  /// Estimated reading time in minutes for the current lesson
  final int estimatedReadingMinutes;

  /// Marker for explicitly setting nullable values to null
  static const nullValue = NullValue();

  const CourseDetailState({
    this.course,
    this.currentLessonIndex = 0,
    this.isLoading = false,
    this.error,
    this.navigationTrigger = CourseNavigationTrigger.none,
    this.estimatedReadingMinutes = 0,
  });

  CourseDetailState copyWith({
    Object? course = nullValue,
    int? currentLessonIndex,
    bool? isLoading,
    Object? error = nullValue,
    CourseNavigationTrigger? navigationTrigger,
    int? estimatedReadingMinutes,
  }) {
    return CourseDetailState(
      course: course is NullValue ? this.course : course as CourseModel?,
      currentLessonIndex: currentLessonIndex ?? this.currentLessonIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error is NullValue ? this.error : error as String?,
      navigationTrigger: navigationTrigger ?? this.navigationTrigger,
      estimatedReadingMinutes:
          estimatedReadingMinutes ?? this.estimatedReadingMinutes,
    );
  }

  /// Get the current lesson
  CourseLesson? get currentLesson {
    if (course == null || !course!.hasLessons) return null;
    final lessons = course!.sortedLessons;
    if (currentLessonIndex < 0 || currentLessonIndex >= lessons.length) {
      return null;
    }
    return lessons[currentLessonIndex];
  }

  /// Check if there's a previous lesson
  bool get hasPreviousLesson => currentLessonIndex > 0;

  /// Check if there's a next lesson
  bool get hasNextLesson {
    if (course == null || !course!.hasLessons) return false;
    return currentLessonIndex < course!.sortedLessons.length - 1;
  }

  /// Get total number of lessons
  int get totalLessons => course?.lessonCount ?? 0;

  /// Get current progress (0.0 to 1.0)
  double get progress {
    if (totalLessons == 0) return 0.0;
    return (currentLessonIndex + 1) / totalLessons;
  }

  /// Check if course data is available
  bool get hasCourse => course != null;
}

/// Extension methods for CourseDetailState.
extension CourseDetailStateX on CourseDetailState {
  /// Get formatted estimated reading time
  String get formattedReadingTime {
    if (estimatedReadingMinutes <= 0) return '1 min read';
    if (estimatedReadingMinutes == 1) return '1 min read';
    return '$estimatedReadingMinutes min read';
  }
}
