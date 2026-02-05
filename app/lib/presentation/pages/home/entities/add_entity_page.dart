import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/entity_providers.dart';

class AddEntityPage extends ConsumerStatefulWidget {
  const AddEntityPage({super.key});

  @override
  ConsumerState<AddEntityPage> createState() => _AddEntityPageState();
}

class _AddEntityPageState extends ConsumerState<AddEntityPage> {
  final _urlController = TextEditingController();
  final _tagsController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _urlController.dispose();
    _tagsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Entity'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // URL input
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL *',
                hintText: 'https://example.com/article',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),

            // Tags input
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (optional)',
                hintText: 'tag1, tag2, tag3',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Notes input
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'Add your personal notes...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'AI will automatically process your content to generate summaries and learning materials.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Add Entity', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    // Validate URL
    if (_urlController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a URL')),
      );
      return;
    }

    // Basic URL validation
    final urlPattern = RegExp(
      r'^https?:\/\/.+',
      caseSensitive: false,
    );
    if (!urlPattern.hasMatch(_urlController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid URL (starting with http:// or https://)')),
      );
      return;
    }

    // Parse tags
    final tags = _tagsController.text.trim().isEmpty
        ? <String>[]
        : _tagsController.text
            .split(',')
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList();

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Add entity
      final newEntity = await ref.read(entitiesProvider.notifier).addEntity(
            url: _urlController.text.trim(),
            tags: tags.isNotEmpty ? tags : null,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (context.mounted) {
        setState(() {
          _isSubmitting = false;
        });

        if (newEntity != null) {
          // Navigate to the entity details page
          context.go('/entities/${newEntity.id}');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add entity')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
