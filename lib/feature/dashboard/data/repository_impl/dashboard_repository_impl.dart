

import 'package:task_app/exceptions/exceptions.dart';
import 'package:task_app/feature/dashboard/data/model/dashboard_response.dart';
import 'package:task_app/feature/dashboard/data/remote/dashboard_remote.dart';
import 'package:task_app/feature/dashboard/domain/repository/dashboard_repository.dart';
import 'package:task_app/network/connection_checker.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final ConnectionChecker _connectionChecker;
  final DashboardRemote dashboardRemote;

  DashboardRepositoryImpl(
      this._connectionChecker, this.dashboardRemote);

  @override
  Future<DashboardResponse> dashboard() async {
    if (!await _connectionChecker.isConnected()) throw NoInternetException();
    DashboardResponse dashboardResponse =
        await dashboardRemote.dashboard();
    return dashboardResponse;
  }
}
