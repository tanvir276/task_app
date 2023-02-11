import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/feature/dashboard/presentation/screen/dashboard_screen.dart';
import 'package:task_app/utils/dependency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Dependency.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: Dependency.providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Dashboard(),
      ),
    );
  }
}
