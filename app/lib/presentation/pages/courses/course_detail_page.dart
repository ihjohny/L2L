import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/course_model.dart';
import '../../../presentation/viewmodels/project_viewmodel.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/course_lesson_card.dart';

/// Page for displaying course lessons list.
class CourseDetailPage extends ConsumerWidget {
  final String projectId;

  const CourseDetailPage({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectViewModelProvider);
    final course = state.selectedProjectCourse;

    // Show loading while course data is being fetched
    if (state.isLoadingCourse && course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course')),
        body: const LoadingWidget(),
      );
    }

    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No course available',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Generate a course from the project page',
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course'),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz_outlined),
            onPressed: () => context.push('/projects/$projectId/quiz'),
            tooltip: 'Take Quiz',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course header
            _buildCourseHeader(context, course),
            const SizedBox(height: 24),
            // Lessons section
            Text(
              'Lessons (${course.lessonCount})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            // Lessons list
            ...course.sortedLessons.map(
              (lesson) => CourseLessonCard(
                lesson: lesson,
                onTap: () => _navigateToLessonDetail(context, lesson),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseHeader(BuildContext context, CourseModel course) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.content.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course.lessonCount} lessons',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (course.content.description.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              course.content.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  void _navigateToLessonDetail(BuildContext context, CourseLesson lesson) {
    context.push(
      '/projects/${projectId}/course/lesson',
      extra: {
        'title': lesson.title,
        'content': lesson.content,
        'order': lesson.order,
        'projectId': projectId,
      },
    );
  }
}

/// Page for displaying a single lesson detail.
class LessonDetailPage extends ConsumerWidget {
  final Map<String, dynamic> lessonData;

  const LessonDetailPage({
    super.key,
    required this.lessonData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = lessonData['title'] as String;
    final content = lessonData['content'] as String;
    final order = lessonData['order'] as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson $order'),
        actions: [
          IconButton(
            icon: const Icon(Icons.quiz_outlined),
            onPressed: () {
              final projectId = lessonData['projectId'] as String?;
              if (projectId != null) {
                context.push('/projects/$projectId/quiz');
              }
            },
            tooltip: 'Take Quiz',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson header
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '$order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            // Lesson content
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                    ),
              ),
            ),
            const SizedBox(height: 32),
            // Navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Lessons'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    final projectId = lessonData['projectId'] as String?;
                    if (projectId != null) {
                      context.push('/projects/$projectId/quiz');
                    }
                  },
                  icon: const Icon(Icons.quiz),
                  label: const Text('Take Quiz'),
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
