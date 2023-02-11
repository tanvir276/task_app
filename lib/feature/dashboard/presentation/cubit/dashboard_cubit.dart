import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_app/feature/dashboard/data/model/dashboard_response.dart';
import 'package:task_app/feature/dashboard/domain/usecase/dashboard_usecase.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardUsecase dashboardUsecase;
  DashboardCubit({required this.dashboardUsecase}) : super(DashboardInitial());

  Future<void> dashboard() async {
    try {
      // print('in try\n\n\n\n\n\n');
      emit(DashboardLoading());
      final responseModel = await dashboardUsecase();
      emit(DashboardSuccess(model: responseModel));
    } catch (ex, strackTrace) {
      print('in exception');
      // log('exception:${json.encode(ex)}');

      emit(DashboardFailure(ex, strackTrace));
    }
  }
}
