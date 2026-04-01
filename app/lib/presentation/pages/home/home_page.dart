import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../presentation/viewmodels/link_viewmodel.dart';
import '../../../presentation/viewmodels/project_viewmodel.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(linkViewModelProvider.notifier).loadLinks();
        ref.read(projectViewModelProvider.notifier).loadProjects();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_link),
            onPressed: () {
              context.push('/add-link');
            },
            tooltip: 'Add Link',
          ),
        ],
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
    );
  }
}
