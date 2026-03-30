import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l2l_app/data/models/link_model.dart';
import '../../../providers/project_providers.dart';
import '../../../providers/link_providers.dart';
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
    // Load links for this project using the project-specific provider
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(projectByIdProvider(widget.projectId));
    final projectLinksResult = ref.watch(projectLinksProvider(widget.projectId));

    // Handle async state of project links
    final projectLinks = projectLinksResult.when(
      data: (links) => links,
      loading: () => <LinkModel>[],
      error: (_, __) => <LinkModel>[],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(project?.name ?? 'Project'),
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
      body: project == null
          ? const LoadingWidget()
          : SingleChildScrollView(
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
                    'Links (${projectLinks.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 12),

                  if (projectLinks.isEmpty)
                    _buildEmptyLinksState()
                  else
                    _buildLinksList(projectLinks),
                ],
              ),
            ),
    );
  }

  Widget _buildProjectInfoCard(dynamic project) {
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
                  'AI Course Generation',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Generate a structured course from all links in this project',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                text: _isGeneratingCourse ? 'Generating...' : 'Generate Course',
                onPressed: _isGeneratingCourse ? null : _generateCourse,
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

  Widget _buildLinksList(List<LinkModel> projectLinks) {
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

  Future<void> _generateCourse() async {
    setState(() => _isGeneratingCourse = true);

    try {
      final result = await ref
          .read(projectRepositoryProvider)
          .generateCourse(widget.projectId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Course generation started: ${result['jobId']}'),
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
              ref.read(projectsProvider.notifier).deleteProject(widget.projectId);
              Navigator.pop(context);
              context.pop();
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
