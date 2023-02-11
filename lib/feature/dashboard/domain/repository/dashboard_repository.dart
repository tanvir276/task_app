
import 'package:task_app/feature/dashboard/data/model/dashboard_response.dart';

abstract class DashboardRepository {
  Future<DashboardResponse> dashboard();
}
