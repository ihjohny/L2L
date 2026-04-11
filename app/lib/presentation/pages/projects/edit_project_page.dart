import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/edit_project/edit_project_viewmodel.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class EditProjectPage extends ConsumerStatefulWidget {
  final String projectId;

  const EditProjectPage({super.key, required this.projectId});

  @override
  ConsumerState<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends ConsumerState<EditProjectPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load project when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(editProjectViewModelProvider.notifier).loadProject(widget.projectId);
      }
    });
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProjectViewModelProvider);
    final project = state.project;

    // Update controllers when project loads
    if (project != null &&
        (_nameController.text.isEmpty || _nameController.text != project.name)) {
      _nameController.text = project.name;
      _descriptionController.text = project.description ?? '';
    }

    if (state.isLoading && project == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('Project not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Project'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Project Name',
                hint: 'e.g., Machine Learning Basics',
                prefixIcon: Icons.folder,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Project name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descriptionController,
                label: 'Description (Optional)',
                hint: 'Brief description of what this project is about',
                prefixIcon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Save Changes',
                onPressed: _isLoading ? null : _updateProject,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();

      // Set form fields
      final viewModel = ref.read(editProjectViewModelProvider.notifier);
      viewModel.setFormName(name);
      viewModel.setFormDescription(description);

      // Update project
      final success = await viewModel.updateProject();

      if (mounted) {
        if (success) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Project updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Watch the state again to get the error
          final errorState = ref.read(editProjectViewModelProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${errorState.error ?? "Failed to update project"}'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
        setState(() => _isLoading = false);
      }
    }
  }
}
