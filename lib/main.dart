import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:steps_counter/cubits/step_counter_cubit.dart';
import 'package:steps_counter/screens/home_screen.dart';
import 'package:steps_counter/utils/utils.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<Map<dynamic, dynamic>>('stepHistoryBox');
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
        title: 'Flutter Demo',
        theme: darkTheme,
        home: HomeScreen(),
      ),
    );
  }
}
