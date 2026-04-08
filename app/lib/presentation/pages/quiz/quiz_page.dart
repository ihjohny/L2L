import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/quiz_model.dart';
import '../../../presentation/viewmodels/project_viewmodel.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/quiz_widgets.dart';

/// Page for displaying and taking a quiz.
class QuizPage extends ConsumerStatefulWidget {
  final String projectId;

  const QuizPage({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  int _currentQuestionIndex = 0;
  int? _selectedOptionIndex;
  bool _showResult = false;
  final Map<int, int> _answers = {};
  bool _quizCompleted = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(projectViewModelProvider);
    final quiz = state.selectedProjectQuiz;

    // Show loading while quiz data is being fetched
    if (quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const LoadingWidget(),
      );
    }

    if (quiz.content.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No quiz available',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Generate a quiz from the project page',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Project'),
              ),
            ],
          ),
        ),
      );
    }

    if (_quizCompleted) {
      return _buildQuizResult(context, quiz);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - Question ${_currentQuestionIndex + 1}/${quiz.questionCount}'),
        actions: [
          if (_currentQuestionIndex < quiz.questionCount - 1)
            TextButton(
              onPressed: _skipQuestion,
              child: const Text('Skip'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(context, quiz),
            const SizedBox(height: 24),
            // Current question
            QuizQuestionCard(
              question: quiz.content.questions[_currentQuestionIndex],
              questionNumber: _currentQuestionIndex + 1,
              selectedOptionIndex: _selectedOptionIndex,
              showResult: _showResult,
              onOptionSelected: _showResult ? null : _selectOption,
            ),
            const SizedBox(height: 24),
            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, QuizModel quiz) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            quiz.questionCount,
            (index) {
              final isAnswered = _answers.containsKey(index);
              final isCurrent = index == _currentQuestionIndex;
              final isCorrect = isAnswered &&
                  _answers[index] == quiz.content.questions[index].correct;

              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? Theme.of(context).primaryColor
                      : isAnswered
                          ? isCorrect
                              ? Colors.green
                              : Colors.red
                          : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrent || (isAnswered && isCorrect)
                          ? Colors.white
                          : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / quiz.questionCount,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (_showResult) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _previousQuestion,
              child: const Text('Previous'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextQuestion,
              child: Text(
                _currentQuestionIndex ==
                        ref.read(projectViewModelProvider).selectedProjectQuiz!.questionCount - 1
                    ? 'Submit Quiz'
                    : 'Next',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _selectedOptionIndex == null ? null : _confirmAnswer,
            child: const Text('Confirm Answer'),
          ),
        ),
      ],
    );
  }

  void _selectOption(int index) {
    setState(() {
      _selectedOptionIndex = index;
    });
  }

  void _confirmAnswer() {
    if (_selectedOptionIndex == null) return;

    setState(() {
      _answers[_currentQuestionIndex] = _selectedOptionIndex!;
      _showResult = true;
    });
  }

  void _nextQuestion() {
    final quiz = ref.read(projectViewModelProvider).selectedProjectQuiz;
    if (quiz == null) return;

    if (_currentQuestionIndex < quiz.questionCount - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = _answers[_currentQuestionIndex];
        _showResult = false;
      });
    } else {
      _completeQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedOptionIndex = _answers[_currentQuestionIndex];
        _showResult = true;
      });
    }
  }

  void _skipQuestion() {
    final quiz = ref.read(projectViewModelProvider).selectedProjectQuiz;
    if (quiz != null && _currentQuestionIndex < quiz.questionCount - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = _answers[_currentQuestionIndex];
        _showResult = false;
      });
    }
  }

  void _completeQuiz() {
    setState(() {
      _quizCompleted = true;
    });
  }

  Widget _buildQuizResult(BuildContext context, QuizModel quiz) {
    int correctAnswers = 0;
    for (final entry in _answers.entries) {
      final question = quiz.content.questions[entry.key];
      if (entry.value == question.correct) {
        correctAnswers++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            QuizResultSummary(
              totalQuestions: quiz.questionCount,
              correctAnswers: correctAnswers,
              onRetry: () {
                setState(() {
                  _currentQuestionIndex = 0;
                  _selectedOptionIndex = null;
                  _showResult = false;
                  _answers.clear();
                  _quizCompleted = false;
                });
              },
              onBack: () => context.pop(),
            ),
            const SizedBox(height: 24),
            // Review all questions
            Text(
              'Review Answers',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...quiz.content.questions.asMap().entries.map(
              (entry) => QuizQuestionCard(
                question: entry.value,
                questionNumber: entry.key + 1,
                selectedOptionIndex: _answers[entry.key],
                showResult: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
