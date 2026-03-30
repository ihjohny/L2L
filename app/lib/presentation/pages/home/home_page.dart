import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/link_providers.dart';
import '../../../providers/project_providers.dart';
import 'widgets/recent_projects_section.dart';
import 'widgets/recent_links_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
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
        title: const Text('Home'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/add-link');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
