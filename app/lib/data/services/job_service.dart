import '../../core/network/dio_client.dart';
import '../models/job_model.dart';

class JobService {
  final DioClient _dioClient = DioClient.instance;

  /// Get job status by ID
  Future<JobModel> getJobById(String jobId) async {
    try {
      final response = await _dioClient.dio.get('/jobs/$jobId');

      if (response.statusCode == 200) {
        return JobModel.fromJson(response.data['data']);
      }
      throw Exception('Failed to fetch job status');
    } catch (e) {
      throw _dioClient.handleError(e);
    }
  }

  /// Poll job until completion (with max attempts)
  Future<JobModel> pollJob({
    required String jobId,
    int maxAttempts = 30,
    Duration interval = const Duration(seconds: 2),
  }) async {
    for (int i = 0; i < maxAttempts; i++) {
      final job = await getJobById(jobId);

      if (job.isCompleted || job.isFailed) {
        return job;
      }

      await Future.delayed(interval);
    }
    throw Exception('Job polling timed out');
  }
}
