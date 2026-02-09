import 'package:careme24/models/service_model.dart';
import 'package:careme24/pages/med/reviews_list_screen.dart';
import 'package:careme24/pages/payment/payment_defoult_screen.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/outline_gradient_button.dart';
import 'package:careme24/widgets/time_container.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/date_container.dart';
import '../more_time_to_record/record_details_page.dart';

class AppointmentToDoctorScreen extends StatefulWidget {
  final ServiceModel serviceModel;
  final String cardId;
  final String problem;
  const AppointmentToDoctorScreen(
      {required this.problem,
      required this.serviceModel,
      required this.cardId,
      super.key});

  @override
  State<AppointmentToDoctorScreen> createState() =>
      _AppointmentToDoctorScreenState();
}

class _AppointmentToDoctorScreenState extends State<AppointmentToDoctorScreen> {
  int isSelectedIndex = -1;

  String? selectedTime;

  callBackTime(String? varTime) {
    setState(() {
      selectedTime = varTime;
      print(selectedTime);
    });
  }

  bool isRecordSelected() {
    return selectedTime != null && isSelectedIndex != -1;
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
      backgroundColor: ColorConstant.gray100,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          height: getVerticalSize(48),
          leadingWidth: 43,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: AppbarTitle(text: 'Запись к врачу'),
          styleType: Style.bgFillBlue60001),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 160,
            decoration: AppDecoration.outlineBlack9003f2.copyWith(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: AppDecoration.outlineBlack9003f2,
                  height: 173,
                  child: Row(
                    children: [
                      CustomImageView(
                        url: widget.serviceModel.photo,
                        height: 173,
                        width: 100,
                        fit: BoxFit.cover,
                        radius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      Padding(
                        padding: getPadding(top: 14, left: 18),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.serviceModel.name,
                                style: AppStyle.txtMontserratSemiBold18,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.serviceModel.specialization,
                                style: AppStyle.txtMontserratMedium15Blue600,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Padding(
                                padding: getPadding(top: 12),
                                child: SizedBox(
                                    width: 160,
                                    child: Text(
                                      widget.serviceModel.workPlace,
                                      style: AppStyle
                                          .txtMontserratMedium12Gray50001,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    )),
                              ),
                              Padding(
                                padding: getPadding(top: 22, bottom: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "Оценка",
                                      style: AppStyle
                                          .txtMontserratRegular12Black900,
                                    ),
                                    Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ReviewsScreen(
                                                          serviceId: widget
                                                              .serviceModel.id,
                                                          doctor_name: widget
                                                              .serviceModel
                                                              .name,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                    padding:
                                                        getPadding(left: 25),
                                                    child: Text(
                                                        widget.serviceModel
                                                            .averageRating
                                                            .toStringAsFixed(1),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtMontserratMedium15Bluegray800)),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: CustomImageView(
                                                      svgPath: ImageConstant
                                                          .imgStarGold,
                                                      height: getSize(12),
                                                      width: getSize(12),
                                                      margin: getMargin(
                                                          left: 3,
                                                          top: 3,
                                                          bottom: 3)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    Padding(
                                      padding: getPadding(left: 100),
                                      child: CustomImageView(
                                          svgPath: ImageConstant.imgArrowright,
                                          height: getSize(12),
                                          width: getSize(12),
                                          margin: getMargin(
                                              left: 3, top: 3, bottom: 3)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: getPadding(top: 12, left: 24, bottom: 12),
                        child: Text(
                          "Дата записи",
                          style: AppStyle.txtMontserratSemiBold18Black900,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 86,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.all(8),
                                itemCount: dates.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          setState(() {
                                            isSelectedIndex =
                                                isSelectedIndex == index
                                                    ? -1
                                                    : index;
                                          });
                                        },
                                        child: DateContainer(
                                          background: isSelectedIndex == index
                                              ? Colors.blue
                                              : Colors.white,
                                          dayColor: isSelectedIndex == index
                                              ? const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)
                                              : const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                          weekDayColor: isSelectedIndex == index
                                              ? const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500)
                                              : const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                          weekDay: dates[index]['weekDay']!,
                                          day: dates[index]['day']!,
                                        )),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        const SizedBox(width: 8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: getPadding(top: 12, left: 24, bottom: 12),
                        child: Text(
                          "Время записи",
                          style: AppStyle.txtMontserratSemiBold18Black900,
                        ),
                      ),
                      Center(
                          child: TimeContainer(
                        // timeCount: 20,
                        callback: callBackTime,
                      )),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: getPadding(
                                  left: 20, top: 14, right: 20, bottom: 12),
                              child: OutlineGradientButton(
                                  padding: EdgeInsets.only(
                                      left: getHorizontalSize(1),
                                      top: getVerticalSize(1),
                                      right: getHorizontalSize(1),
                                      bottom: getVerticalSize(1)),
                                  strokeWidth: getHorizontalSize(1),
                                  gradient: LinearGradient(
                                      begin: const Alignment(1.05, 0.11),
                                      end: const Alignment(-0.02, 0.83),
                                      colors: [
                                        ColorConstant.blue600,
                                        ColorConstant.indigoA400
                                      ]),
                                  corners: const Corners(
                                      topLeft: Radius.circular(7),
                                      topRight: Radius.circular(7),
                                      bottomLeft: Radius.circular(7),
                                      bottomRight: Radius.circular(7)),
                                  child: CustomButton(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RecordDetailsOneScreen(
                                                      id: widget
                                                          .serviceModel.id,
                                                      summa: widget
                                                          .serviceModel.price
                                                          .toInt(),
                                                    )));
                                      },
                                      height: getVerticalSize(47),
                                      text: "Больше",
                                      variant: ButtonVariant.Outline,
                                      padding: ButtonPadding.PaddingAll12,
                                      fontStyle: ButtonFontStyle
                                          .MontserratRomanSemiBold15Blue,
                                      alignment: Alignment.center)))),
                    ],
                  ),
                )),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (isRecordSelected()) {
                      final now = DateTime.now();
                      final selectedDate =
                          now.add(Duration(days: isSelectedIndex));
                      final hour = int.parse(selectedTime!.split(':')[0]);
                      final minute = int.parse(selectedTime!.split(':')[1]);

                      final appointmentTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        hour,
                        minute,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentDefoultScreen(
                              id: widget.serviceModel.id,
                              summa: widget.serviceModel.price.toInt(),
                              cardId: widget.cardId,
                              problem: widget.problem,
                              appointmentTime: appointmentTime.toUtc(),
                              type: 'med'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: getMargin(bottom: 10),
                    padding: getPadding(
                      left: 50,
                      right: 50,
                    ),
                    width: MediaQuery.of(context).size.width - 40,
                    height: 56,
                    decoration: BoxDecoration(
                        gradient: isRecordSelected()
                            ? LinearGradient(
                                colors: [
                                  ColorConstant.indigoA400,
                                  ColorConstant.bluegradient,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              )
                            : LinearGradient(
                                colors: [
                                  ColorConstant.gray50001,
                                  ColorConstant.gray50001,
                                ],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.serviceModel.price.toString(),
                          style: AppStyle.txtMontserratSemiBold18WhiteA700,
                        ),
                        Text(
                          "Записаться",
                          style: AppStyle.txtMontserratSemiBold18WhiteA700,
                        ),
                      ],
                    )),
                  ),
                ),
              ))
        ],
      ),
    ));
  }
}

/*onTap: () {
                  if (isRecordSelected()){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDefoultScreen()));
                  }
                },*/
