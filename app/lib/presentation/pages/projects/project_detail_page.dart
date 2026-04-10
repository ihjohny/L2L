import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/viewmodels/project_viewmodel.dart';
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

  @override
  void initState() {
    super.initState();
    // Load project and links when page opens
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

    // Show loading while links are being fetched for the first time
    if (state.isLoadingLinks && state.selectedProjectLinks.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(project.name)),
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
            // Project Info Card
            _buildProjectInfoCard(project),

            const SizedBox(height: 24),

            // Generate Course Button
            _buildGenerateCourseSection(),

            const SizedBox(height: 24),

            // Links Section
            Text(
              'Links (${state.selectedProjectLinks.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            if (state.selectedProjectLinks.isEmpty)
              _buildEmptyLinksState()
            else
              _buildLinksList(state.selectedProjectLinks),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectInfoCard(project) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (project.description != null && project.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                project.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Created ${_formatDate(project.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenerateCourseSection() {
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
                  'AI Course & Quiz Generation',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Generate a structured course and quiz from all links in this project',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: _isGeneratingCourse ? 'Generating...' : 'Generate Course & Quiz',
                onPressed: _isGeneratingCourse ? null : _generateCourseQuiz,
                isLoading: _isGeneratingCourse,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLinksState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.link_off, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No links yet',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Add links to this project from the links page',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLinksList(projectLinks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projectLinks.length,
      itemBuilder: (context, index) {
        final link = projectLinks[index];
        return LinkCard(link: link);
      },
    );
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
