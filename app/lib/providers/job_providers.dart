import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/job_model.dart';
import '../../data/repositories/job_repository.dart';

// Job Repository Provider
final jobRepositoryProvider = Provider<JobRepository>((ref) {
  return JobRepository();
});

// Job State
class JobState {
  final JobModel? job;
  final bool isLoading;
  final String? error;

  JobState({
    this.job,
    this.isLoading = false,
    this.error,
  });

  JobState copyWith({
    JobModel? job,
    bool? isLoading,
    String? error,
  }) {
    return JobState(
      job: job ?? this.job,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Job StateNotifier
class JobNotifier extends StateNotifier<JobState> {
  final JobRepository _jobRepository;

  JobNotifier(this._jobRepository) : super(JobState());

  /// Load job by ID
  Future<void> loadJob(String jobId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final job = await _jobRepository.getJobById(jobId);
      state = JobState(job: job, isLoading: false);
    } catch (e) {
      state = JobState(
        job: state.job,
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  /// Poll job until completion
  Future<JobModel?> pollJob({
    required String jobId,
    int maxAttempts = 30,
    Duration interval = const Duration(seconds: 2),
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final job = await _jobRepository.pollJob(
        jobId: jobId,
        maxAttempts: maxAttempts,
        interval: interval,
      );
      state = JobState(job: job, isLoading: false);
      return job;
    } catch (e) {
      state = JobState(
        job: state.job,
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
      return null;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Job Provider
final jobProvider =
    StateNotifierProvider.family<JobNotifier, JobState, String>((ref, jobId) {
  final repository = ref.watch(jobRepositoryProvider);
  return JobNotifier(repository);
});

// Get job by ID from repository (for direct access)
final jobByIdProvider = Provider.family<JobModel?, String>((ref, jobId) {
  // Use the jobNotifier provider to get job state
  final jobState = ref.watch(jobProvider(jobId));
  return jobState.job;
});
