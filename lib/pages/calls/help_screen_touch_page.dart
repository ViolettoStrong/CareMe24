import 'dart:async';
import 'package:careme24/pages/calls/medical_call_button.dart';
import 'package:careme24/pages/calls/police_call_button.dart';
import 'package:careme24/pages/calls/rescue_call_button.dart';
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

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scaffold(
            body: widget.type == 'med'
                ? MedicalCallButton(text: '', selectedContact: null)
                : widget.type == 'pol'
                    ? PoliceCallButton(text: '', selectedContact: null)
                    : RescueCallButton(text: '', selectedContact: null),
          ),
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
