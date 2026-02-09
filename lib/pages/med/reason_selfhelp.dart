import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';

class ReasonSelfHelp extends StatefulWidget {
  final String text;
  final bool disable;
  final Color backgroundColor;

  const ReasonSelfHelp({
    super.key,
    required this.text,
    required this.disable,
    required this.backgroundColor,
  });

  @override
  State<ReasonSelfHelp> createState() => _ReasonSelfHelpState();
}

class _ReasonSelfHelpState extends State<ReasonSelfHelp> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
