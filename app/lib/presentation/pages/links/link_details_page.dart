import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/link_detail/link_detail_viewmodel.dart';
import '../../../data/models/link_model.dart';

class LinkDetailsPage extends ConsumerStatefulWidget {
  final String linkId;

  const LinkDetailsPage({super.key, required this.linkId});

  @override
  ConsumerState<LinkDetailsPage> createState() => _LinkDetailsPageState();
}

class _LinkDetailsPageState extends ConsumerState<LinkDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        ref.read(linkDetailViewModelProvider.notifier).loadLink(widget.linkId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(linkDetailViewModelProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Link Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null || state.link == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Link Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                state.error ?? 'Link not found',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(linkDetailViewModelProvider.notifier).loadLink(widget.linkId);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final link = state.link!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Link Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: () => _launchUrl(link.url),
            tooltip: 'Open original link',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(linkDetailViewModelProvider.notifier).refreshLink(widget.linkId),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Link Info Card
              _buildLinkInfoCard(link, context),
              const SizedBox(height: 16),

              // Status Card
              _buildStatusCard(link, context),
              const SizedBox(height: 16),

              // Summary Card (when completed)
              if (link.isProcessed && link.summary != null) ...[
                _buildSummaryCard(link, context),
                const SizedBox(height: 16),
              ],

              // Flashcards Card (when completed)
              if (link.isProcessed && link.flashcards != null)
                _buildFlashcardsCard(link, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLinkInfoCard(LinkModel link, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              link.displayTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              link.url,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                  ),
            ),
            const SizedBox(height: 12),
            // Metadata
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Added ${DateFormat('MMM d, yyyy').format(link.createdAt)}',
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

  Widget _buildStatusCard(LinkModel link, BuildContext context) {
    IconData statusIcon;
    Color statusColor;
    String statusText;

    switch (link.status) {
      case LinkStatus.pending:
        statusIcon = Icons.schedule;
        statusColor = Colors.orange;
        statusText = 'Waiting to be processed...';
        break;
      case LinkStatus.processing:
        statusIcon = Icons.auto_awesome;
        statusColor = Colors.blue;
        statusText = 'AI is analyzing content...';
        break;
      case LinkStatus.completed:
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        statusText = 'Processing complete';
        break;
      case LinkStatus.failed:
        statusIcon = Icons.error;
        statusColor = Colors.red;
        statusText = link.statusMessage ?? 'Processing failed';
        break;
    }

    final isProcessed = link.status == LinkStatus.completed;
    final isProcessing = link.status == LinkStatus.processing;

    return Card(
      color: statusColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isProcessing
                        ? 'Processing...'
                        : isProcessed
                            ? 'Ready'
                            : 'Error',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    statusText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: statusColor,
                        ),
                  ),
                ],
              ),
            ),
            if (isProcessing)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(LinkModel link, BuildContext context) {
    final summary = link.summary!;
    final isProcessed = link.status == LinkStatus.completed;

    if (!isProcessed) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.summarize, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            if (summary.mainArgument.isNotEmpty) ...[
              Text(
                'Main Argument',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(summary.mainArgument),
              const SizedBox(height: 16),
            ],
            if (summary.keyPoints.isNotEmpty) ...[
              Text(
                'Key Points',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              ...summary.keyPoints.map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(color: Colors.grey[600])),
                        Expanded(child: Text(point)),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            if (summary.takeaways.isNotEmpty) ...[
              Text(
                'Takeaways',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              ...summary.takeaways.map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check, size: 16, color: Colors.green[700]),
                        const SizedBox(width: 4),
                        Expanded(child: Text(point)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFlashcardsCard(LinkModel link, BuildContext context) {
    final flashcards = link.flashcards!.flashcards;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Flashcards',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                Chip(
                  label: Text('${flashcards.length} cards'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(height: 24),
            ...flashcards.map((card) => _FlashcardItem(card: card)),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }
}

class _FlashcardItem extends StatefulWidget {
  final Flashcard card;

  const _FlashcardItem({required this.card});

  @override
  State<_FlashcardItem> createState() => _FlashcardItemState();
}

class _FlashcardItemState extends State<_FlashcardItem> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _isFlipped = !_isFlipped;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _isFlipped ? Icons.flip : Icons.question_answer,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.card.question,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 12, left: 26),
                  child: Text(
                    widget.card.answer,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                crossFadeState: _isFlipped
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
              if (!_isFlipped)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 26),
                  child: Text(
                    'Tap to reveal answer',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
