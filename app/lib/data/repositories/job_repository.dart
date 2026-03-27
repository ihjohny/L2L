import '../models/job_model.dart';
import '../services/job_service.dart';

class JobRepository {
  final JobService _jobService;

  JobRepository({JobService? jobService})
      : _jobService = jobService ?? JobService();

  /// Get job status by ID
  Future<JobModel> getJobById(String jobId) async {
    return await _jobService.getJobById(jobId);
  }

  /// Poll job until completion (with max attempts)
  Future<JobModel> pollJob({
    required String jobId,
    int maxAttempts = 30,
    Duration interval = const Duration(seconds: 2),
  }) async {
    return await _jobService.pollJob(
      jobId: jobId,
      maxAttempts: maxAttempts,
      interval: interval,
    );
  }
}
