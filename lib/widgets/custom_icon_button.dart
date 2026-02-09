import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.alignment,
      this.margin,
      this.width,
      this.height,
      this.child,
      this.onTap});

  final IconButtonShape? shape;

  final IconButtonPadding? padding;

  final IconButtonVariant? variant;

  final Alignment? alignment;

  final EdgeInsetsGeometry? margin;

  final double? width;

  final double? height;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildIconButtonWidget(),
          )
        : _buildIconButtonWidget();
  }

  _buildIconButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: IconButton(
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
        iconSize: getSize(height ?? 0),
        padding: const EdgeInsets.all(0),
        icon: Container(
          alignment: Alignment.center,
          width: getSize(width ?? 0),
          height: getSize(height ?? 0),
          padding: _setPadding(),
          decoration: _buildDecoration(),
          child: child,
        ),
        onPressed: onTap,
      ),
    );
  }

  _buildDecoration() {
    return BoxDecoration(
      color: _setColor(),
      borderRadius: _setBorderRadius(),
      gradient: _setGradient(),
    );
  }

  _setPadding() {
    switch (padding) {
      case IconButtonPadding.PaddingAll15:
        return getPadding(
          all: 15,
        );
      case IconButtonPadding.PaddingAll6:
        return getPadding(
          all: 6,
        );
      case IconButtonPadding.PaddingAll3:
        return getPadding(
          all: 3,
        );
      default:
        return getPadding(
          all: 10,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case IconButtonVariant.FillPink300:
        return ColorConstant.pink300;
      case IconButtonVariant.FillIndigoA100:
        return ColorConstant.indigoA100;
      case IconButtonVariant.FillYellow700:
        return ColorConstant.yellow700;
      case IconButtonVariant.FillBlue30002:
        return ColorConstant.blue30002;
      case IconButtonVariant.FillBluegray900:
        return ColorConstant.blueGray900;
      case IconButtonVariant.FillGray20002:
        return ColorConstant.gray20002;
      case IconButtonVariant.FillWhiteA70019:
        return ColorConstant.whiteA70019;
      case IconButtonVariant.FillGray300:
        return ColorConstant.gray300;
      case IconButtonVariant.FillBluegray800:
        return ColorConstant.blueGray800;
      case IconButtonVariant.FillBlue600:
        return ColorConstant.blue600;
      case IconButtonVariant.GradientBlue500LightblueA200:
        return null;
      case IconButtonVariant.FillRed:
        return ColorConstant.red900;
      default:
        return null;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case IconButtonShape.RoundedBorder7:
        return BorderRadius.circular(
          getHorizontalSize(
            7.00,
          ),
        );
      case IconButtonShape.RoundedBorder21:
        return BorderRadius.circular(
          getHorizontalSize(
            21.00,
          ),
        );
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            29.00,
          ),
        );
    }
  }

  _setGradient() {
    switch (variant) {
      case IconButtonVariant.FillRed:
      case IconButtonVariant.FillPink300:
      case IconButtonVariant.FillIndigoA100:
      case IconButtonVariant.FillYellow700:
      case IconButtonVariant.FillBlue30002:
      case IconButtonVariant.FillBluegray900:
      case IconButtonVariant.FillGray20002:
      case IconButtonVariant.FillWhiteA70019:
      case IconButtonVariant.FillGray300:
      case IconButtonVariant.FillBluegray800:
      case IconButtonVariant.FillBlue600:
        return null;
      default:
        return LinearGradient(
          begin: const Alignment(
            0.97,
            0.94,
          ),
          end: const Alignment(
            0.22,
            0.05,
          ),
          colors: [
            ColorConstant.blue500,
            ColorConstant.lightBlueA200,
          ],
        );
    }
  }
}

enum IconButtonShape {
  CircleBorder29,
  RoundedBorder7,
  RoundedBorder21,
}

enum IconButtonPadding {
  PaddingAll10,
  PaddingAll15,
  PaddingAll6,
  PaddingAll3,
}

enum IconButtonVariant {
  FillRed,
  GradientBlue500LightblueA200,
  FillPink300,
  FillIndigoA100,
  FillYellow700,
  FillBlue30002,
  FillBluegray900,
  FillGray20002,
  FillWhiteA70019,
  FillGray300,
  FillBluegray800,
  FillBlue600,
}
