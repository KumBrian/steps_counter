import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pedometer/pedometer.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  int steps = 0;
  final Box<Map<dynamic, dynamic>> stepHistoryBox =
      Hive.box<Map<dynamic, dynamic>>('stepHistoryBox');

  // Listen to step count stream
  Pedometer.stepCountStream.listen((stepCount) {
    steps = stepCount.steps;

    // Update step history
    final Map<String, int> currentHistory =
        Map<String, int>.from(stepHistoryBox.get('history') ?? {});
    final String date = DateFormat.EEEE().format(DateTime.now());

    if (currentHistory.containsKey(date)) {
      currentHistory[date] = currentHistory[date]! + steps;
    } else {
      currentHistory[date] = steps;
    }

    // Ensure only the last 7 days are kept
    if (currentHistory.length > 7) {
      final keysToRemove = currentHistory.keys.toList()..sort();
      currentHistory.remove(keysToRemove.first);
    }

    stepHistoryBox.put('history', currentHistory.cast<dynamic, dynamic>());

    // Notify Cubit (if app is in foreground)
    if (service is AndroidServiceInstance) {
      service
          .invoke('updateSteps', {'steps': steps, 'history': currentHistory});
    }

    // Show notification
    showStepNotification(steps);
  });
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_bg_service_small');

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
