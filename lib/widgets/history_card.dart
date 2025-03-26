import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stepie/cubits/step_counter_cubit.dart';
import 'package:stepie/utils/utils.dart';

class HistoryCard extends StatefulWidget {
  const HistoryCard({
    super.key,
    this.size = 120,
    required this.date,
  });

  final double? size;
  final String date;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 5,
      children: [
        Container(
          height: widget.size,
          width: widget.size,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            border: Border.all(
              color: AppColors.purpleColor,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<StepCounterCubit, Map<String, dynamic>>(
                builder: (context, state) {
                  StepCounterCubit stepCounterCubit =
                      BlocProvider.of<StepCounterCubit>(context);
                  return stepCounterCubit.state['history'][widget.date] == null
                      ? Text('-')
                      : Text(
                          '${stepCounterCubit.state['history'][widget.date]}',
                          style: AppFonts.appBarHeading
                              .copyWith(color: AppColors.purpleColor),
                        );
                },
              ),
              Text('STEPS', style: AppFonts.normalText),
            ],
          ),
        ),
        Text(
          widget.date.toUpperCase(),
          style: AppFonts.smallText,
        ),
      ],
    );
  }
}
