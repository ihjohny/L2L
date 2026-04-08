import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_model.freezed.dart';
part 'course_model.g.dart';

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

@freezed
class CourseContent with _$CourseContent {
  const factory CourseContent({
    required String title,
    required String description,
    @Default([]) List<CourseLesson> lessons,
  }) = _CourseContent;

  factory CourseContent.fromJson(Map<String, dynamic> json) =>
      _$CourseContentFromJson(json);
}

@freezed
class CourseModel with _$CourseModel {
  const CourseModel._();

  const factory CourseModel({
    required String id,
    required String projectId,
    required CourseContent content,
    required DateTime createdAt,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id']?.toString() ?? json['id'] ?? '',
      projectId: json['projectId'] ?? json['sourceId'] ?? '',
      content: CourseContent.fromJson(json['content'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  factory CourseModel.empty() => CourseModel(
    id: '',
    projectId: '',
    content: const CourseContent(
      title: '',
      description: '',
      lessons: [],
    ),
    createdAt: DateTime.now(),
  );

  // Computed properties (directly on class, not extension)
  int get lessonCount => content.lessons.length;

  bool get hasLessons => content.lessons.isNotEmpty;

  List<CourseLesson> get sortedLessons {
    final lessons = List<CourseLesson>.from(content.lessons);
    lessons.sort((a, b) => a.order.compareTo(b.order));
    return lessons;
  }
}
