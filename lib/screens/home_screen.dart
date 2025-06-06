import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:stepie/cubits/step_counter_cubit.dart';
import 'package:stepie/utils/utils.dart';
import 'package:stepie/widgets/custom_card.dart';
import 'package:stepie/widgets/graph_widget.dart';
import 'package:stepie/widgets/history_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    BlocProvider.of<StepCounterCubit>(context).fetchStepData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Start background service when app is minimized
      FlutterBackgroundService().startService();
    }
    if (state == AppLifecycleState.resumed) {
      // Stop background service when app is resumed
      FlutterBackgroundService().invoke('stopService');
    }
  }

  List<String> dates = List.generate(7, (index) {
    DateTime date = DateTime.now().subtract(Duration(days: index));
    return DateFormat.EEEE().format(date);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          title:
              Text('S T E P S  C O U N T E R', style: AppFonts.appBarHeading),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(flex: 2, child: CustomCard()),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'H I S T O R Y ',
                style: AppFonts.heading,
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  right: 16,
                ),
                itemCount: 7,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                    ),
                    child: HistoryCard(
                      size: MediaQuery.of(context).size.width * 0.2,
                      date: dates[index],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'P R O G R E S S',
                style: AppFonts.heading,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: 10,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GraphWidget(),
                ),
              ),
            ),
          ],
        ));
  }
}
