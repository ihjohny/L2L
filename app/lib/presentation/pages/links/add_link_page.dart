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

              // Project Selection
              const Text(
                'Project',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              // Project chips container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Existing projects - horizontal scrollable chips
                    if (projectsState.projects.isEmpty && !_showNewProjectInput)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'No projects yet',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      )
                    else if (!_showNewProjectInput)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // "No project" chip
                          _ProjectChip(
                            label: 'None',
                            icon: Icons.block_outlined,
                            isSelected: _selectedProjectId == null,
                            onTap: () {
                              setState(() {
                                _selectedProjectId = null;
                              });
                            },
                          ),
                          // Project chips
                          ...projectsState.projects.map((project) {
                            return _ProjectChip(
                              label: project.name,
                              icon: Icons.folder_outlined,
                              isSelected: _selectedProjectId == project.id,
                              linkCount: project.linkIds.length,
                              onTap: () {
                                setState(() {
                                  _selectedProjectId = project.id;
                                });
                              },
                            );
                          }),
                          // "New project" chip
                          _ProjectChip(
                            label: 'New Project',
                            icon: Icons.add_circle_outline,
                            isSelected: _showNewProjectInput,
                            onTap: () {
                              setState(() {
                                _showNewProjectInput = true;
                                _selectedProjectId = null;
                              });
                            },
                          ),
                        ],
                      ),
                    // Inline new project input
                    if (_showNewProjectInput) ...[
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _newProjectController,
                              decoration: InputDecoration(
                                hintText: 'Project name',
                                prefixIcon: const Icon(Icons.folder, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: _submit,
                            tooltip: 'Create & Save',
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _showNewProjectInput = false;
                                _newProjectController.clear();
                              });
                            },
                            tooltip: 'Cancel',
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
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

/// A chip widget for selecting a project in the add link form.
class _ProjectChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int? linkCount;

  const _ProjectChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.linkCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.12)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[800],
              ),
            ),
            if (linkCount != null && linkCount! > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$linkCount',
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
