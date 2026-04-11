import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

/// Represents a single lesson within a course.
@freezed
class CourseLesson with _$CourseLesson {
  const factory CourseLesson({
    required String title,
    required String content,
    required int order,
  }) = _CourseLesson;

  factory CourseLesson.fromJson(Map<String, dynamic> json) =>
      _$CourseLessonFromJson(json);
}

/// Represents a course generated from project links.
@freezed
class CourseModel with _$CourseModel {
  const CourseModel._();

  const factory CourseModel({
    @JsonKey(name: '_id') required String id,
    required CourseContent content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

/// Represents the content of a course.
@freezed
class CourseContent with _$CourseContent {
  const factory CourseContent({
    required String title,
    required String description,
    required List<CourseLesson> lessons,
  }) = _CourseContent;

  factory CourseContent.fromJson(Map<String, dynamic> json) =>
      _$CourseContentFromJson(json);
}

// Extension methods for computed properties
extension CourseModelX on CourseModel {
  /// Get the total number of lessons in the course.
  int get lessonCount => content.lessons.length;

  /// Check if the course has any lessons.
  bool get hasLessons => content.lessons.isNotEmpty;

  /// Get lessons sorted by order.
  List<CourseLesson> get sortedLessons {
    final lessons = List<CourseLesson>.from(content.lessons);
    lessons.sort((a, b) => a.order.compareTo(b.order));
    return lessons;
  }
}
