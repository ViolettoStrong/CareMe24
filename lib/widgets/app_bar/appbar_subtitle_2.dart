import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:flutter/material.dart';

class AppbarSubtitle2 extends StatelessWidget {
  const AppbarSubtitle2({
    super.key,
    required this.text,
    this.margin,
    this.onTap,
  });

  final String text;
  final EdgeInsetsGeometry? margin;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onTap?.call();
          },
          child: Padding(
            padding: margin ?? EdgeInsets.zero,
            child: SizedBox(
              width: 70,
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtMontserratSemiBold12WhiteA700.copyWith(
                  color: ColorConstant.whiteA700,
                ),
              ),
            ),
          )),
    );
  }
}
