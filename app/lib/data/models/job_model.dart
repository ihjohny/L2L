import 'package:freezed_annotation/freezed_annotation.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

enum JobStatus { waiting, active, completed, failed, delayed }

enum JobType { processLink, generateCourse }

@freezed
class JobModel with _$JobModel {
  const JobModel._();

  const factory JobModel({
    required String id,
    required String userId,
    required JobType type,
    required JobStatus status,
    @Default(0) int progress,
    Map<String, dynamic>? data,
    DateTime? processedAt,
    String? error,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _JobModel;

  factory JobModel.fromJson(Map<String, dynamic> json) =>
      _$JobModelFromJson(json);
}

// Extension methods for computed properties
extension JobModelX on JobModel {
  bool get isCompleted => status == JobStatus.completed;

  bool get isActive => status == JobStatus.active;

  bool get isFailed => status == JobStatus.failed;

  bool get isWaiting => status == JobStatus.waiting;

  bool get isDelayed => status == JobStatus.delayed;

  bool get isProcessing => isActive || isWaiting || isDelayed;

  String get statusDisplay {
    switch (status) {
      case JobStatus.waiting:
        return 'Waiting';
      case JobStatus.active:
        return 'Processing';
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.failed:
        return 'Failed';
      case JobStatus.delayed:
        return 'Delayed';
    }
  }
}

// Custom JSON converter for JobType to handle underscore variants
class JobTypeConverter implements JsonConverter<JobType, String> {
  const JobTypeConverter();

  @override
  JobType fromJson(String json) {
    // Handle both camelCase and snake_case variants
    final normalized = json.replaceAll('_', '');
    return JobType.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized.toLowerCase(),
      orElse: () => JobType.processLink,
    );
  }

  @override
  String toJson(JobType object) => object.name;
}
