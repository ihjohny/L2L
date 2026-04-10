import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/project_model.dart';

part 'add_link_state.freezed.dart';

/// Immutable state for the AddLinkViewModel.
@freezed
class AddLinkState with _$AddLinkState {
  const factory AddLinkState({
    /// Form field: URL (required)
    @Default('') String formUrl,

    /// Form field: Title (optional)
    @Default('') String formTitle,

    /// Form field: Tags (optional, comma-separated)
    @Default('') String formTags,

    /// Form field: Selected project ID (optional)
    String? formProjectId,

    /// New project name if creating a new project
    String? newProjectName,

    /// List of existing projects for autocomplete
    @Default([]) List<ProjectModel> projects,

    /// Whether the form is currently submitting
    @Default(false) bool isSubmitting,

    /// Error message from the last failed operation
    String? error,

    /// Whether form is valid for submission
    @Default(false) bool isValid,
  }) = _AddLinkState;

  /// Initial state
  factory AddLinkState.initial() => const AddLinkState(
        formUrl: '',
        formTitle: '',
        formTags: '',
        formProjectId: null,
        newProjectName: null,
        projects: [],
        isSubmitting: false,
        error: null,
        isValid: false,
      );
}

/// Extension methods for AddLinkState.
extension AddLinkStateX on AddLinkState {
  /// Whether URL is valid
  bool get hasValidUrl {
    if (formUrl.isEmpty) return false;
    try {
      final uri = Uri.parse(formUrl);
      return uri.isAbsolute;
    } catch (_) {
      return false;
    }
  }

  /// Whether the form can be submitted
  bool get canSubmit => !isSubmitting && hasValidUrl && isValid;

  /// Whether creating a new project
  bool get isCreatingNewProject =>
      newProjectName != null && newProjectName!.isNotEmpty;

  /// Get parsed tags as list
  List<String> get parsedTags {
    if (formTags.isEmpty) return [];
    return formTags
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }
}
