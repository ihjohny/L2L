import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/link_providers.dart';
import '../../../providers/project_providers.dart';
import '../../../data/models/project_model.dart';

class AddLinkPage extends ConsumerStatefulWidget {
  const AddLinkPage({super.key});

  @override
  ConsumerState<AddLinkPage> createState() => _AddLinkPageState();
}

class _AddLinkPageState extends ConsumerState<AddLinkPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  final _newProjectController = TextEditingController();

  String? _selectedProjectId;
  bool _isSubmitting = false;
  bool _showNewProjectInput = false;

  @override
  void initState() {
    super.initState();
    // Load projects for dropdown
    Future.microtask(() {
      ref.read(projectsProvider.notifier).loadProjects();
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _tagsController.dispose();
    _newProjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsState = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Link'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // URL Field
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL *',
                  hintText: 'https://example.com/article',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a URL';
                  }
                  if (!Uri.tryParse(value)!.isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Title Field (Optional)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title (Optional)',
                  hintText: 'Article title',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),

              // Project Dropdown (Optional)
              DropdownButtonFormField<String>(
                value: _showNewProjectInput ? 'new_project' : _selectedProjectId,
                decoration: const InputDecoration(
                  labelText: 'Project (Optional)',
                  prefixIcon: Icon(Icons.folder),
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('No project'),
                  ),
                  ...projectsState.projects.map((project) {
                    return DropdownMenuItem<String>(
                      value: project.id,
                      child: Text(project.name),
                    );
                  }),
                  const DropdownMenuItem<String>(
                    value: 'new_project',
                    child: Row(
                      children: [
                        Icon(Icons.add_circle_outline, size: 20),
                        SizedBox(width: 8),
                        Text('Create new project'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'new_project') {
                    setState(() {
                      _showNewProjectInput = true;
                      _selectedProjectId = null;
                    });
                  } else {
                    setState(() {
                      _showNewProjectInput = false;
                      _selectedProjectId = value;
                    });
                  }
                },
              ),
              // Inline new project input
              if (_showNewProjectInput) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newProjectController,
                  decoration: const InputDecoration(
                    labelText: 'New project name',
                    hintText: 'Enter project name',
                    prefixIcon: Icon(Icons.folder),
                    border: OutlineInputBorder(),
                    helperText: 'Leave empty to select existing project',
                  ),
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showNewProjectInput = false;
                          _newProjectController.clear();
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),

              // Tags Field (Optional)
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (Optional)',
                  hintText: 'react, frontend, tutorial',
                  prefixIcon: Icon(Icons.local_offer),
                  border: OutlineInputBorder(),
                  helperText: 'Separate tags with commas',
                ),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 24),

              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Save Link',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Parse tags
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();

      // Handle project selection/creation
      String? finalProjectId = _selectedProjectId;
      final newProjectName = _newProjectController.text.trim();

      if (newProjectName.isNotEmpty) {
        final projectsNotifier = ref.read(projectsProvider.notifier);
        final projectsState = ref.read(projectsProvider);

        // Check if project with same name already exists
        final existingProject = projectsState.projects
            .firstWhere((p) => p.name.toLowerCase() == newProjectName.toLowerCase(), orElse: () => ProjectModel.empty());

        if (existingProject.id.isNotEmpty) {
          // Use existing project
          finalProjectId = existingProject.id;
        } else {
          // Create new project
          final newProject = await projectsNotifier.createProject(
            name: newProjectName,
          );
          if (newProject != null) {
            finalProjectId = newProject.id;
          }
        }
      }

      final notifier = ref.read(linksProvider.notifier);

      final result = await notifier.addLink(
        url: _urlController.text.trim(),
        title: _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        projectId: finalProjectId,
        tags: tags.isEmpty ? null : tags,
      );

      if (result != null && mounted) {
        // Success - show snackbar and go back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true);
      } else if (mounted) {
        // Failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(linksProvider).error ?? 'Failed to save link',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
