import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {super.key,
      required this.height,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions});

  double height;

  Style? styleType;

  double? leadingWidth;

  Widget? leading;

  Widget? title;

  bool? centerTitle;

  List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height,
      automaticallyImplyLeading: false,
      backgroundColor: ColorConstant.blue60001,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        size.width,
        height,
      );
  _getStyle() {
    switch (styleType) {
      case Style.bgFillPinkA200:
        return Container(
          height: getVerticalSize(
            48,
          ),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: ColorConstant.pinkA200,
          ),
        );
      case Style.bgFillGreenA70002:
        return Container(
          height: getVerticalSize(
            48,
          ),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: ColorConstant.greenA70002,
          ),
        );
      case Style.bgFillBlue60001:
        return Container(
          height: getVerticalSize(
            48,
          ),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: ColorConstant.blue60001,
          ),
        );
      default:
        return null;
    }
  }
}

enum Style {
  bgFillPinkA200,
  bgFillGreenA70002,
  bgFillBlue60001,
}
