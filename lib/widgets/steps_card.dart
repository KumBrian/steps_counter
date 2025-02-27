import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:steps_counter/cubits/step_counter_cubit.dart';
import 'package:steps_counter/utils/utils.dart';

class StepsCard extends StatefulWidget {
  const StepsCard({
    super.key,
    this.size = 120,
  });

  final double? size;

  @override
  State<StepsCard> createState() => _StepsCardState();
}

class _StepsCardState extends State<StepsCard> {
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
                  return Text(
                    '${stepCounterCubit.state['currentSteps']}',
                    style: AppFonts.appBarheading
                        .copyWith(color: AppColors.purpleColor),
                  );
                },
              ),
              Text('STEPS', style: AppFonts.normalText),
            ],
          ),
        ),
        Text(
          'TODAY',
          style: AppFonts.smallText,
        ),
      ],
    );
  }
}
