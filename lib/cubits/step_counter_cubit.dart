import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class StepCounterCubit extends Cubit<Map<String, dynamic>> {
  final Box<Map<dynamic, dynamic>> stepHistoryBox;
  Timer? _timer;

  StepCounterCubit()
      : stepHistoryBox = Hive.box<Map<dynamic, dynamic>>('stepHistoryBox'),
        super({
          'currentSteps': 0,
          'history': (Hive.box<Map<dynamic, dynamic>>('stepHistoryBox')
                  .get('history', defaultValue: <String, int>{}) as Map)
              .cast<String, int>()
        }) {
    fetchStepData();
    startStepUpdates();
    _initialize();
  }

  void _initialize() {
    fetchStepData();
    startStepUpdates();
    // Start notifications automatically
  }

  Future<void> fetchStepData() async {
    // Check SDK availability
    final availabilityStatus = await Health().getHealthConnectSdkStatus();

    if (availabilityStatus == HealthConnectSdkStatus.sdkUnavailable) {
      return; // No integration possible
    }

    if (availabilityStatus ==
        HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired) {
      // Redirect to Google Play Store for update
      final String providerPackageName = "com.google.android.apps.healthdata";
      final String uriString =
          "market://details?id=$providerPackageName&url=healthconnect%3A%2F%2Fonboarding";

      final Uri uri = Uri.parse(uriString);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
      return;
    }

    HealthDataType type = HealthDataType.STEPS;
    requestPermissions(type);
  }

  void countSteps(HealthDataType type) async {
    final Health health = Health();
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);

    if (kDebugMode) {
      print("Fetching step data from $todayMidnight to $now");
    }

    List<HealthDataPoint> stepData = await health.getHealthDataFromTypes(
        startTime: todayMidnight, endTime: now, types: [type]);

    // Ensure numericValue is not null before summing
    int totalSteps = stepData.fold(0, (sum, dataPoint) {
      final value = dataPoint.value;
      if (value is NumericHealthValue) {
        return sum + (value.numericValue.toInt());
      }
      return sum;
    });

    if (kDebugMode) {
      print('🔥 Total Steps Today: $totalSteps');
    }

    // Update the UI with the step count
    updateStepCount(totalSteps);
  }

  void requestPermissions(HealthDataType type) async {
    final Health health = Health();
    health.configure();
    await health
        .requestAuthorization([type], permissions: [HealthDataAccess.READ]);

    final permissions = await health
        .hasPermissions([type], permissions: [HealthDataAccess.READ]);

    if (permissions!) {
      try {
        countSteps(type);
        return;
      } catch (e) {
        if (kDebugMode) {
          print("Error retrieving steps: $e");
        }
      }
    } else {
      requestPermissions(type);
    }
  }

  void startStepUpdates() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      countSteps(HealthDataType.STEPS);
      // Fetch steps every 10 seconds
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 10,
              channelKey: 'stepie',
              title: 'Stepie',
              body: 'You have done ${state['currentSteps']} steps today'));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // Cancel timer when cubit is closed
    return super.close();
  }

  void updateStepCount(int steps) {
    //TODO: send notification
    final Map<String, int> currentHistory =
        Map<String, int>.from(state['history']);
    final String date = DateFormat.EEEE().format(DateTime.now().toLocal());

    currentHistory[date] = steps;

    // Ensure only the last 7 days are kept
    if (currentHistory.length > 7) {
      final keysToRemove = currentHistory.keys.toList()..sort();
      currentHistory.remove(keysToRemove.first);
    }

    stepHistoryBox.put('history', currentHistory.cast<dynamic, dynamic>());
    emit({'currentSteps': steps, 'history': currentHistory});
  }
}
