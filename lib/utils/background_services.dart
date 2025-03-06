import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stepie/cubits/step_counter_cubit.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    StepCounterCubit stepCounterCubit = StepCounterCubit();
    // Fetch step count
    final steps = stepCounterCubit.state['currentSteps'];

    // Show notification with step count
    showStepNotification(steps);

    return Future.value(true);
  });
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void showStepNotification(int steps) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'step_tracker_channel',
    'Step Tracker',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: false,
    ongoing: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    1,
    'Step Tracker',
    'Steps: $steps',
    platformChannelSpecifics,
  );
}

void startForegroundService() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'step_tracker_foreground',
    'Step Tracker',
    importance: Importance.low,
    priority: Priority.low,
    ongoing: true,
    showWhen: false,
  );

  await flutterLocalNotificationsPlugin.show(
    2,
    'Step Tracker Active',
    'Tracking your steps in the background',
    NotificationDetails(android: androidPlatformChannelSpecifics),
  );
}
