import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/viewmodels/project_viewmodel.dart';
import '../../../presentation/viewmodels/project_state.dart';
import '../../../core/utils/navigation_triggers.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/app_button.dart';
import '../../widgets/link_card.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {
  bool _isGeneratingCourse = false;
  bool _isSyncingCourse = false;

  @override
  void initState() {
    super.initState();
    // Load project, links, course, and quiz when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(projectViewModelProvider.notifier).selectProject(widget.projectId);
      }
    });
  }

  @override
  void dispose() {
    // Clear selected project when leaving page
    ref.read(projectViewModelProvider.notifier).clearSelectedProject();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(projectViewModelProvider.notifier);
    final state = ref.watch(projectViewModelProvider);

    // Show loading while project data is being fetched
    if (state.isLoading && state.selectedProject == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project')),
        body: const LoadingWidget(),
      );
    }

    final project = state.selectedProject;
    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project')),
        body: const LoadingWidget(),
      );
    }

    // Handle navigation triggers
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.navigationTrigger != ProjectNavigationTrigger.none) {
        switch (state.navigationTrigger) {
          case ProjectNavigationTrigger.toProjectsList:
            context.pop();
            break;
          case ProjectNavigationTrigger.back:
            context.pop();
            break;
          default:
            break;
        }
        viewModel.resetNavigationTrigger();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/projects/${widget.projectId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteConfirmation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Project Info Card
            _buildProjectInfoCard(context, project, state),
            const SizedBox(height: 24),

            // 2. Project Knowledge Base / Links Section
            _buildKnowledgeBaseSection(context, state),
            const SizedBox(height: 24),

            // 3. Course Generation Section
            _buildCourseGenerationSection(context, state),
            const SizedBox(height: 24),

            // 4. Course Lessons Section (if course exists)
            if (state.hasCourse) ...[
              _buildCourseLessonsSection(context, state),
              const SizedBox(height: 24),
            ],

            // 5. Quiz Section
            if (state.hasCourse) _buildQuizSection(context, state),
          ],
        ),
      ),
    );
  }

  /// Section 1: Project Info Card
  Widget _buildProjectInfoCard(
    BuildContext context,
    project,
    state,
  ) {
    final courseStatus = state.selectedProjectStats?['courseStatus'] as String?;
    final lastGeneratedAt = state.selectedProjectStats?['lastGeneratedAt'] as DateTime?;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (project.description != null && project.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                project.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            // Status row
            _buildStatusRow(context, courseStatus),
            const SizedBox(height: 12),
            // Date row
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Created ${_formatDate(project.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
            if (lastGeneratedAt != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.update, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    'Course updated ${_formatDate(lastGeneratedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, String? courseStatus) {
    IconData statusIcon;
    Color statusColor;
    String statusText;

    switch (courseStatus) {
      case 'generated':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        statusText = 'Course Generated';
        break;
      case 'needs_sync':
        statusIcon = Icons.sync_problem;
        statusColor = Colors.orange;
        statusText = 'Update Available';
        break;
      default:
        statusIcon = Icons.pending_actions;
        statusColor = Colors.grey;
        statusText = 'No Course Yet';
    }

    return Row(
      children: [
        Icon(statusIcon, size: 18, color: statusColor),
        const SizedBox(width: 8),
        Text(
          statusText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  /// Section 2: Knowledge Base / Links Section
  Widget _buildKnowledgeBaseSection(BuildContext context, state) {
    final linkCount = state.selectedProjectLinks.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.folder, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Knowledge Base',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '$linkCount ${linkCount == 1 ? 'link' : 'links'}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (linkCount == 0)
              _buildEmptyKnowledgeBase(context)
            else
              AppButton(
                text: 'View All Links ($linkCount)',
                onPressed: () => _showLinksList(context, state),
                isSecondary: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyKnowledgeBase(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.add_link, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No links yet',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add links to build your knowledge base',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.push('/links/add?projectId=${widget.projectId}'),
            icon: const Icon(Icons.add),
            label: const Text('Add Link'),
          ),
        ],
      ),
    );
  }

  void _showLinksList(BuildContext context, state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Links in Project',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: state.selectedProjectLinks.length,
                  itemBuilder: (context, index) {
                    final link = state.selectedProjectLinks[index];
                    return LinkCard(link: link);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section 3: Course Generation Section
  Widget _buildCourseGenerationSection(BuildContext context, state) {
    final courseStatus = state.selectedProjectStats?['courseStatus'] as String?;
    final hasLinks = state.selectedProjectLinks.isNotEmpty;
    final hasCourse = courseStatus == 'generated';
    final needsSync = courseStatus == 'needs_sync';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: needsSync ? Colors.orange : Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  needsSync ? 'Update Course' : 'AI Course Generation',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              needsSync
                  ? 'New links have been added. Regenerate to include them.'
                  : hasCourse
                      ? 'Course generated from all links in this project'
                      : 'Generate a structured course and quiz from all links',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            if (hasLinks)
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: needsSync
                      ? (_isSyncingCourse ? 'Syncing...' : 'Sync Course')
                      : hasCourse
                          ? 'Regenerate Course'
                          : 'Generate Course & Quiz',
                  onPressed: needsSync
                      ? (_isSyncingCourse ? null : _syncCourse)
                      : (_isGeneratingCourse ? null : _generateCourseQuiz),
                  isLoading: _isGeneratingCourse || _isSyncingCourse,
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.grey[600]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Add links to this project before generating a course',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Section 4: Course Lessons Section
  Widget _buildCourseLessonsSection(BuildContext context, state) {
    final course = state.selectedProjectCourse;
    if (course == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Course Lessons',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '${course.lessonCount} lessons',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Preview of first 3 lessons
            ...course.sortedLessons.take(3).map(
              (lesson) => ListTile(
                leading: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${lesson.order}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  lesson.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _navigateToCourse(context),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'View All Lessons',
                onPressed: () => _navigateToCourse(context),
                isSecondary: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section 5: Quiz Section
  Widget _buildQuizSection(BuildContext context, state) {
    final quiz = state.selectedProjectQuiz;
    final quizCount = quiz?.questionCount ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.quiz, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Test Your Knowledge',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (quizCount > 0) ...[
                  const Spacer(),
                  Chip(
                    label: Text(
                      '$quizCount questions',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Take a quiz to test your understanding of the course material',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: 'Start Quiz',
                onPressed: () => _navigateToQuiz(context),
                icon: Icons.play_arrow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCourse(BuildContext context) {
    context.push('/projects/${widget.projectId}/course');
  }

  void _navigateToQuiz(BuildContext context) {
    context.push('/projects/${widget.projectId}/quiz');
  }

  Future<void> _generateCourseQuiz() async {
    setState(() => _isGeneratingCourse = true);

    try {
      await ref
          .read(projectViewModelProvider.notifier)
          .generateCourseQuiz(widget.projectId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course and quiz generation started!'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh after delay
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            ref.read(projectViewModelProvider.notifier).refreshProject(widget.projectId);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingCourse = false);
      }
    }
  }

  Future<void> _syncCourse() async {
    setState(() => _isSyncingCourse = true);

    try {
      await ref
          .read(projectViewModelProvider.notifier)
          .syncCourse(widget.projectId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course sync started!'),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh after delay
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            ref.read(projectViewModelProvider.notifier).refreshProject(widget.projectId);
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncingCourse = false);
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text(
          'Are you sure you want to delete this project? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(projectViewModelProvider.notifier).deleteProject(widget.projectId);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
