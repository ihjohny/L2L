import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/project_details/project_details_viewmodel.dart';
import '../../viewmodels/project_details/project_details_state.dart';
import '../../../data/models/project_model.dart';
import '../../../core/utils/navigation_triggers.dart';
import '../../widgets/loading_widget.dart';
import 'widgets/project_info_section.dart';
import 'widgets/project_sources_section.dart';
import 'widgets/course_section.dart';
import 'widgets/quiz_section.dart';
import 'widgets/generate_ai_output_section.dart';

class ProjectDetailPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends ConsumerState<ProjectDetailPage> {

  @override
  void initState() {
    super.initState();
    // Load project and links when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(projectDetailsViewModelProvider.notifier).selectProject(widget.projectId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(projectDetailsViewModelProvider.notifier);
    final state = ref.watch(projectDetailsViewModelProvider);

    // Show loading while project data is being fetched
    if (state.isLoading && state.project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project Details')),
        body: const LoadingWidget(),
      );
    }

    final project = state.project;
    if (project == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project Details')),
        body: const LoadingWidget(),
      );
    }

    // Show loading while data is being fetched for the first time
    if ((state.isLoadingLinks || state.isLoadingCourse || state.isLoadingQuiz) &&
        state.projectLinks.isEmpty &&
        state.course == null &&
        state.quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Project Details')),
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

    // Listen to state changes for error messages and generation start
    ref.listen<ProjectDetailsState>(projectDetailsViewModelProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
        viewModel.clearError();
      }
      
      if (previous?.isGenerating == false && next.isGenerating == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Course and quiz generation started!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Details'),
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
      body: RefreshIndicator(
        onRefresh: () => viewModel.selectProject(widget.projectId),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project Info Section with sync status
              ProjectInfoSection(project: project),

              const SizedBox(height: 24),

              // Sources/Links Section
              ProjectSourcesSection(
                links: state.projectLinks,
                linkCount: project.totalLinks,
              ),

              const SizedBox(height: 24),

              // AI Output Section - CTA or Course/Quiz based on state
              _buildAiOutputSection(context, state, project),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAiOutputSection(
    BuildContext context,
    ProjectDetailsState state,
    ProjectModel project,
  ) {
    // Initial state - no AI output yet
    if (!state.hasAiOutput) {
      return GenerateAiOutputSection(
        isGenerating: state.isGenerating,
        progress: state.generationProgress,
        needsSync: false,
        onGenerate: _generateCourseQuiz,
      );
    }

    // Sync required state
    if (state.needsAiSync) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show sync needed CTA at the top
          GenerateAiOutputSection(
            isGenerating: state.isGenerating,
            progress: state.generationProgress,
            needsSync: true,
            onGenerate: _generateCourseQuiz,
          ),
          if (state.course != null || state.quiz != null) ...[
            const SizedBox(height: 24),
            Text(
              'Current Content (Outdated)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const SizedBox(height: 12),
            _buildCourseAndQuizContent(context, state),
          ],
        ],
      );
    }

    // Sync completed state - show course and quiz
    return _buildCourseAndQuizContent(context, state);
  }

  Widget _buildCourseAndQuizContent(BuildContext context, ProjectDetailsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Course Section
        if (state.course != null) ...[
          CourseSection(
            course: state.course!,
            projectId: widget.projectId,
            projectName: state.project?.name ?? 'Project',
          ),
          const SizedBox(height: 16),
        ],

        // Quiz Section
        if (state.quiz != null) QuizSection(
          quiz: state.quiz!,
          projectId: widget.projectId,
          projectName: state.project?.name ?? 'Project',
        ),
      ],
    );
  }

  Future<void> _generateCourseQuiz() async {
    await ref
        .read(projectDetailsViewModelProvider.notifier)
        .generateCourseQuiz(widget.projectId);
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
              ref.read(projectDetailsViewModelProvider.notifier).deleteProject();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
