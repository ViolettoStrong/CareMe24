import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.shape,
      this.padding,
      this.variant,
      this.fontStyle,
      this.alignment,
      this.margin,
      this.onTap,
      this.width,
      this.height,
      this.text,
      this.prefixWidget,
      this.suffixWidget});

  final ButtonShape? shape;

  final ButtonPadding? padding;

  final ButtonVariant? variant;

  final ButtonFontStyle? fontStyle;

  final Alignment? alignment;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  final double? width;

  final double? height;

  final String? text;

  final Widget? prefixWidget;

  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment!,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  _buildButtonWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: TextButton(
        onPressed: onTap,
        style: _buildTextButtonStyle(),
        child: _buildButtonChildWidget(),
      ),
    );
  }

  _buildButtonChildWidget() {
    if (checkGradient()) {
      return Container(
        width: width ?? double.maxFinite,
        padding: _setPadding(),
        decoration: _buildDecoration(),
        child: _buildButtonWithOrWithoutIcon(),
      );
    } else {
      return _buildButtonWithOrWithoutIcon();
    }
  }

  _buildButtonWithOrWithoutIcon() {
    if (prefixWidget != null || suffixWidget != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          prefixWidget ?? const SizedBox(),
          Text(
            text ?? "",
            textAlign: TextAlign.center,
            style: _setFontStyle(),
          ),
          suffixWidget ?? const SizedBox(),
        ],
      );
    } else {
      return Text(
        text ?? "",
        textAlign: TextAlign.center,
        style: _setFontStyle(),
      );
    }
  }

  _buildDecoration() {
    return BoxDecoration(
      border: _setBorder(),
      borderRadius: _setBorderRadius(),
      gradient: _setGradient(),
      boxShadow: _setBoxShadow(),
    );
  }

  _buildTextButtonStyle() {
    if (checkGradient()) {
      return TextButton.styleFrom(
        padding: EdgeInsets.zero,
      );
    } else {
      return TextButton.styleFrom(
        fixedSize: Size(
          width ?? double.maxFinite,
          height ?? getVerticalSize(40),
        ),
        padding: _setPadding(),
        backgroundColor: _setColor(),
        side: _setTextButtonBorder(),
        shadowColor: _setTextButtonShadowColor(),
        shape: RoundedRectangleBorder(
          borderRadius: _setBorderRadius(),
        ),
      );
    }
  }

  _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingT29:
        return getPadding(
          left: 20,
          top: 29,
          right: 20,
          bottom: 29,
        );
      case ButtonPadding.PaddingAll25:
        return getPadding(
          all: 25,
        );
      case ButtonPadding.PaddingT28:
        return getPadding(
          left: 20,
          top: 28,
          bottom: 28,
        );
      case ButtonPadding.PaddingT11:
        return getPadding(
          top: 11,
          right: 11,
          bottom: 11,
        );
      case ButtonPadding.PaddingAll9:
        return getPadding(
          all: 9,
        );
      case ButtonPadding.PaddingT17:
        return getPadding(
          left: 16,
          top: 17,
          bottom: 17,
        );
      case ButtonPadding.PaddingT19:
        return getPadding(
          top: 19,
          right: 19,
          bottom: 19,
        );
      case ButtonPadding.PaddingT1:
        return getPadding(
          top: 1,
          bottom: 1,
        );
      case ButtonPadding.PaddingAll6:
        return getPadding(
          all: 6,
        );
      case ButtonPadding.PaddingAll12:
        return getPadding(
          all: 12,
        );
      case ButtonPadding.PaddingT37:
        return getPadding(
          top: 37,
          right: 16,
          bottom: 37,
        );
      case ButtonPadding.PaddingT6:
        return getPadding(
          left: 6,
          top: 6,
          bottom: 6,
        );
      default:
        return getPadding(
          all: 17,
        );
    }
  }

  _setColor() {
    switch (variant) {
      case ButtonVariant.OutlineGray300:
        return ColorConstant.whiteA700;
      case ButtonVariant.FillBlue100:
        return ColorConstant.blue100;
      case ButtonVariant.OutlineGray300_1:
        return ColorConstant.whiteA700;
      case ButtonVariant.FillGray50001:
        return ColorConstant.gray50001;
      case ButtonVariant.FillBlue60001:
        return ColorConstant.blue60001;
      case ButtonVariant.OutlineGray50001_1:
        return ColorConstant.whiteA700;
      case ButtonVariant.OutlineBlue600:
        return ColorConstant.whiteA700;
      case ButtonVariant.OutlineGray300_2:
        return ColorConstant.orange50;
      case ButtonVariant.FillBlue600:
        return ColorConstant.blue600;
      case ButtonVariant.FillBlueA200:
        return ColorConstant.blueA200;
      case ButtonVariant.FillGreen40001:
        return ColorConstant.green40001;
      case ButtonVariant.FillBluegray800:
        return ColorConstant.blueGray800;
      case ButtonVariant.FillRed90001:
        return ColorConstant.red90001;
      case ButtonVariant.FillBluegray10001:
        return ColorConstant.blueGray10001;
      case ButtonVariant.FillYellowA40001:
        return ColorConstant.yellowA40001;
      case ButtonVariant.FillLightgreen500:
        return ColorConstant.lightGreen500;
      case ButtonVariant.FillBlue60002:
        return ColorConstant.blue60002;
      case ButtonVariant.FillCyanA400:
        return ColorConstant.cyanA400;
      case ButtonVariant.FillPink50001:
        return ColorConstant.pink50001;
      case ButtonVariant.OutlineBlack9003f:
        return ColorConstant.whiteA700;
      case ButtonVariant.FillWhiteA700:
        return ColorConstant.whiteA700;
      case ButtonVariant.OutlineBlue600_1:
        return ColorConstant.whiteA700;
      case ButtonVariant.FillYellowA40002:
        return ColorConstant.yellowA40002;
      case ButtonVariant.Outline_2:
      case ButtonVariant.Dividers:
      case ButtonVariant.OutlineIndigo20049:
      case ButtonVariant.GradientGreenA700GreenA70001:
      case ButtonVariant.GradientGray:
      case ButtonVariant.GradientBlue500LightblueA200:
      case ButtonVariant.GradientBlue60001IndigoA400:
      case ButtonVariant.OutlineGray50001:
      case ButtonVariant.OutlineIndigo20049_1:
      case ButtonVariant.OutlineGray300_3:
      case ButtonVariant.OutlineGray50001_2:
      case ButtonVariant.Outline:
      case ButtonVariant.Outline_1:
      case ButtonVariant.OutlineBlue70049:
        return null;
      default:
        return null;
    }
  }

  _setTextButtonBorder() {
    switch (variant) {
      case ButtonVariant.Dividers:
        return BorderSide(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray300:
        return BorderSide(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray300_1:
        return BorderSide(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant.OutlineGray50001:
        return BorderSide(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray50001_1:
        return BorderSide(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBlue600:
        return BorderSide(
          color: ColorConstant.blue600,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray300_2:
        return BorderSide(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray300_3:
        return BorderSide(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray50001_2:
        return BorderSide(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBlue600_1:
        return BorderSide(
          color: ColorConstant.blue600,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant.OutlineIndigo20049:
      case ButtonVariant.GradientGreenA700GreenA70001:
      case ButtonVariant.GradientGray:
      case ButtonVariant.FillBlue100:
      case ButtonVariant.GradientBlue500LightblueA200:
      case ButtonVariant.FillGray50001:
      case ButtonVariant.FillBlue60001:
      case ButtonVariant.GradientBlue60001IndigoA400:
      case ButtonVariant.OutlineIndigo20049_1:
      case ButtonVariant.FillBlue600:
      case ButtonVariant.FillBlueA200:
      case ButtonVariant.FillGreen40001:
      case ButtonVariant.FillBluegray800:
      case ButtonVariant.OutlineBlue70049:
      case ButtonVariant.FillRed90001:
      case ButtonVariant.FillBluegray10001:
      case ButtonVariant.FillYellowA40001:
      case ButtonVariant.FillLightgreen500:
      case ButtonVariant.FillBlue60002:
      case ButtonVariant.FillCyanA400:
      case ButtonVariant.FillPink50001:
      case ButtonVariant.OutlineBlack9003f:
      case ButtonVariant.FillWhiteA700:
      case ButtonVariant.FillYellowA40002:
        return null;
      default:
        return null;
    }
  }

  _setTextButtonShadowColor() {
    switch (variant) {
      case ButtonVariant.OutlineIndigo20049:
        return ColorConstant.indigo20049;
      case ButtonVariant.OutlineIndigo20049_1:
        return ColorConstant.indigo20049;
      case ButtonVariant.OutlineGray50001_2:
        return ColorConstant.indigo20049;
      case ButtonVariant.Outline_1:
        return ColorConstant.indigo20049;
      case ButtonVariant.OutlineBlue70049:
        return ColorConstant.blue70049;
      case ButtonVariant.OutlineBlack9003f:
        return ColorConstant.black9003f;
      case ButtonVariant.OutlineBlue600_1:
        return ColorConstant.blue70049;
      case ButtonVariant.Dividers:
      case ButtonVariant.GradientGreenA700GreenA70001:
      case ButtonVariant.GradientGray:
      case ButtonVariant.OutlineGray300:
      case ButtonVariant.FillBlue100:
      case ButtonVariant.OutlineGray300_1:
      case ButtonVariant.GradientBlue500LightblueA200:
      case ButtonVariant.FillGray50001:
      case ButtonVariant.FillBlue60001:
      case ButtonVariant.GradientBlue60001IndigoA400:
      case ButtonVariant.OutlineGray50001:
      case ButtonVariant.OutlineGray50001_1:
      case ButtonVariant.OutlineBlue600:
      case ButtonVariant.OutlineGray300_2:
      case ButtonVariant.FillBlue600:
      case ButtonVariant.FillBlueA200:
      case ButtonVariant.FillGreen40001:
      case ButtonVariant.FillBluegray800:
      case ButtonVariant.OutlineGray300_3:
      case ButtonVariant.Outline:
      case ButtonVariant.FillRed90001:
      case ButtonVariant.FillBluegray10001:
      case ButtonVariant.FillYellowA40001:
      case ButtonVariant.FillLightgreen500:
      case ButtonVariant.FillBlue60002:
      case ButtonVariant.FillCyanA400:
      case ButtonVariant.FillPink50001:
      case ButtonVariant.FillWhiteA700:
      case ButtonVariant.FillYellowA40002:
        return null;
      default:
        return ColorConstant.indigo20049;
    }
  }

  _setBorderRadius() {
    switch (shape) {
      case ButtonShape.CustomBorderTL10:
        return BorderRadius.only(
          topLeft: Radius.circular(
            getHorizontalSize(
              10.00,
            ),
          ),
          topRight: Radius.circular(
            getHorizontalSize(
              10.00,
            ),
          ),
          bottomLeft: Radius.circular(
            getHorizontalSize(
              0.00,
            ),
          ),
          bottomRight: Radius.circular(
            getHorizontalSize(
              0.00,
            ),
          ),
        );
      case ButtonShape.RoundedBorder7:
        return BorderRadius.circular(
          getHorizontalSize(
            7.00,
          ),
        );
      case ButtonShape.RoundedBorder15:
        return BorderRadius.circular(
          getHorizontalSize(
            15.00,
          ),
        );
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            10.00,
          ),
        );
    }
  }

  _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.MontserratSemiBold20:
        return TextStyle(
          color: ColorConstant.blue600,
          fontSize: getFontSize(
            20,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRomanSemiBold18:
        return TextStyle(
          color: ColorConstant.gray50,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratSemiBold18:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratMedium17:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            17,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratSemiBold18Bluegray800:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratSemiBold19:
        return TextStyle(
          color: ColorConstant.lightBlue900,
          fontSize: getFontSize(
            19,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratBold20:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            20,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
        );
      case ButtonFontStyle.MontserratSemiBold12:
        return TextStyle(
          color: ColorConstant.gray300,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratSemiBold12WhiteA700:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratMedium18:
        return TextStyle(
          color: ColorConstant.gray50001,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratMedium18Bluegray800:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratRomanSemiBold18Gray300:
        return TextStyle(
          color: ColorConstant.gray300,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRomanSemiBold18White:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratMedium15:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratRomanSemiBold16:
        return TextStyle(
          color: ColorConstant.gray50,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRegular14:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.MontserratRomanSemiBold15:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRomanSemiBold15Blue:
        return TextStyle(
          color: ColorConstant.blue600,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRomanSemiBold15Gray50001:
        return TextStyle(
          color: ColorConstant.gray50001,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRomanSemiBold12:
        return TextStyle(
          color: ColorConstant.gray50001,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratMedium15Gray50001:
        return TextStyle(
          color: ColorConstant.gray50001,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratRomanSemiBold16Gray300:
        return TextStyle(
          color: ColorConstant.gray300,
          fontSize: getFontSize(
            16,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRomanSemiBold15Gray50:
        return TextStyle(
          color: ColorConstant.gray50,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRomanMedium18:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratSemiBold15:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case ButtonFontStyle.MontserratRomanMedium18Lime900:
        return TextStyle(
          color: ColorConstant.lime900,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratRomanMedium18Green800:
        return TextStyle(
          color: ColorConstant.green800,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratMedium18WhiteA700:
        return TextStyle(
          color: ColorConstant.whiteA700,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratMedium18Cyan800:
        return TextStyle(
          color: ColorConstant.cyan800,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratRomanMedium14:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratMedium18Green900:
        return TextStyle(
          color: ColorConstant.green900,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratMedium12:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratRomanMedium18Green900:
        return TextStyle(
          color: ColorConstant.green900,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.MontserratMedium18Lime900:
        return TextStyle(
          color: ColorConstant.lime900,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      default:
        return TextStyle(
          color: ColorConstant.blue600,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
    }
  }

  _setBorder() {
    switch (variant) {
      case ButtonVariant.Dividers:
        return Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray300:
        return Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray300_1:
        return Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant.OutlineGray50001:
        return Border.all(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray50001_1:
        return Border.all(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBlue600:
        return Border.all(
          color: ColorConstant.blue600,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray300_2:
        return Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray300_3:
        return Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineGray50001_2:
        return Border.all(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            1.00,
          ),
        );
      case ButtonVariant.OutlineBlue600_1:
        return Border.all(
          color: ColorConstant.blue600,
          width: getHorizontalSize(
            2.00,
          ),
        );
      case ButtonVariant.OutlineIndigo20049:
      case ButtonVariant.GradientGreenA700GreenA70001:
      case ButtonVariant.GradientGray:
      case ButtonVariant.FillBlue100:
      case ButtonVariant.GradientBlue500LightblueA200:
      case ButtonVariant.FillGray50001:
      case ButtonVariant.FillBlue60001:
      case ButtonVariant.GradientBlue60001IndigoA400:
      case ButtonVariant.OutlineIndigo20049_1:
      case ButtonVariant.FillBlue600:
      case ButtonVariant.FillBlueA200:
      case ButtonVariant.FillGreen40001:
      case ButtonVariant.FillBluegray800:
      case ButtonVariant.OutlineBlue70049:
      case ButtonVariant.FillRed90001:
      case ButtonVariant.FillBluegray10001:
      case ButtonVariant.FillYellowA40001:
      case ButtonVariant.FillLightgreen500:
      case ButtonVariant.FillBlue60002:
      case ButtonVariant.FillCyanA400:
      case ButtonVariant.FillPink50001:
      case ButtonVariant.OutlineBlack9003f:
      case ButtonVariant.FillWhiteA700:
      case ButtonVariant.FillYellowA40002:
        return null;
      default:
        return null;
    }
  }

  checkGradient() {
    switch (variant) {
      case ButtonVariant.OutlineIndigo20049:
      case ButtonVariant.GradientGreenA700GreenA70001:
      case ButtonVariant.GradientGray:
      case ButtonVariant.GradientBlue500LightblueA200:
      case ButtonVariant.GradientBlue60001IndigoA400:
      case ButtonVariant.OutlineIndigo20049_1:
      case ButtonVariant.OutlineBlue70049:
        return true;
      default:
        return false;
    }
  }

  _setGradient() {
    switch (variant) {
      case ButtonVariant.OutlineIndigo20049:
        return LinearGradient(
          begin: const Alignment(
            1.04,
            1,
          ),
          end: const Alignment(
            -0.03,
            0,
          ),
          colors: [
            ColorConstant.amberA700,
            ColorConstant.amber300,
          ],
        );
      case ButtonVariant.GradientGreenA700GreenA70001:
        return LinearGradient(
          begin: const Alignment(
            1,
            1,
          ),
          end: const Alignment(
            0.22,
            0,
          ),
          colors: [
            ColorConstant.greenA700,
            ColorConstant.greenA70001,
          ],
        );
      case ButtonVariant.GradientBlue500LightblueA200:
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
      case ButtonVariant.GradientGray:
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
            ColorConstant.gray40001,
            ColorConstant.gray400,
          ],
        );
      case ButtonVariant.GradientBlue60001IndigoA400:
        return LinearGradient(
          begin: const Alignment(
            1.05,
            0.11,
          ),
          end: const Alignment(
            -0.02,
            0.83,
          ),
          colors: [
            ColorConstant.blue60001,
            ColorConstant.indigoA400,
          ],
        );
      case ButtonVariant.OutlineIndigo20049_1:
        return LinearGradient(
          begin: const Alignment(
            1.05,
            0.11,
          ),
          end: const Alignment(
            -0.02,
            0.83,
          ),
          colors: [
            ColorConstant.blue60001,
            ColorConstant.indigoA400,
          ],
        );
      case ButtonVariant.OutlineBlue70049:
        return LinearGradient(
          begin: const Alignment(
            1.05,
            0.11,
          ),
          end: const Alignment(
            -0.02,
            0.83,
          ),
          colors: [
            ColorConstant.blue60001,
            ColorConstant.indigoA400,
          ],
        );
      case ButtonVariant.Outline_2:
      case ButtonVariant.Dividers:
      case ButtonVariant.OutlineGray300:
      case ButtonVariant.FillBlue100:
      case ButtonVariant.OutlineGray300_1:
      case ButtonVariant.FillGray50001:
      case ButtonVariant.FillBlue60001:
      case ButtonVariant.OutlineGray50001:
      case ButtonVariant.OutlineGray50001_1:
      case ButtonVariant.OutlineBlue600:
      case ButtonVariant.OutlineGray300_2:
      case ButtonVariant.FillBlue600:
      case ButtonVariant.FillBlueA200:
      case ButtonVariant.FillGreen40001:
      case ButtonVariant.FillBluegray800:
      case ButtonVariant.OutlineGray300_3:
      case ButtonVariant.OutlineGray50001_2:
      case ButtonVariant.Outline:
      case ButtonVariant.Outline_1:
      case ButtonVariant.FillRed90001:
      case ButtonVariant.FillBluegray10001:
      case ButtonVariant.FillYellowA40001:
      case ButtonVariant.FillLightgreen500:
      case ButtonVariant.FillBlue60002:
      case ButtonVariant.FillCyanA400:
      case ButtonVariant.FillPink50001:
      case ButtonVariant.OutlineBlack9003f:
      case ButtonVariant.FillWhiteA700:
      case ButtonVariant.OutlineBlue600_1:
      case ButtonVariant.FillYellowA40002:
        return null;
      default:
        return null;
    }
  }

  _setBoxShadow() {
    switch (variant) {
      case ButtonVariant.OutlineIndigo20049:
        return [
          BoxShadow(
            color: ColorConstant.indigo20049,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ];
      case ButtonVariant.OutlineIndigo20049_1:
        return [
          BoxShadow(
            color: ColorConstant.indigo20049,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ];
      case ButtonVariant.OutlineGray50001_2:
        return [
          BoxShadow(
            color: ColorConstant.indigo20049,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ];
      case ButtonVariant.Outline_1:
        return [
          BoxShadow(
            color: ColorConstant.indigo20049,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ];
      case ButtonVariant.OutlineBlue70049:
        return [
          BoxShadow(
            color: ColorConstant.blue70049,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              3,
            ),
          ),
        ];
      case ButtonVariant.OutlineBlack9003f:
        return [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ];
      case ButtonVariant.OutlineBlue600_1:
        return [
          BoxShadow(
            color: ColorConstant.blue70049,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              3,
            ),
          ),
        ];
      case ButtonVariant.Dividers:
      case ButtonVariant.GradientGreenA700GreenA70001:
      case ButtonVariant.OutlineGray300:
      case ButtonVariant.FillBlue100:
      case ButtonVariant.OutlineGray300_1:
      case ButtonVariant.GradientBlue500LightblueA200:
      case ButtonVariant.GradientGray:
      case ButtonVariant.FillGray50001:
      case ButtonVariant.FillBlue60001:
      case ButtonVariant.GradientBlue60001IndigoA400:
      case ButtonVariant.OutlineGray50001:
      case ButtonVariant.OutlineGray50001_1:
      case ButtonVariant.OutlineBlue600:
      case ButtonVariant.OutlineGray300_2:
      case ButtonVariant.FillBlue600:
      case ButtonVariant.FillBlueA200:
      case ButtonVariant.FillGreen40001:
      case ButtonVariant.FillBluegray800:
      case ButtonVariant.OutlineGray300_3:
      case ButtonVariant.Outline:
      case ButtonVariant.FillRed90001:
      case ButtonVariant.FillBluegray10001:
      case ButtonVariant.FillYellowA40001:
      case ButtonVariant.FillLightgreen500:
      case ButtonVariant.FillBlue60002:
      case ButtonVariant.FillCyanA400:
      case ButtonVariant.FillPink50001:
      case ButtonVariant.FillWhiteA700:
      case ButtonVariant.FillYellowA40002:
        return null;
      default:
        return [
          BoxShadow(
            color: ColorConstant.indigo20049,
            spreadRadius: getHorizontalSize(
              2.00,
            ),
            blurRadius: getHorizontalSize(
              2.00,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ];
    }
  }
}

enum ButtonShape {
  Square,
  RoundedBorder10,
  CustomBorderTL10,
  RoundedBorder7,
  RoundedBorder15,
  CustomBorderBR30,
}

enum ButtonPadding {
  PaddingAll17,
  PaddingT29,
  PaddingAll25,
  PaddingT28,
  PaddingT11,
  PaddingAll9,
  PaddingT17,
  PaddingT19,
  PaddingT1,
  PaddingAll6,
  PaddingAll12,
  PaddingT37,
  PaddingT6,
  PaddingT31,
}

enum ButtonVariant {
  Outline_2,
  Dividers,
  OutlineIndigo20049,
  GradientGreenA700GreenA70001,
  OutlineGray300,
  FillBlue100,
  OutlineGray300_1,
  GradientBlue500LightblueA200,
  FillGray50001,
  FillBlue60001,
  GradientBlue60001IndigoA400,
  OutlineGray50001,
  OutlineGray50001_1,
  OutlineIndigo20049_1,
  OutlineBlue600,
  OutlineGray300_2,
  FillBlue600,
  FillBlueA200,
  FillGreen40001,
  FillBluegray800,
  OutlineGray300_3,
  OutlineGray50001_2,
  Outline,
  Outline_1,
  OutlineBlue70049,
  FillRed90001,
  FillBluegray10001,
  FillYellowA40001,
  FillLightgreen500,
  FillBlue60002,
  FillCyanA400,
  FillPink50001,
  OutlineBlack9003f,
  FillWhiteA700,
  OutlineBlue600_1,
  FillYellowA40002,
  OutlineGray9003d,
  GradientGray,
}

enum ButtonFontStyle {
  MontserratRomanSemiBold18Blue600,
  MontserratSemiBold20,
  MontserratRomanSemiBold18,
  MontserratSemiBold18,
  MontserratMedium17,
  MontserratSemiBold18Bluegray800,
  MontserratSemiBold19,
  MontserratBold20,
  MontserratSemiBold12,
  MontserratSemiBold12WhiteA700,
  MontserratMedium18,
  MontserratMedium18Bluegray800,
  MontserratRomanSemiBold18Gray300,
  MontserratMedium15,
  MontserratRomanSemiBold16,
  MontserratRegular14,
  MontserratRomanSemiBold15,
  MontserratRomanSemiBold15Blue,
  MontserratRomanSemiBold15Gray50001,
  MontserratRomanSemiBold18White,
  MontserratRomanSemiBold12,
  MontserratMedium15Gray50001,
  MontserratRomanSemiBold16Gray300,
  MontserratRomanSemiBold15Gray50,
  MontserratRomanMedium18,
  MontserratSemiBold15,
  MontserratRomanMedium18Lime900,
  MontserratRomanMedium18Green800,
  MontserratMedium18WhiteA700,
  MontserratMedium18Cyan800,
  MontserratRomanMedium14,
  MontserratMedium18Green900,
  MontserratMedium12,
  MontserratRomanMedium18Green900,
  MontserratMedium18Lime900,
}
