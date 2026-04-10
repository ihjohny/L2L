import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/link_repository.dart';
import 'link_detail_state.dart';

/// ViewModel for link detail operations.
///
/// Manages single link data with complete AI output.
/// Fetches full link data including summary and flashcards.
class LinkDetailViewModel extends StateNotifier<LinkDetailState> {
  final LinkRepository _linkRepository;

  LinkDetailViewModel(this._linkRepository) : super(LinkDetailState.initial());

  /// Load a single link with complete data (including AI output).
  Future<void> loadLink(String linkId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _linkRepository.getLinkById(linkId);
    if (!mounted) return;
    result.fold(
      (link) {
        state = state.copyWith(
          link: link,
          isLoading: false,
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

  /// Refresh link data (pull-to-refresh).
  Future<void> refreshLink(String linkId) async {
    state = state.copyWith(isRefreshing: true, error: null);

    final result = await _linkRepository.getLinkById(linkId);
    if (!mounted) return;
    result.fold(
      (link) {
        state = state.copyWith(
          link: link,
          isRefreshing: false,
        );
      },
      (error) {
        state = state.copyWith(
          isRefreshing: false,
          error: error,
        );
      },
    );
  }

  /// Clear error.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset state when navigating away.
  void reset() {
    state = LinkDetailState.initial();
  }
}

/// Provider for LinkDetailViewModel.
final linkDetailViewModelProvider =
    StateNotifierProvider<LinkDetailViewModel, LinkDetailState>((ref) {
  final repository = ref.watch(linkRepositoryProvider);
  return LinkDetailViewModel(repository);
});
