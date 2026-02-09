import 'package:careme24/theme/color_constant.dart';
import 'package:flutter/material.dart';
import '../theme/app_style.dart';
import '../utils/size_utils.dart';

class ReasonMES extends StatefulWidget {
  String text;
  late bool disable;
  Color backgroundColor;

  ReasonMES(
      {super.key,
      required this.text,
      required this.disable,
      required this.backgroundColor,
      required this.onTap});

  final Function()? onTap;

  @override
  State<ReasonMES> createState() => _ReasonMESState();
}

class _ReasonMESState extends State<ReasonMES> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: widget.onTap,
          child: Container(
            height: 80,
            color: (widget.disable == true)
                ? ColorConstant.gray200
                : widget.backgroundColor,
            child: Padding(
              padding: getPadding(left: 19),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.text,
                  style: (widget.disable == true)
                      ? AppStyle.txtMontserratMedium17Bluegray300
                      : AppStyle.txtMontserratMedium17,
                ),
              ),
            ),
          )),
    );
  }
}
