import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/who_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/app_bar/appbar_image.dart';
import '../widgets/app_bar/appbar_title.dart';
import '../widgets/app_bar/custom_app_bar.dart';

class WhomPage extends StatefulWidget {
  final Function callback;

  const WhomPage({super.key, required this.callback});

  @override
  State<WhomPage> createState() => _WhomPageState();
}

class _WhomPageState extends State<WhomPage> {
  List<String> nameperson = <String>[
    "Степанов Илья",
    "Степанов Илья",
    "Мне",
    "Другому",
  ];
  List<String> age = [
    "42 года",
    "10 лет",
    "",
    "",
  ];

  @override
  Widget build(BuildContext context) {
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
          title: AppbarTitle(text: "Кому"),
          styleType: Style.bgFillBlue60001),
      body: Container(
        padding: getPadding(top: 14),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 50,
        child: Padding(
          padding: getPadding(left: 20, right: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                child: ListView.separated(
              itemCount: nameperson.length,
              itemBuilder: (BuildContext context, int index) {
                return WhoWidget(
                  callback: widget.callback,
                  name: nameperson[index],
                  age: age[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                indent: 0,
                height: 10,
                thickness: 2,
              ),
            ))
          ]),
        ),
      ),
    ));
  }
}
