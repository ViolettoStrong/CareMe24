import 'package:careme24/pages/payment/payment_defoult_screen.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/time_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_style.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/date_container.dart';

class RecordDetailsOneScreen extends StatefulWidget {
  final String id;
  final int summa;
  const RecordDetailsOneScreen(
      {required this.id, required this.summa, super.key});

  @override
  State<RecordDetailsOneScreen> createState() => _RecordDetailsOneScreenState();
}

class _RecordDetailsOneScreenState extends State<RecordDetailsOneScreen> {
  bool isSelectedIndexTime = false;
  int isSelectedIndex1 = -1;
  int isSelectedIndex2 = -1;

  callBackTime(varTime) {
    setState(() {
      isSelectedIndexTime = varTime;
    });
  }

  bool isRecordSelected() {
    return isSelectedIndexTime == true &&
            (isSelectedIndex1 != -1 || isSelectedIndex2 != -1)
        ? true
        : false;
  }

  List<Map<String, String>> getDates() {
    final now = DateTime.now();
    final formatter = DateFormat('EE', 'ru_RU'); // Weekday in Russian
    final dayFormatter = DateFormat('d', 'ru_RU'); // Day number

    return List.generate(10, (index) {
      final date = now.add(Duration(days: index));
      return {
        'weekDay': formatter
            .format(date)
            .toUpperCase(), // Convert to uppercase if needed
        'day': dayFormatter.format(date),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final dates = getDates();
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            appBar: CustomAppBar(
                height: getVerticalSize(48),
                leadingWidth: 43,
                leading: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                centerTitle: true,
                title: AppbarTitle(text: 'Запись к врачу'),
                styleType: Style.bgFillBlue60001),
            body: SizedBox(
                width: size.width,
                child: SingleChildScrollView(
                    padding: getPadding(top: 18),
                    child: Padding(
                        padding: getPadding(left: 22, right: 36, bottom: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("На этой неделе",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtH1),
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                      padding: getPadding(
                                          left: 19, top: 13, right: 4),
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  mainAxisExtent:
                                                      getVerticalSize(67),
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing:
                                                      getHorizontalSize(18),
                                                  crossAxisSpacing:
                                                      getHorizontalSize(18)),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 6,
                                          itemBuilder: (context, index) {
                                            return Material(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    onTap: () {
                                                      setState(() {
                                                        if (isSelectedIndex1 ==
                                                            index) {
                                                          isSelectedIndex1 = -1;
                                                        } else {
                                                          isSelectedIndex1 =
                                                              index;
                                                        }
                                                        isSelectedIndex2 = -1;
                                                      });
                                                    },
                                                    child: DateContainer(
                                                      background:
                                                          isSelectedIndex1 ==
                                                                  index
                                                              ? Colors.blue
                                                              : Colors.white,
                                                      dayColor:
                                                          isSelectedIndex1 ==
                                                                  index
                                                              ? const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)
                                                              : const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                      weekDayColor:
                                                          isSelectedIndex1 ==
                                                                  index
                                                              ? const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)
                                                              : const TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                      weekDay: dates[index]
                                                          ['weekDay']!,
                                                      day: dates[index]['day']!,
                                                    )));
                                          }))),
                              Padding(
                                  padding: getPadding(left: 2, top: 31),
                                  child: Text("На следующей неделе",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtH1)),
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                      padding: getPadding(
                                          left: 19, top: 12, right: 4),
                                      child: GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  mainAxisExtent:
                                                      getVerticalSize(67),
                                                  crossAxisCount: 4,
                                                  mainAxisSpacing:
                                                      getHorizontalSize(18),
                                                  crossAxisSpacing:
                                                      getHorizontalSize(18)),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 4,
                                          itemBuilder: (context, index) {
                                            return Material(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  onTap: () {
                                                    setState(() {
                                                      if (isSelectedIndex2 ==
                                                          index) {
                                                        isSelectedIndex2 = -1;
                                                      } else {
                                                        isSelectedIndex2 =
                                                            index;
                                                      }
                                                      isSelectedIndex1 = -1;
                                                    });
                                                  },
                                                  child: DateContainer(
                                                    background:
                                                        isSelectedIndex2 ==
                                                                index
                                                            ? Colors.blue
                                                            : Colors.white,
                                                    dayColor:
                                                        isSelectedIndex2 ==
                                                                index
                                                            ? const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)
                                                            : const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                    weekDayColor:
                                                        isSelectedIndex2 ==
                                                                index
                                                            ? const TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)
                                                            : const TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                    weekDay: dates[index + 6]
                                                        ['weekDay']!,
                                                    day: dates[index + 6]
                                                        ['day']!,
                                                  ),
                                                ));
                                          }))),
                              Padding(
                                  padding:
                                      getPadding(left: 1, top: 36, bottom: 12),
                                  child: Text("Время записи",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtH1)),
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: getPadding(
                                      left: 12,
                                      top: 12,
                                    ),
                                    child: Center(
                                        child: TimeContainer(
                                      // timeCount: 17,
                                      callback: callBackTime,
                                    )),
                                  )),
                            ])))),
            bottomNavigationBar: CustomButton(
                height: getVerticalSize(56),
                text: "Записаться",
                margin: getMargin(left: 24, right: 22, bottom: 20, top: 10),
                variant: isRecordSelected()
                    ? ButtonVariant.GradientBlue60001IndigoA400
                    : ButtonVariant.FillGray50001,
                fontStyle: isRecordSelected()
                    ? ButtonFontStyle.MontserratRomanSemiBold18White
                    : ButtonFontStyle.MontserratRomanSemiBold18Gray300,
                onTap: () {
                  if (isRecordSelected()) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentDefoultScreen(
                                  id: widget.id,
                                  summa: widget.summa,
                                  type: 'med',
                                )));
                  }
                })));
  }

  onTapArrowleft26(BuildContext context) {
    Navigator.pop(context);
  }
}
