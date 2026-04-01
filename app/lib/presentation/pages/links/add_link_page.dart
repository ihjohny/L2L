import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/viewmodels/link_viewmodel.dart';
import '../../../presentation/viewmodels/project_viewmodel.dart';
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
  final _projectSearchController = TextEditingController();

  String? _selectedProjectId;
  String? _newProjectName;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Load projects for dropdown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(projectViewModelProvider.notifier).loadProjects();
      }
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _tagsController.dispose();
    _projectSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectViewModelProvider);

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
              const SizedBox(height: 16),
              // Project Selection (Autocomplete)
              const Text(
                'Project',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  // Show all projects when empty
                  if (textEditingValue.text.isEmpty) {
                    return projectState.projects.map((p) => p.name);
                  }
                  // Filter projects by search text
                  return projectState.projects
                      .where((project) => project.name
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()))
                      .map((project) => project.name);
                },
                displayStringForOption: (projectName) => projectName,
                fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: _selectedProjectId != null
                          ? projectState.projects
                              .firstWhere((p) => p.id == _selectedProjectId)
                              .name
                          : 'Search or create project...',
                      prefixIcon: Icon(
                        _selectedProjectId != null
                            ? Icons.folder
                            : Icons.search,
                        color: _selectedProjectId != null
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                      suffixIcon: _selectedProjectId != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                setState(() {
                                  _selectedProjectId = null;
                                  _newProjectName = null;
                                  controller.clear();
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          final existingProject = projectState.projects
                              .firstWhere((p) =>
                                  p.name.toLowerCase() == value.toLowerCase(),
                              orElse: () => ProjectModel.empty());
                          if (existingProject.id.isEmpty) {
                            _newProjectName = value;
                          } else {
                            _newProjectName = null;
                          }
                        } else {
                          _newProjectName = null;
                        }
                      });
                    },
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final projectName = options.elementAt(index);
                            final project = projectState.projects
                                .firstWhere((p) => p.name == projectName);
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.folder,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                              ),
                              title: Text(projectName),
                              subtitle: project.linkIds.isNotEmpty
                                  ? Text('${project.linkIds.length} links')
                                  : null,
                              trailing: project.aiOutputId != null
                                  ? Icon(
                                      Icons.auto_awesome,
                                      size: 18,
                                      color: Colors.amber[700],
                                    )
                                  : null,
                              onTap: () {
                                onSelected(projectName);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                onSelected: (projectName) {
                  final project = projectState.projects
                      .firstWhere((p) => p.name == projectName);
                  setState(() {
                    _selectedProjectId = project.id;
                    _newProjectName = null;
                    _projectSearchController.clear();
                  });
                },
              ),
              // Show "Create new project" indicator when typing unknown name
              if (_newProjectName != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'New project "$_newProjectName"',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

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
      // Handle project selection/creation
      String? finalProjectId = _selectedProjectId;

      // Create new project if user typed a new name
      if (_newProjectName != null && _newProjectName!.isNotEmpty) {
        final projectViewModel = ref.read(projectViewModelProvider.notifier);

        // Check if project with same name already exists
        final projectState = ref.watch(projectViewModelProvider);
        final existingProject = projectState.projects
            .firstWhere((p) => p.name.toLowerCase() == _newProjectName!.toLowerCase(), orElse: () => ProjectModel.empty());

        if (existingProject.id.isNotEmpty) {
          // Use existing project
          finalProjectId = existingProject.id;
        } else {
          // Create new project first
          projectViewModel.setFormName(_newProjectName!);
          await projectViewModel.createProject();

          // Get the newly created project
          final newState = ref.read(projectViewModelProvider);
          if (newState.projects.isNotEmpty) {
            finalProjectId = newState.projects.last.id;
          }
        }
      }

      final linkViewModel = ref.read(linkViewModelProvider.notifier);

      // Set form values
      linkViewModel.setFormUrl(_urlController.text.trim());
      if (_titleController.text.trim().isNotEmpty) {
        linkViewModel.setFormTitle(_titleController.text.trim());
      }
      linkViewModel.setFormTags(_tagsController.text);
      if (finalProjectId != null) {
        linkViewModel.setFormProjectId(finalProjectId);
      }

      // Create link
      await linkViewModel.createLink();

      if (mounted) {
        // Success - show snackbar and go back
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Link saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop(true);
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
