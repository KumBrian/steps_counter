import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';

class StepCounterCubit extends Cubit<Map<String, dynamic>> {
  final Box<Map<dynamic, dynamic>> stepHistoryBox;

  StepCounterCubit()
      : stepHistoryBox = Hive.box<Map<dynamic, dynamic>>('stepHistoryBox'),
        super({
          'currentSteps': 0,
          'history': (Hive.box<Map<dynamic, dynamic>>('stepHistoryBox')
                  .get('history', defaultValue: <String, int>{}) as Map)
              .cast<String, int>()
        }) {
    // Listen for background service updates
    FlutterBackgroundService().on('updateSteps').listen((event) {
      if (event != null) {
        final steps = event['steps'] as int;
        final history = event['history'] as Map<String, int>;
        emit({'currentSteps': steps, 'history': history});
      }
    });

    // Start step counting
    countSteps();
  }

  void countSteps() async {
    late Stream<StepCount> stepCountStream;
    stepCountStream = Pedometer.stepCountStream;
    int? previousSteps;
    stepCountStream.listen((event) {
      if (previousSteps == null) {
        previousSteps = event.steps;
        emit({'currentSteps': 0, 'history': state['history']});
      } else {
        int newSteps = event.steps - previousSteps!;
        previousSteps = event.steps;
        int updatedSteps = state['currentSteps'] + newSteps;
        emit({'currentSteps': updatedSteps, 'history': state['history']});
        addStepToHistory(newSteps);
      }
    }, onError: (e) {
      // ignore: avoid_print
      print('Step Count Error: $e');
    });
  }

  void addStepToHistory(int steps) {
    final Map<String, int> currentHistory =
        Map<String, int>.from(state['history']);
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
    emit({'currentSteps': state['currentSteps'], 'history': currentHistory});
  }
}
