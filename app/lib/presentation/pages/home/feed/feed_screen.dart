import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../providers/link_providers.dart';
import '../../../../providers/project_providers.dart';
import '../../../widgets/feed/recent_projects_section.dart';
import '../../../widgets/feed/recent_links_section.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    Future.microtask(() {
      ref.read(linksProvider.notifier).loadLinks();
      ref.read(projectsProvider.notifier).loadProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent Projects Section (Horizontal Scrollable)
            RecentProjectsSection(),
            SizedBox(height: 24),
            // Recent Saved Links Section (Vertical List)
            RecentLinksSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/add-link');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Link'),
      ),
    );
  }
}
