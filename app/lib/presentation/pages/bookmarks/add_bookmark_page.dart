import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/entity_service.dart';
import '../../../data/models/entity_model.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/app_button.dart';

part 'add_bookmark_page.g.dart';

@riverpod
class AddBookmarkController extends _$AddBookmarkController {
  final EntityService _entityService = EntityService();

  @override
  Future<void> build() async {}

  Future<EntityModel?> addBookmark({
    required String url,
    required String projectId,
    List<String>? tags,
    String? notes,
  }) async {
    try {
      final entity = await _entityService.createEntity(
        url: url,
        projectId: projectId,
        tags: tags,
        notes: notes,
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isValidUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (_) {
      return false;
    }
  }
}

class AddBookmarkPage extends ConsumerStatefulWidget {
  final String? projectId;
  final String? initialUrl;

  const AddBookmarkPage({
    super.key,
    this.projectId,
    this.initialUrl,
  });

  @override
  ConsumerState<AddBookmarkPage> createState() => _AddBookmarkPageState();
}

class _AddBookmarkPageState extends ConsumerState<AddBookmarkPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController(text: '');
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final List<String> _selectedTags = [];

  bool _isLoading = false;
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.projectId;
    if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submitBookmark() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a project')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final controller = ref.read(addBookmarkControllerProvider.notifier);

      final entity = await controller.addBookmark(
        url: _urlController.text.trim(),
        projectId: _selectedProjectId!,
        tags: _selectedTags.isNotEmpty ? _selectedTags : null,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmark saved to ${entity.title}'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () => context.pop(),
            ),
          ),
        );
        context.pop(entity);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving bookmark: ${e.toString()}'),
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

  void _addTag() {
    final tag = _tagsController.text.trim();
    if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.add(tag);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bookmark'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // URL Input
            AppTextField(
              controller: _urlController,
              label: 'URL',
              hint: 'https://example.com/article',
              prefixIcon: Icons.link,
              keyboardType: TextInputType.url,
              enabled: !_isLoading,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a URL';
                }
                final uri = Uri.tryParse(value.trim());
                if (uri == null || !uri.hasScheme ||
                    (uri.scheme != 'http' && uri.scheme != 'https')) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Project Selector
            _buildProjectSelector(),
            const SizedBox(height: 16),

            // Notes
            AppTextField(
              controller: _notesController,
              label: 'Notes (Optional)',
              hint: 'Add your notes here...',
              prefixIcon: Icons.note,
              maxLines: 3,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Tags
            AppTextField(
              controller: _tagsController,
              label: 'Tags (Optional)',
              hint: 'Add a tag',
              prefixIcon: Icons.tag,
              enabled: !_isLoading,
              onSubmitted: (_) => _addTag(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _isLoading ? null : _addTag,
              ),
            ),
            const SizedBox(height: 8),

            // Selected Tags
            if (_selectedTags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),

            // AI Processing Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI will automatically generate tags, summary, and learning materials',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            AppButton(
              onPressed: _isLoading ? null : _submitBookmark,
              text: 'Save Bookmark',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectSelector() {
    return InkWell(
      onTap: _isLoading ? null : _showProjectSelector,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.folder_open),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedProjectId ?? 'Select Project',
                style: TextStyle(
                  color: _selectedProjectId != null
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showProjectSelector() {
    // TODO: Implement project selector dialog
    // For now, just show a placeholder
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Project'),
        content: const Text('Project selection will be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
