import 'package:flutter/material.dart';
import '../../../widgets/app_button.dart';

/// Widget displaying CTA to generate course and quiz
class GenerateAiOutputSection extends StatelessWidget {
  final bool isGenerating;
  final VoidCallback onGenerate;
  final bool needsSync;

  const GenerateAiOutputSection({
    super.key,
    required this.isGenerating,
    required this.onGenerate,
    this.needsSync = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.3),
            theme.colorScheme.primaryContainer.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  needsSync ? Icons.sync : Icons.auto_awesome,
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      needsSync ? 'Update Course & Quiz' : 'Generate Course & Quiz',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      needsSync
                          ? 'Your project links have changed. Update to get the latest content.'
                          : 'Transform your project links into a structured course and interactive quiz.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Feature highlights
          if (!needsSync) ...[
            _buildFeatureItem(
              context,
              icon: Icons.school,
              title: 'Structured Course',
              description: 'Automatically organized lessons from your content',
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              context,
              icon: Icons.quiz,
              title: 'Interactive Quiz',
              description: 'Test your knowledge with generated questions',
            ),
            const SizedBox(height: 20),
          ],

          // CTA Button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              text: isGenerating
                  ? (needsSync ? 'Updating...' : 'Generating...')
                  : (needsSync ? 'Update Now' : 'Generate Now'),
              onPressed: isGenerating ? null : onGenerate,
              isLoading: isGenerating,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
