import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../viewmodels/link_list/link_list_viewmodel.dart';
import '../../viewmodels/projects_list/projects_list_viewmodel.dart';
import 'widgets/recent_projects_section.dart';
import 'widgets/recent_links_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  /// Refresh both links and projects data
  Future<void> _refreshData() async {
    // Load both links and projects in parallel
    await Future.wait([
      ref.read(linkListViewModelProvider.notifier).loadLinks(),
      ref.read(projectsListViewModelProvider.notifier).loadProjects(),
    ]);
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: const SingleChildScrollView(
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
      ),
    );
  }
}
