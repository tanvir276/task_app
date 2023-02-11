import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task_app/exceptions/exceptions.dart';
import 'package:task_app/feature/dashboard/data/model/dashboard_response.dart';
import 'package:task_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:task_app/feature/dashboard/presentation/widget/dashboard_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    callDashboard();
  }

  callDashboard() async {
    await BlocProvider.of<DashboardCubit>(context).dashboard();
  }

  @override
  Widget build(BuildContext context) {
    // isLangBangla = locale.contains('bn');

    return BlocBuilder<DashboardCubit, DashboardState>(
        builder: (ctx, DashboardState state) {
      switch (state.runtimeType) {
        case DashboardSuccess:
          List<Videos>? data = (state as DashboardSuccess).model.data;

          return 
        DashboardWidget(
          data: data,
        );
        case DashboardLoading:
          return Center(
            child: LoadingAnimationWidget.stretchedDots(
              color: Colors.green.withOpacity(0.5),
              size: 50,
            ),
          );
        case DashboardFailure:
          // final ex = (state as DashboardFailure).exception;

          // if (ex is ServerException) {

          //   return Center(child: Text(ex.message ?? ''));
          // } else {

          //   return const Center(child: Text(" Went Wrong"));
          // }
          return const Center(child: Text(" Went Wrong"));

        default:
          return const Center(child: Text("Something Went Wrong; try again"));
      }
    });
  }
}
