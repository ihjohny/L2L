import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/quiz_questions/quiz_questions_viewmodel.dart';
import '../../viewmodels/quiz_questions/quiz_questions_state.dart';
import '../../../data/models/quiz_model.dart';

/// Quiz Questions Page - Displays quiz with timer and navigation.
///
/// Features:
/// - Timer showing elapsed time
/// - Progress stepper showing current question
/// - Question options with selection
/// - Previous/Next navigation controls
/// - Result view with score and time taken
class QuizQuestionsPage extends ConsumerStatefulWidget {
  final String projectId;
  final QuizModel? quiz;
  final String? projectName;

  const QuizQuestionsPage({
    super.key,
    required this.projectId,
    this.quiz,
    this.projectName,
  });

  @override
  ConsumerState<QuizQuestionsPage> createState() => _QuizQuestionsPageState();
}

class _QuizQuestionsPageState extends ConsumerState<QuizQuestionsPage> {
  late QuizQuestionsViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    // Get reference to ViewModel in initState to avoid issues in dispose
    _viewModel = ref.read(quizQuestionsViewModelProvider.notifier);

    Future.microtask(() {
      if (mounted) {
        // Use quiz data from parent if available
        if (widget.quiz != null) {
          _viewModel.initializeWithQuiz(widget.quiz!);
          // Start the timer automatically
          if (mounted) {
            _viewModel.startTimer();
          }
        } else {
          // Load quiz from API
          _viewModel.loadQuiz(widget.projectId).then((_) {
            if (mounted) {
              _viewModel.startTimer();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    // Note: Timer will be stopped automatically when ViewModel is disposed
    // We don't call stopTimer() here to avoid state modification during widget tree disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(quizQuestionsViewModelProvider.notifier);
    final state = ref.watch(quizQuestionsViewModelProvider);

    // Show loading state
    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show error state
    if (state.error != null || state.quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.error ?? 'Quiz not found',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(quizQuestionsViewModelProvider.notifier)
                      .loadQuiz(widget.projectId);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, state),
      body: state.viewState == QuizViewState.questions
          ? _buildQuestionsView(context, state, viewModel)
          : _buildResultView(context, state, viewModel),
    );
  }

  /// Build the app bar with timer
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    QuizQuestionsState state,
  ) {
    return AppBar(
      title: Text(widget.projectName ?? 'Quiz'),
      actions: [
        // Timer display
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                state.formattedElapsedTime,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build the questions view
  Widget _buildQuestionsView(
    BuildContext context,
    QuizQuestionsState state,
    QuizQuestionsViewModel viewModel,
  ) {
    return Column(
      children: [
        // Progress Stepper
        _buildProgressStepper(context, state),

        // Question Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildQuestionContent(context, state, viewModel),
          ),
        ),

        // Navigation Controls
        _buildNavigationControls(context, state, viewModel),
      ],
    );
  }

  /// Build the progress stepper showing question progress
  Widget _buildProgressStepper(BuildContext context, QuizQuestionsState state) {
    final theme = Theme.of(context);
    final totalQuestions = state.totalQuestions;
    final currentQuestion = state.currentQuestionNumber;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Header with progress info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question $currentQuestion of $totalQuestions',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(state.progress * 100).toInt()}% complete',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Interactive question stepper
          if (totalQuestions > 0) _buildQuestionStepper(context, state, theme),
        ],
      ),
    );
  }

  /// Build the interactive question stepper component
  Widget _buildQuestionStepper(
    BuildContext context,
    QuizQuestionsState state,
    ThemeData theme,
  ) {
    final totalQuestions = state.totalQuestions;

    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          // Background track line
          Positioned(
            top: 19,
            left: 12,
            right: 12,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),

          // Progress line (completed portion)
          if (totalQuestions > 1)
            Positioned(
              top: 19,
              left: 12,
              right: 12,
              child: FractionallySizedBox(
                widthFactor: (totalQuestions > 1 ? state.progress : 0),
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
            ),

          // Question dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalQuestions, (index) {
              final isActive = index == state.currentQuestionIndex;
              final isCompleted = index < state.currentQuestionIndex;
              final isAnswered = index < state.selectedAnswers.length &&
                  state.selectedAnswers[index] != -1;

              return GestureDetector(
                onTap: () {
                  ref
                      .read(quizQuestionsViewModelProvider.notifier)
                      .goToQuestion(index);
                },
                behavior: HitTestBehavior.opaque,
                child: _buildQuestionDot(
                  context,
                  index: index,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  isAnswered: isAnswered,
                  theme: theme,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build individual question dot with label
  Widget _buildQuestionDot(
    BuildContext context, {
    required int index,
    required bool isActive,
    required bool isCompleted,
    required bool isAnswered,
    required ThemeData theme,
  }) {
    final dotSize = isActive ? 32.0 : 24.0;
    final iconSize = isActive ? 16.0 : 12.0;

    // Determine color based on state
    Color dotColor;
    if (isActive) {
      dotColor = theme.colorScheme.primary;
    } else if (isAnswered) {
      dotColor = theme.colorScheme.primary.withOpacity(0.7);
    } else if (isCompleted) {
      dotColor = theme.colorScheme.surfaceContainerHighest;
    } else {
      dotColor = theme.colorScheme.surfaceContainerHighest;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: dotSize,
          height: dotSize,
          child: Container(
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: dotColor,
                width: 2,
              ),
            ),
            child: Center(
              child: isAnswered
                  ? Icon(
                      Icons.check,
                      color: theme.colorScheme.onPrimary,
                      size: iconSize,
                    )
                  : Text(
                      '${index + 1}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isActive
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build the question content section
  Widget _buildQuestionContent(
    BuildContext context,
    QuizQuestionsState state,
    QuizQuestionsViewModel viewModel,
  ) {
    final theme = Theme.of(context);
    final currentQuestion = state.currentQuestion;

    if (currentQuestion == null) {
      return const Center(
        child: Text('No question available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question label
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Question ${state.currentQuestionNumber}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Question text
              Row(
                children: [
                  Expanded(
                    child: Text(
                      currentQuestion.question,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Options
        Text(
          'Select an answer:',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 16),

        // Options list
        ...List.generate(currentQuestion.options.length, (optionIndex) {
          final option = currentQuestion.options[optionIndex];
          final isSelected = state.selectedOptionIndex == optionIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildOption(
              context,
              option: option,
              index: optionIndex,
              isSelected: isSelected,
              theme: theme,
              onTap: () {
                ref
                    .read(quizQuestionsViewModelProvider.notifier)
                    .selectOption(optionIndex);
              },
            ),
          );
        }),
      ],
    );
  }

  /// Build a single option
  Widget _buildOption(
    BuildContext context, {
    required String option,
    required int index,
    required bool isSelected,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Option indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.3),
                ),
              ),
              child: Center(
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      )
                    : Text(
                        String.fromCharCode(65 + index), // A, B, C, D...
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
              ),
            ),

            const SizedBox(width: 16),

            // Option text
            Expanded(
              child: Text(
                option,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the navigation controls (Previous/Next/Submit buttons)
  Widget _buildNavigationControls(
    BuildContext context,
    QuizQuestionsState state,
    QuizQuestionsViewModel viewModel,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Previous button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: state.hasPreviousQuestion
                    ? () => viewModel.goToPreviousQuestion()
                    : null,
                icon: const Icon(Icons.chevron_left),
                label: const Text('Previous'),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Next or Submit button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: state.selectedOptionIndex != null
                    ? () {
                        if (state.hasNextQuestion) {
                          viewModel.goToNextQuestion();
                        } else {
                          viewModel.submitQuiz();
                        }
                      }
                    : null,
                icon: Icon(
                  state.hasNextQuestion ? Icons.chevron_right : Icons.check,
                ),
                label: Text(
                  state.hasNextQuestion ? 'Next' : 'Submit',
                ),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                  backgroundColor: state.hasNextQuestion
                      ? null
                      : theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build the result view
  Widget _buildResultView(
    BuildContext context,
    QuizQuestionsState state,
    QuizQuestionsViewModel viewModel,
  ) {
    final theme = Theme.of(context);
    final result = state.result;

    if (result == null) {
      return const Center(child: Text('No result available'));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // Success icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              size: 60,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'Quiz Completed!',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Score display
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  result.formattedScore,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Score',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Details
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                _buildResultDetail(
                  context,
                  icon: Icons.check_circle_outline,
                  label: 'Correct Answers',
                  value: '${result.correctAnswers}/${result.totalQuestions}',
                  theme: theme,
                ),
                const Divider(height: 24),
                _buildResultDetail(
                  context,
                  icon: Icons.schedule,
                  label: 'Time Taken',
                  value: _formatDuration(result.timeTaken),
                  theme: theme,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Question Review Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Answer Review',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(state.totalQuestions, (index) {
                return _buildQuestionReviewItem(
                  context,
                  questionIndex: index,
                  result: result,
                  theme: theme,
                );
              }),
            ],
          ),

          const SizedBox(height: 32),

          // Retry Quiz Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => viewModel.restartQuiz(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Quiz'),
            ),
          ),
        ],
      ),
    ),
    );
  }

  /// Build a result detail row
  Widget _buildResultDetail(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Format duration as readable string
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes}m ${seconds}s';
  }

  /// Build a question review item for the result view
  Widget _buildQuestionReviewItem(
    BuildContext context, {
    required int questionIndex,
    required QuizResult result,
    required ThemeData theme,
  }) {
    final state = ref.watch(quizQuestionsViewModelProvider);
    final quiz = state.quiz;
    if (quiz == null || !quiz.hasQuestions) return const SizedBox();

    final question = quiz.content.questions[questionIndex];
    final selectedAnswer = result.selectedAnswers[questionIndex];
    final isCorrect = selectedAnswer == question.correct;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? theme.colorScheme.primaryContainer.withOpacity(0.3)
            : theme.colorScheme.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCorrect
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header with status
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isCorrect
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    isCorrect ? Icons.check : Icons.close,
                    color: theme.colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Question ${questionIndex + 1}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                isCorrect ? 'Correct' : 'Incorrect',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isCorrect
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Question text
          Text(
            question.question,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 12),

          // User's answer
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your answer: ${selectedAnswer >= 0 && selectedAnswer < question.options.length ? question.options[selectedAnswer] : 'Not answered'}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isCorrect
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // Show correct answer if wrong
          if (!isCorrect) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Correct answer: ${question.correct >= 0 && question.correct < question.options.length ? question.options[question.correct] : 'N/A'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Show explanation if available
          if (question.explanation != null && question.explanation!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Explanation',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.explanation!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
