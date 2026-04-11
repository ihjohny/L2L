import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/repositories/project_repository.dart';
import '../../../../data/models/quiz_model.dart';
import 'quiz_questions_state.dart';

/// ViewModel for managing quiz questions and timer.
///
/// Handles loading quiz data, navigating between questions,
/// tracking answers, and managing the quiz timer.
class QuizQuestionsViewModel
    extends StateNotifier<QuizQuestionsState> {
  final ProjectRepository _projectRepository;
  Timer? _timer;

  QuizQuestionsViewModel(this._projectRepository)
      : super(const QuizQuestionsState());

  /// Load a quiz by project ID.
  Future<void> loadQuiz(String projectId) async {
    state = state.copyWith(
      isLoading: true,
      error: QuizQuestionsState.nullValue,
      currentQuestionIndex: 0,
      selectedAnswers: [],
      elapsedTime: Duration.zero,
      viewState: QuizViewState.questions,
      result: QuizQuestionsState.nullValue,
    );

    final result = await _projectRepository.getQuiz(projectId);
    if (!mounted) return;

    result.fold(
      (quiz) {
        // Initialize selected answers list with -1 (unanswered) for each question
        final initialAnswers = List<int>.filled(
          quiz.content.questions.length,
          -1,
        );

        state = state.copyWith(
          quiz: quiz,
          isLoading: false,
          selectedAnswers: initialAnswers,
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

  /// Initialize ViewModel with existing quiz data (no API call).
  ///
  /// Used when quiz data is already available from another ViewModel
  /// to avoid redundant API calls.
  void initializeWithQuiz(QuizModel quiz) {
    // Initialize selected answers list with -1 (unanswered) for each question
    final initialAnswers = List<int>.filled(
      quiz.content.questions.length,
      -1,
    );

    state = state.copyWith(
      quiz: quiz,
      isLoading: false,
      currentQuestionIndex: 0,
      selectedAnswers: initialAnswers,
      elapsedTime: Duration.zero,
      viewState: QuizViewState.questions,
      result: QuizQuestionsState.nullValue,
      error: QuizQuestionsState.nullValue,
    );
  }

  /// Start the quiz timer.
  void startTimer() {
    if (state.isTimerRunning) return;

    state = state.copyWith(isTimerRunning: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Critical: Check mounted before any operation
      if (!mounted) {
        timer.cancel();
        _timer = null;
        return;
      }

      final newElapsedTime = state.elapsedTime + const Duration(seconds: 1);
      state = state.copyWith(elapsedTime: newElapsedTime);
    });
  }

  /// Stop the quiz timer and update state.
  void stopTimer() {
    _cancelTimer();
    state = state.copyWith(isTimerRunning: false);
  }

  /// Cancel timer without updating state (for dispose).
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  /// Reset the quiz timer.
  void resetTimer() {
    stopTimer();
    state = state.copyWith(elapsedTime: Duration.zero);
  }

  /// Select an option for the current question.
  void selectOption(int optionIndex) {
    final updatedAnswers = List<int>.from(state.selectedAnswers);

    // Update the answer for the current question
    if (state.currentQuestionIndex < updatedAnswers.length) {
      updatedAnswers[state.currentQuestionIndex] = optionIndex;
    }

    state = state.copyWith(
      selectedOptionIndex: optionIndex,
      selectedAnswers: updatedAnswers,
    );
  }

  /// Navigate to a specific question by index.
  void goToQuestion(int questionIndex) {
    final quiz = state.quiz;
    if (quiz == null || !quiz.hasQuestions) return;

    final questions = quiz.content.questions;
    if (questionIndex < 0 || questionIndex >= questions.length) return;

    // Get the selected answer for this question
    final selectedAnswer = questionIndex < state.selectedAnswers.length
        ? state.selectedAnswers[questionIndex]
        : null;

    state = state.copyWith(
      currentQuestionIndex: questionIndex,
      selectedOptionIndex: selectedAnswer != -1 ? selectedAnswer : null,
    );
  }

  /// Navigate to the next question.
  void goToNextQuestion() {
    if (!state.hasNextQuestion) return;
    goToQuestion(state.currentQuestionIndex + 1);
  }

  /// Navigate to the previous question.
  void goToPreviousQuestion() {
    if (!state.hasPreviousQuestion) return;
    goToQuestion(state.currentQuestionIndex - 1);
  }

  /// Submit the quiz and calculate results.
  void submitQuiz() {
    final quiz = state.quiz;
    if (quiz == null) return;

    // Stop the timer
    stopTimer();

    // Calculate correct answers
    int correctCount = 0;
    final questions = quiz.content.questions;

    for (int i = 0; i < questions.length && i < state.selectedAnswers.length; i++) {
      final question = questions[i];
      final selectedAnswer = state.selectedAnswers[i];

      if (selectedAnswer == question.correct) {
        correctCount++;
      }
    }

    // Create result
    final result = QuizResult(
      totalQuestions: questions.length,
      correctAnswers: correctCount,
      timeTaken: state.elapsedTime,
      selectedAnswers: List.from(state.selectedAnswers),
    );

    state = state.copyWith(
      viewState: QuizViewState.result,
      result: result,
    );
  }

  /// Navigate back to questions from result view.
  void backToQuestions() {
    state = state.copyWith(
      viewState: QuizViewState.questions,
      result: QuizQuestionsState.nullValue,
    );
  }

  /// Restart the quiz.
  void restartQuiz() {
    final quiz = state.quiz;
    if (quiz == null) return;

    // Reset all answers
    final initialAnswers = List<int>.filled(
      quiz.content.questions.length,
      -1,
    );

    resetTimer();
    state = state.copyWith(
      currentQuestionIndex: 0,
      selectedAnswers: initialAnswers,
      selectedOptionIndex: null,
      viewState: QuizViewState.questions,
      result: QuizQuestionsState.nullValue,
      error: QuizQuestionsState.nullValue,
    );
  }

  /// Clear error message.
  void clearError() {
    state = state.copyWith(error: QuizQuestionsState.nullValue);
  }

  /// Reset state when navigating away.
  void reset() {
    stopTimer();
    state = const QuizQuestionsState();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}

/// Provider for QuizQuestionsViewModel.
/// Auto-disposes when the screen is popped to prevent data leakage.
final quizQuestionsViewModelProvider = StateNotifierProvider.autoDispose<
    QuizQuestionsViewModel, QuizQuestionsState>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return QuizQuestionsViewModel(repository);
});
