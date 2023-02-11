import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/feature/dashboard/data/remote/dashboard_remote.dart';
import 'package:task_app/feature/dashboard/data/repository_impl/dashboard_repository_impl.dart';
import 'package:task_app/feature/dashboard/domain/repository/dashboard_repository.dart';
import 'package:task_app/feature/dashboard/domain/usecase/dashboard_usecase.dart';
import 'package:task_app/feature/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:task_app/header_provider/header_provider.dart';
import 'package:task_app/network/connection_checker.dart';
import 'package:task_app/token_source.dart';

// import '../../features/division_list/presentation/cubit/division_list_cubit.dart';

class Dependency {
  static final sl = GetIt.instance;
  Dependency._init();

  static Future<void> init() async {
     sl.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImpl(),
    );
    sl.registerLazySingleton<TokenSource>(() => TokenSourceImpl(sl()));
    sl.registerLazySingleton<HeaderProvider>(() => HeaderProviderImpl());
    sl.registerLazySingleton(() => AuthHeaderProvider(sl()));

//---------------------------Dashboard Start-------------------------------//

    sl.registerLazySingleton<DashboardRemote>(
      () => DashboardRemoteImpl(sl()),
    );

    sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(
        sl(),
        sl(),
      ),
    );
    sl.registerLazySingleton(() => DashboardUsecase(sl()));
    sl.registerFactory(() => DashboardCubit(dashboardUsecase: sl()));

    //---------------------------Dashboard End-------------------------------//
  }

  static final providers = <BlocProvider>[
    BlocProvider<DashboardCubit>(
      create: (context) => Dependency.sl<DashboardCubit>(),
    ),
  ];
}
