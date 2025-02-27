import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:steps_counter/utils/utils.dart';
import 'package:steps_counter/widgets/steps_card.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        top: 20,
        right: 16,
        bottom: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WELCOME BACK!',
                    style: AppFonts.normalText,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Daily Goal: ',
                          style: AppFonts.normalText,
                        ),
                        TextSpan(
                          text: '1000',
                          style: AppFonts.normalText
                              .copyWith(color: AppColors.greenTextColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Day: ${DateFormat.EEEE().format(DateTime.now())}',
                    style: AppFonts.normalText,
                  ),
                ],
              ),
              StepsCard(),
            ],
          ),
        ),
      ),
    );
  }
}
