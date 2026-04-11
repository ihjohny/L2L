import '../../../../data/models/quiz_model.dart';

/// Marker object to allow setting nullable values in copyWith.
class NullValue {
  const NullValue();
}

/// Represents the result of a completed quiz.
class QuizResult {
  final int totalQuestions;
  final int correctAnswers;
  final Duration timeTaken;
  final List<int> selectedAnswers;

  const QuizResult({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeTaken,
    required this.selectedAnswers,
  });

  /// Get the score percentage (0.0 to 1.0)
  double get scorePercentage =>
      totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;

  /// Get the score as a formatted string (e.g., "85%")
  String get formattedScore => '${(scorePercentage * 100).toInt()}%';
}

/// Quiz view state (questions or result)
enum QuizViewState { questions, result }

/// Immutable state for the QuizQuestionsViewModel.
class QuizQuestionsState {
  final QuizModel? quiz;
  final int currentQuestionIndex;
  final int? selectedOptionIndex;
  final List<int> selectedAnswers;
  final bool isLoading;
  final String? error;
  final QuizViewState viewState;
  final QuizResult? result;
  final Duration elapsedTime;
  final bool isTimerRunning;

  /// Marker for explicitly setting nullable values to null
  static const nullValue = NullValue();

  const QuizQuestionsState({
    this.quiz,
    this.currentQuestionIndex = 0,
    this.selectedOptionIndex,
    this.selectedAnswers = const [],
    this.isLoading = false,
    this.error,
    this.viewState = QuizViewState.questions,
    this.result,
    this.elapsedTime = Duration.zero,
    this.isTimerRunning = false,
  });

  QuizQuestionsState copyWith({
    Object? quiz = nullValue,
    int? currentQuestionIndex,
    Object? selectedOptionIndex = nullValue,
    List<int>? selectedAnswers,
    bool? isLoading,
    Object? error = nullValue,
    QuizViewState? viewState,
    Object? result = nullValue,
    Duration? elapsedTime,
    bool? isTimerRunning,
  }) {
    return QuizQuestionsState(
      quiz: quiz is NullValue ? this.quiz : quiz as QuizModel?,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedOptionIndex: selectedOptionIndex is NullValue
          ? this.selectedOptionIndex
          : selectedOptionIndex as int?,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      isLoading: isLoading ?? this.isLoading,
      error: error is NullValue ? this.error : error as String?,
      viewState: viewState ?? this.viewState,
      result: result is NullValue ? this.result : result as QuizResult?,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
    );
  }

  /// Get the current question
  QuizQuestion? get currentQuestion {
    if (quiz == null || !quiz!.hasQuestions) return null;
    final questions = quiz!.content.questions;
    if (currentQuestionIndex < 0 || currentQuestionIndex >= questions.length) {
      return null;
    }
    return questions[currentQuestionIndex];
  }

  /// Check if there's a previous question
  bool get hasPreviousQuestion => currentQuestionIndex > 0;

  /// Check if there's a next question
  bool get hasNextQuestion {
    if (quiz == null || !quiz!.hasQuestions) return false;
    return currentQuestionIndex < quiz!.content.questions.length - 1;
  }

  /// Get total number of questions
  int get totalQuestions => quiz?.questionCount ?? 0;

  /// Get current progress (0.0 to 1.0)
  double get progress {
    if (totalQuestions == 0) return 0.0;
    return (currentQuestionIndex + 1) / totalQuestions;
  }

  /// Check if current question has been answered
  bool get isCurrentQuestionAnswered {
    if (currentQuestionIndex >= selectedAnswers.length) return false;
    return selectedAnswers[currentQuestionIndex] != -1;
  }

  /// Check if all questions have been answered
  bool get areAllQuestionsAnswered {
    if (totalQuestions == 0) return false;
    return selectedAnswers.length == totalQuestions &&
        selectedAnswers.every((answer) => answer != -1);
  }

  /// Check if quiz data is available
  bool get hasQuiz => quiz != null;
}

/// Extension methods for QuizQuestionsState.
extension QuizQuestionsStateX on QuizQuestionsState {
  /// Get formatted elapsed time
  String get formattedElapsedTime {
    final minutes = elapsedTime.inMinutes;
    final seconds = elapsedTime.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get current question number (1-indexed)
  int get currentQuestionNumber => currentQuestionIndex + 1;
}
