part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardSuccess extends DashboardState {
  final DashboardResponse model;

  const DashboardSuccess({
    required this.model,
  });}
class DashboardFailure extends DashboardState {
  final StackTrace stackTrace;
  final Object exception;

  const DashboardFailure(this.exception, this.stackTrace);
}
