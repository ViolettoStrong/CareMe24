import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../theme/app_style.dart';

class ReasonPolice extends StatefulWidget {
  String text;
  late bool disable;
  Color backgroundColor;
  final Function()? onTap;

  ReasonPolice({
    super.key,
    required this.text,
    required this.disable,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  State<ReasonPolice> createState() => _ReasonPoliceState();
}

class _ReasonPoliceState extends State<ReasonPolice> {
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
