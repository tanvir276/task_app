
import 'package:task_app/feature/dashboard/data/model/dashboard_response.dart';
import 'package:task_app/feature/dashboard/domain/repository/dashboard_repository.dart';

class DashboardUsecase {
  final DashboardRepository _dashboardRepository;

  DashboardUsecase(this._dashboardRepository);

  Future<DashboardResponse> call() =>
      _dashboardRepository.dashboard();
}
