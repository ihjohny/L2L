import 'package:flutter/material.dart';
import '../../../data/models/quiz_model.dart';

/// Widget for displaying a quiz question card.
class QuizQuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final int questionNumber;
  final int? selectedOptionIndex;
  final bool showResult;
  final Function(int)? onOptionSelected;

  const QuizQuestionCard({
    super.key,
    required this.question,
    required this.questionNumber,
    this.selectedOptionIndex,
    this.showResult = false,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$questionNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    question.question,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Options
            ...List.generate(
              question.options.length,
              (index) => _buildOption(context, index),
            ).expand((element) => [element, const SizedBox(height: 8)]),
            // Explanation (shown after answer)
            if (showResult && question.explanation != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Explanation',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.explanation!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index) {
    final isSelected = selectedOptionIndex == index;
    final isCorrect = index == question.correct;
    final showCorrectness = showResult && isSelected;

    Color borderColor;
    Color backgroundColor;

    if (showCorrectness) {
      if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
      } else {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
      }
    } else if (isSelected) {
      borderColor = Theme.of(context).primaryColor;
      backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
    } else {
      borderColor = Colors.grey[300]!;
      backgroundColor = Colors.transparent;
    }

    return InkWell(
      onTap: showResult ? null : () => onOptionSelected?.call(index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected || (showCorrectness && isCorrect)
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected || (showCorrectness && isCorrect)
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400]!,
                ),
              ),
              child: Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question.options[index],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            if (showCorrectness && isCorrect)
              const Icon(Icons.check_circle, color: Colors.green),
            if (showCorrectness && !isCorrect && isSelected)
              const Icon(Icons.error, color: Colors.red),
          ],
        ),
      ),
    );
  }
}

/// Widget for displaying quiz result summary.
class QuizResultSummary extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const QuizResultSummary({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (correctAnswers / totalQuestions * 100).round();
    final isPassing = percentage >= 70;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              isPassing ? Icons.emoji_events : Icons.trending_up,
              size: 80,
              color: isPassing ? Colors.amber : Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              isPassing ? 'Congratulations!' : 'Keep Learning!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You scored $correctAnswers out of $totalQuestions',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Project'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Quiz'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
