import 'dart:async';
import 'package:careme24/pages/calls/medic_call_page.dart';
import 'package:careme24/pages/calls/police_call_page.dart';
import 'package:careme24/pages/calls/rescue_call_page.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HelpScreenTouch extends StatefulWidget {
  final String type;
  const HelpScreenTouch({super.key, required this.type});

  @override
  State<HelpScreenTouch> createState() => _HelpScreenTouchState();
}

class _HelpScreenTouchState extends State<HelpScreenTouch> {
  @override
  void initState() {
    super.initState();

    /// 4 վայրկյան հետո ավտոմատ բացում է համապատասխան էջը
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => widget.type == 'med'
              ? MedicCallPage()
              : widget.type == 'pol'
                  ? PoliceCallPage()
                  : RescueCallPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background full-screen SVG
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SvgPicture.asset(
                widget.type == 'med'
                    ? ImageConstant.imgHelpScreen
                    : widget.type == 'pol'
                        ? ImageConstant.imgPoliceScreen
                        : ImageConstant.imgMCHSScreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
