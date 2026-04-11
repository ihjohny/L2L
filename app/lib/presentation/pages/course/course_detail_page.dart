import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/course_detail/course_detail_viewmodel.dart';
import '../../viewmodels/course_detail/course_detail_state.dart';
import '../../../core/utils/navigation_triggers.dart';
import '../../../data/models/course_model.dart';

/// Course Detail Page - Displays individual lessons with navigation.
///
/// Features:
/// - Top bar with quiz navigation button
/// - Progress stepper showing current lesson
/// - Lesson content with estimated reading time
/// - Previous/Next navigation controls
///
/// Optimization: Receives course data from ProjectDetailsViewModel
/// to avoid redundant API calls.
class CourseDetailPage extends ConsumerStatefulWidget {
  final String projectId;
  final int? initialLessonIndex;
  final CourseModel? course;
  final String? projectName;

  const CourseDetailPage({
    super.key,
    required this.projectId,
    this.initialLessonIndex,
    this.course,
    this.projectName,
  });

  @override
  ConsumerState<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends ConsumerState<CourseDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        final notifier = ref.read(courseDetailViewModelProvider.notifier);

        // Optimization: Use course data from ProjectDetailsViewModel if available
        // This avoids redundant API call when navigating from project details
        if (widget.course != null) {
          // Initialize with existing course data
          notifier.initializeWithCourse(widget.course!);

          // Navigate to initial lesson if provided
          if (widget.initialLessonIndex != null) {
            notifier.goToLesson(widget.initialLessonIndex!);
          }
        } else {
          // Fallback: Load course from API if not provided
          // (e.g., when accessed directly via URL)
          notifier.loadCourse(widget.projectId).then((_) {
            if (mounted && widget.initialLessonIndex != null) {
              notifier.goToLesson(widget.initialLessonIndex!);
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(courseDetailViewModelProvider.notifier);
    final state = ref.watch(courseDetailViewModelProvider);

    // Handle navigation triggers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.navigationTrigger != CourseNavigationTrigger.none) {
        switch (state.navigationTrigger) {
          case CourseNavigationTrigger.toQuiz:
            // Navigate to quiz screen
            context.push(
              '/projects/${widget.projectId}/quiz',
              extra: {
                'projectName': widget.projectName ?? state.course?.content.title ?? 'Course',
              },
            );
            break;
          case CourseNavigationTrigger.back:
            context.pop();
            break;
          default:
            break;
        }
        viewModel.resetNavigationTrigger();
      }
    });

    // Show loading state
    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show error state
    if (state.error != null || state.course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.error ?? 'Course not found',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(courseDetailViewModelProvider.notifier)
                      .loadCourse(widget.projectId);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, state, viewModel),
      body: Column(
        children: [
          // Progress Stepper
          _buildProgressStepper(context, state),

          // Lesson Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildLessonContent(context, state),
            ),
          ),

          // Navigation Controls
          _buildNavigationControls(context, state, viewModel),
        ],
      ),
    );
  }

  /// Build the app bar with quiz button
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    CourseDetailState state,
    CourseDetailViewModel viewModel,
  ) {
    return AppBar(
      title: Text(widget.projectName ?? state.course?.content.title ?? 'Course'),
      actions: [
        // Quiz Navigation Button
        IconButton(
          icon: const Icon(Icons.quiz),
          onPressed: () {
            viewModel.navigateToQuiz();
          },
          tooltip: 'Go to Quiz',
        ),
      ],
    );
  }

  /// Build the progress stepper showing lesson progress
  Widget _buildProgressStepper(BuildContext context, CourseDetailState state) {
    final theme = Theme.of(context);
    final totalLessons = state.totalLessons;
    final currentLesson = state.currentLessonIndex + 1;

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
                'Lesson $currentLesson of $totalLessons',
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

          // Interactive lesson stepper
          if (totalLessons > 0) _buildLessonStepper(context, state, theme),
        ],
      ),
    );
  }

  /// Build the interactive lesson stepper component
  Widget _buildLessonStepper(
    BuildContext context,
    CourseDetailState state,
    ThemeData theme,
  ) {
    final totalLessons = state.totalLessons;

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
          if (totalLessons > 1)
            Positioned(
              top: 19,
              left: 12,
              right: 12,
              child: FractionallySizedBox(
                widthFactor: (totalLessons > 1 ? state.progress : 0),
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

          // Lesson dots
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalLessons, (index) {
              final isActive = index == state.currentLessonIndex;
              final isCompleted = index < state.currentLessonIndex;

              return GestureDetector(
                onTap: () {
                  ref
                      .read(courseDetailViewModelProvider.notifier)
                      .goToLesson(index);
                },
                behavior: HitTestBehavior.opaque,
                child: _buildLessonDot(
                  context,
                  index: index,
                  isActive: isActive,
                  isCompleted: isCompleted,
                  theme: theme,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build individual lesson dot with label
  Widget _buildLessonDot(
    BuildContext context, {
    required int index,
    required bool isActive,
    required bool isCompleted,
    required ThemeData theme,
  }) {
    final dotSize = isActive ? 32.0 : 24.0;
    final iconSize = isActive ? 16.0 : 12.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Minimal dot with no animation
        SizedBox(
          width: dotSize,
          height: dotSize,
          child: Container(
            decoration: BoxDecoration(
              color: isActive
                  ? theme.colorScheme.primary
                  : isCompleted
                      ? theme.colorScheme.primary.withOpacity(0.7)
                      : theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
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

  /// Build the lesson content section
  Widget _buildLessonContent(BuildContext context, CourseDetailState state) {
    final theme = Theme.of(context);
    final currentLesson = state.currentLesson;

    if (currentLesson == null) {
      return const Center(
        child: Text('No lesson available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Estimated reading time
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                state.formattedReadingTime,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Lesson title
        Text(
          currentLesson.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 24),

        // Lesson content
        Text(
          currentLesson.content,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// Build the navigation controls (Previous/Next buttons)
  Widget _buildNavigationControls(
    BuildContext context,
    CourseDetailState state,
    CourseDetailViewModel viewModel,
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
                onPressed: state.hasPreviousLesson
                    ? () => viewModel.goToPreviousLesson()
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

            // Next button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: state.hasNextLesson
                    ? () => viewModel.goToNextLesson()
                    : null,
                icon: const Icon(Icons.chevron_right),
                label: const Text('Next'),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
