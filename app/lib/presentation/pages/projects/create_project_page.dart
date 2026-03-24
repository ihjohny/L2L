import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/project_providers.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';

class CreateProjectPage extends ConsumerStatefulWidget {
  const CreateProjectPage({super.key});

  @override
  ConsumerState<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends ConsumerState<CreateProjectPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Project'),
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
                text: 'Create Project',
                onPressed: _isLoading ? null : _createProject,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createProject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final project = await ref.read(projectsProvider.notifier).createProject(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      if (mounted && project != null) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create project'),
            backgroundColor: Colors.red,
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
        setState(() => _isLoading = false);
      }
    }
  }
}
