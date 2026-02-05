import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/entity_model.dart';
import '../../../../core/providers/entity_providers.dart';

class EntityDetailsPage extends ConsumerStatefulWidget {
  final String entityId;

  const EntityDetailsPage({
    super.key,
    required this.entityId,
  });

  @override
  ConsumerState<EntityDetailsPage> createState() => _EntityDetailsPageState();
}

class _EntityDetailsPageState extends ConsumerState<EntityDetailsPage> {
  bool _isEditing = false;
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entity = ref.watch(entityByIdProvider(widget.entityId));

    if (entity == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Entity Details'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading entity...'),
            ],
          ),
        ),
      );
    }

    // Initialize tags if not editing
    if (!_isEditing) {
      _tags.clear();
      _tags.addAll(entity.displayTags);
    }

    final isProcessed = entity.isProcessed;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entity Details'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                // Save changes
                await ref.read(entitiesProvider.notifier).updateEntity(
                      entityId: widget.entityId,
                      tags: _tags,
                    );
                if (context.mounted) {
                  setState(() {
                    _isEditing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes saved')),
                  );
                }
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator
            Row(
              children: [
                Icon(
                  isProcessed ? Icons.check_circle : Icons.pending,
                  color: isProcessed ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  isProcessed ? 'Processed' : 'Processing',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: isProcessed ? Colors.green : Colors.orange,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              entity.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),

            // URL
            InkWell(
              onTap: () {
                // TODO: Open URL in browser
              },
              child: Text(
                entity.url,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
            const SizedBox(height: 8),

            // Domain
            Text(
              'Source: ${entity.domain}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 24),

            // Description
            if (entity.description.isNotEmpty) ...[
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                entity.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
            ],

            // Summary (if processed)
            if (isProcessed &&
                entity.processedContent != null &&
                entity.processedContent!.summary != null) ...[
              Text(
                'Summary',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                entity.processedContent!.summary!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
            ],

            // Tags section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tags',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (_isEditing)
                  TextButton.icon(
                    onPressed: () {
                      _showAddTagDialog(context);
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_tags.isEmpty && !_isEditing)
              Text(
                'No tags',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: _isEditing ? const Icon(Icons.close, size: 18) : null,
                    onDeleted: _isEditing
                        ? () {
                            setState(() {
                              _tags.remove(tag);
                            });
                          }
                        : null,
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    _tagController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: _tagController,
          decoration: const InputDecoration(
            labelText: 'Tag',
            hintText: 'Enter tag name',
          ),
          autofocus: true,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty && !_tags.contains(value.trim())) {
              setState(() {
                _tags.add(value.trim());
              });
            }
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (_tagController.text.trim().isNotEmpty &&
                  !_tags.contains(_tagController.text.trim())) {
                setState(() {
                  _tags.add(_tagController.text.trim());
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
