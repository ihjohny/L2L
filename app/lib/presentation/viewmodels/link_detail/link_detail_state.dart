import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../data/models/link_model.dart';

part 'link_detail_state.freezed.dart';

/// Immutable state for the LinkDetailViewModel.
@freezed
class LinkDetailState with _$LinkDetailState {
  const factory LinkDetailState({
    /// The selected link with complete data (including AI output)
    LinkModel? link,

    /// Whether the ViewModel is currently loading
    @Default(false) bool isLoading,

    /// Error message from the last failed operation
    String? error,

    /// Whether the content is being refreshed (pull-to-refresh)
    @Default(false) bool isRefreshing,
  }) = _LinkDetailState;

  /// Initial state
  factory LinkDetailState.initial() => const LinkDetailState(
        link: null,
        isLoading: true,
        error: null,
      );
}

/// Extension methods for LinkDetailState.
extension LinkDetailStateX on LinkDetailState {
  /// Whether link data is loaded
  bool get hasLink => link != null;

  /// Whether link is processed (completed with AI output)
  bool get isProcessed => link?.isProcessed ?? false;

  /// Whether link is processing
  bool get isProcessing => link?.isProcessing ?? false;

  /// Whether link failed
  bool get isFailed => link?.isFailed ?? false;
}
