import 'package:careme24/pages/med/reason_selfhelp.dart';
import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../theme/app_style.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class ListSymptomsScreen extends StatelessWidget {
  late Function callback;
  ListSymptomsScreen({super.key, required this.callback});
  TextEditingController frame7299Controller = TextEditingController();
  final List<String> reasonText = <String>[
    '3.12. Гипертонический криз',
    "3.13. Травма, перелом",
    "3.12. Гипертонический криз",
    "3.18. Термические или химические ожоги",
    "3.29. Переохлаждение",
    "3.11. Сотрясение мозга",
    "3.28. Тепловой удар",
    "C5",
    "C6",
    "C7",
    "C8"
  ];

  final List<bool> reasonDisable = <bool>[
    false,
    false,
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
                height: getVerticalSize(48),
                leadingWidth: 40,
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
                title: AppbarTitle(text: "Самопомощь"),
                actions: [
                  Padding(
                      padding: getPadding(right: 15),
                      child: const Icon(Icons.settings))
                ],
                styleType: Style.bgFillBlue60001),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 23, top: 12, right: 23, bottom: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          width: getHorizontalSize(218),
                          margin: getMargin(top: 4),
                          child: Text("Выбирете то что вас беспокоит",
                              maxLines: null,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtMontserratSemiBold20)),
                      Container(
                          width: getHorizontalSize(264),
                          margin: getMargin(top: 12, right: 64, bottom: 24),
                          child: Text(
                              "Для полного списка активируйте платную услугу",
                              maxLines: null,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtMontserratMedium15Blue600)),
                      Expanded(
                          child: ListView.separated(
                        itemCount: reasonText.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  callback(reasonText[index]);
                                  Navigator.pop(context);
                                },
                                child: ReasonSelfHelp(
                                  text: reasonText[index],
                                  disable: reasonDisable[index],
                                  backgroundColor: Colors.white,
                                )),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(indent: 0, height: 1),
                      ))
                    ]))));
  }

  onTapArrowleft46(BuildContext context) {
    Navigator.pop(context);
  }
}
