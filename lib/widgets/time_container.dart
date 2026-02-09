import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TimeContainer extends StatefulWidget {
  final Function(String?) callback;

  const TimeContainer({super.key, required this.callback});

  @override
  State<TimeContainer> createState() => _TimeContainerState();
}

class _TimeContainerState extends State<TimeContainer> {
  int isSelectedIndex = -1;
  late List<String> timeSlots;

  @override
  void initState() {
    super.initState();
    timeSlots = generateTimeSlots();
  }

  List<String> generateTimeSlots() {
    List<String> slots = [];
    DateTime startTime = DateTime(2025, 1, 1, 9, 30); // 09:30
    DateTime endTime = DateTime(2025, 1, 1, 18, 00); // 18:00
    final formatter = DateFormat.Hm(); // Formats time like "9:30", "10:00"

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      slots.add(formatter.format(startTime));
      startTime = startTime.add(const Duration(minutes: 30));
    }
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(top: 22, left: 14, right: 14, bottom: 22),
      width: MediaQuery.of(context).size.width - 40,
      decoration: AppDecoration.smallOutBlackLine.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
        color: Colors.white,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 96,
          childAspectRatio: 96 / 26,
          mainAxisSpacing: 18,
          crossAxisSpacing: 18,
        ),
        itemCount: timeSlots.length,
        itemBuilder: (BuildContext ctx, index) {
          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    if (isSelectedIndex == index) {
                      isSelectedIndex = -1;
                      widget.callback(null);
                    } else {
                      isSelectedIndex = index;
                      widget.callback(timeSlots[index]);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorConstant.gray300),
                    borderRadius: BorderRadius.circular(10),
                    color: isSelectedIndex == index
                        ? ColorConstant.bluebg
                        : Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      timeSlots[index],
                      style: isSelectedIndex == index
                          ? AppStyle.txtMontserratSemiBold12WhiteA700
                          : AppStyle.txtMontserratSemiBold12Black900,
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}
