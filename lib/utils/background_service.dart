import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      // Initialize Hive in background isolate
      final appDir = await path_provider.getApplicationDocumentsDirectory();
      Hive.init(appDir.path);

      // Open your step box
      final box = await Hive.openBox('stepHistoryBox');

      // Get latest steps from Hive
      final steps = box.get('currentSteps', defaultValue: 0) as int;

      // Update notification
      return true;
    } catch (e) {
      return false;
    }
  });
}

void setupBackgroundTasks() {
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    'step-updates',
    'updateStepsNotification',
    frequency: const Duration(minutes: 5),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
}
