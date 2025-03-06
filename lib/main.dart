import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:stepie/cubits/step_counter_cubit.dart';
import 'package:stepie/screens/splash_screen.dart';
import 'package:stepie/utils/background_services.dart';
import 'package:stepie/utils/utils.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<Map<dynamic, dynamic>>('stepHistoryBox');
  initializeNotifications();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: false,
  );

  // Register periodic task
  Workmanager().registerPeriodicTask(
    'stepTrackerTask',
    'stepTracking',
    frequency: Duration(minutes: 5), // Adjust frequency as needed
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StepCounterCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        home: SplashScreen(),
      ),
    );
  }
}
