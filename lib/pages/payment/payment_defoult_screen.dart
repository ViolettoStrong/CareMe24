import 'package:careme24/api/api.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/pages/call_waiting_window_screen/call_waiting_window_screen.dart';
import 'package:careme24/pages/med/appointment_page.dart';
import 'package:careme24/pages/record_final_screen/record_final_screen.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_button.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/widgets/custom_text_form_field.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

import '../../theme/app_decoration.dart';

class PaymentDefoultScreen extends StatefulWidget {
  final String id;
  final int summa;
  final DateTime? appointmentTime;
  final String? cardId;
  final String? problem;
  final String type;

  const PaymentDefoultScreen({
    required this.id,
    required this.summa,
    this.appointmentTime,
    this.cardId,
    this.problem,
    required this.type,
    super.key,
  });

  @override
  State<PaymentDefoultScreen> createState() => _PaymentDefoultScreenState();
}

bool _isSave = false;

class _PaymentDefoultScreenState extends State<PaymentDefoultScreen> {
  TextEditingController cardnumbervalueController =
      MaskedTextController(mask: '0000 0000 0000 0000');

  TextEditingController dateValueController =
      MaskedTextController(mask: '00/00');
  bool selectedOption = false;
  TextEditingController cvcValueController = MaskedTextController(mask: '000');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
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
                title: AppbarTitle(text: 'Оплата'),
                styleType: Style.bgFillBlue60001),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 23, top: 84, right: 23),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: double.maxFinite,
                          child: Container(
                              width: getHorizontalSize(329),
                              padding: getPadding(
                                  left: 14, top: 10, right: 14, bottom: 10),
                              decoration: AppDecoration.outlineBlue6001
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder10),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: getPadding(top: 1),
                                        child: Text("Сумма к оплате",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtH1)),
                                    Padding(
                                        padding: getPadding(top: 4),
                                        child: Text(
                                            "Итого с учетом доставки и НДС",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtMontserratSemiBold10Gray50001)),
                                    Padding(
                                        padding: getPadding(top: 3),
                                        child: Text(widget.summa.toString(),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtMontserratBold20Blue600))
                                  ]))),
                      SizedBox(
                          width: double.maxFinite,
                          child: Container(
                              margin: getMargin(top: 18),
                              padding: getPadding(
                                  left: 10, top: 9, right: 10, bottom: 9),
                              decoration: AppDecoration.outlineBlack9003f5
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder10),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                        svgPath: ImageConstant.imgFrame7719,
                                        height: getVerticalSize(34),
                                        width: getHorizontalSize(126),
                                        alignment: Alignment.centerRight,
                                        margin: getMargin(right: 2)),
                                    Padding(
                                        padding: getPadding(top: 1),
                                        child: Text("Номер карты",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtMontserratMedium12Gray50001)),
                                    CustomTextFormField(
                                        controller: cardnumbervalueController,
                                        hintText: "4321 1234 3445 8000 ",
                                        margin: getMargin(top: 3),
                                        padding:
                                            TextFormFieldPadding.PaddingAll12,
                                        fontStyle: TextFormFieldFontStyle
                                            .MontserratMedium15Gray50001,
                                        textInputAction: TextInputAction.done),
                                    Padding(
                                        padding: getPadding(
                                            top: 20, right: 20, bottom: 17),
                                        child: Row(children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text("Срок действия",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtMontserratMedium12Gray50001),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4,
                                                  child: CustomTextFormField(
                                                      controller:
                                                          dateValueController,
                                                      hintText: "MM/ГГ ",
                                                      margin: getMargin(top: 3),
                                                      padding:
                                                          TextFormFieldPadding
                                                              .PaddingAll12,
                                                      fontStyle:
                                                          TextFormFieldFontStyle
                                                              .MontserratMedium15Gray50001,
                                                      textInputAction:
                                                          TextInputAction.done),
                                                )
                                              ]),
                                          Padding(
                                              padding: getPadding(left: 9),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text("CW/CVC",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: ColorConstant
                                                              .gray50001,
                                                          fontSize: getFontSize(
                                                            12,
                                                          ),
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              4,
                                                      child: CustomTextFormField(
                                                          controller:
                                                              cvcValueController,
                                                          hintText: "• • • ",
                                                          margin:
                                                              getMargin(top: 3),
                                                          padding:
                                                              TextFormFieldPadding
                                                                  .PaddingAll12,
                                                          fontStyle:
                                                              TextFormFieldFontStyle
                                                                  .MontserratMedium15Gray50001,
                                                          textInputAction:
                                                              TextInputAction
                                                                  .done),
                                                    )
                                                  ])),
                                          Container(
                                              width: getHorizontalSize(71),
                                              margin: getMargin(
                                                  left: 9, top: 22, bottom: 1),
                                              child: Text(
                                                  "Три цифры с обратной стороны карты",
                                                  maxLines: null,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtMontserratMedium10Gray50001))
                                        ]))
                                  ]))),
                      Padding(
                          padding: getPadding(top: 18, right: 5),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          _isSave = !_isSave;
                                          setState(() {});
                                        },
                                        child: Container(
                                          margin: getMargin(
                                            right: 5,
                                          ),
                                          padding: getPadding(
                                            all: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadiusStyle
                                                .roundedBorder10,
                                            color: ColorConstant.whiteA700,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: getHorizontalSize(
                                                1,
                                              ),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: getSize(
                                                  8,
                                                ),
                                                width: getSize(
                                                  8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: _isSave
                                                      ? Colors.grey
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    getHorizontalSize(
                                                      7,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))),
                                Container(
                                    height: getVerticalSize(35),
                                    width: getHorizontalSize(248),
                                    margin: getMargin(left: 7),
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                50,
                                        child: RichText(
                                          text: TextSpan(
                                            style:
                                                AppStyle.txtMontserratMedium12,
                                            children: const [
                                              TextSpan(
                                                  text:
                                                      'Сохранить данные карты для следующих плтежей. Это безопасно'),
                                              WidgetSpan(
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2.0),
                                                    child: Icon(
                                                      Icons.info,
                                                      color: Colors.grey,
                                                      size: 14,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )))
                              ])),
                      CustomButton(
                          onTap: () async {
                            if ((cardnumbervalueController.text ==
                                    "1111 1111 1111 1111") &
                                (dateValueController.text == "11/11") &
                                (cvcValueController.text == "111")) {
                              if (AfterPay.whereCall == "Смайлик") {
                                try {
                                  if (widget.type == 'med') {
                                    final response = await Api.bookAppointment(
                                        appointmentTime:
                                            widget.appointmentTime ??
                                                DateTime.parse(
                                                    "2025-07-19T12:29:45.571Z"),
                                        serviceId: widget.id,
                                        cardId: widget.cardId ?? '',
                                        problem: 'test');
                                    if (response) {
                                      ElegantNotification.success(
                                        description:
                                            Text('Запись создана успешно'),
                                      ).show(context);
                                      await Future.delayed(
                                          const Duration(seconds: 3));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentListPage(
                                                  finalPage: true,
                                                  type: widget.type),
                                        ),
                                      );
                                    }
                                  } else {
                                    final response =
                                        await Api.createStatementPol(
                                      reason: "Тестовая причина",
                                      serviceId: widget.id,
                                      cardId: widget.cardId ?? '',
                                      description: widget.problem ??
                                          'Описание отсутствует',
                                      // paymentFile: File('/path/to/file'), // если есть
                                      // attachments: [File('/path/to/another.png')],
                                    );

                                    if (response) {
                                      ElegantNotification.success(
                                        description: const Text(
                                            'Заявление успешно создано'),
                                        title: const Text('Готово!'),
                                      ).show(context);

                                      await Future.delayed(
                                          const Duration(seconds: 3));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentListPage(
                                                  finalPage: true,
                                                  type: widget.type),
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  print("Error booking appointment: $e");
                                }
                              } else if (AfterPay.whereCall == "Минуты") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CallWaitingWindowScreen(
                                              id: widget.id,
                                            )));
                              }
                            } else if ((cardnumbervalueController.text.length ==
                                    19) &
                                (dateValueController.text.length == 5) &
                                (cvcValueController.text.length == 3)) {
                              Navigator.pushNamed(
                                  context, AppRouter.paymentFailedScreen);
                            }
                          },
                          height: getVerticalSize(56),
                          text: "Оплатить ",
                          margin: getMargin(top: 18, bottom: 5),
                          variant: ((cardnumbervalueController
                                          .toString()
                                          .length ==
                                      220) &
                                  (dateValueController.toString().length ==
                                      205) &
                                  (cvcValueController.toString().length == 203))
                              ? ButtonVariant.OutlineBlue70049
                              : ButtonVariant.FillGray50001,
                          fontStyle:
                              ButtonFontStyle.MontserratRomanSemiBold18Gray300)
                    ]))));
  }

  onTapArrowleft48(BuildContext context) {
    Navigator.pop(context);
  }
}
