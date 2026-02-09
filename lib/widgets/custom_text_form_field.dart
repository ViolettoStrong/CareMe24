import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.shape,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.isObscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.validator,
    this.onTap,
  });

  final TextFormFieldShape? shape;
  final TextFormFieldPadding? padding;
  final TextFormFieldVariant? variant;
  final TextFormFieldFontStyle? fontStyle;
  final Alignment? alignment;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? isObscureText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final FormFieldValidator<String>? validator;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildTextFormFieldWidget(),
          )
        : _buildTextFormFieldWidget();
  }

  _buildTextFormFieldWidget() {
    return Container(
      width: width ?? double.maxFinite,
      margin: margin,
      child: TextFormField(
        onTap: onTap,
        controller: controller,
        focusNode: focusNode,
        style: _setFontStyle(),
        obscureText: isObscureText!,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        maxLines: maxLines ?? 1,
        decoration: _buildDecoration(),
        validator: validator,
      ),
    );
  }

  _buildDecoration() {
    return InputDecoration(
      hintText: hintText ?? "",
      hintStyle: _setFontStyle(),
      border: _setBorderStyle(),
      enabledBorder: _setBorderStyle(),
      focusedBorder: _setBorderStyle(),
      disabledBorder: _setBorderStyle(),
      prefixIcon: prefix,
      prefixIconConstraints: prefixConstraints,
      suffixIcon: suffix,
      suffixIconConstraints: suffixConstraints,
      fillColor: _setFillColor(),
      filled: _setFilled(),
      isDense: true,
      contentPadding: _setPadding(),
    );
  }

  _setFontStyle() {
    switch (fontStyle) {
      case TextFormFieldFontStyle.MontserratMedium15:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.MontserratSemiBold19:
        return TextStyle(
          color: ColorConstant.lightBlue900,
          fontSize: getFontSize(
            19,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        );
      case TextFormFieldFontStyle.MontserratMedium17:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            17,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.MontserratMedium17Bluegray300:
        return TextStyle(
          color: ColorConstant.blueGray300,
          fontSize: getFontSize(
            17,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.MontserratMedium15Gray50001:
        return TextStyle(
          color: ColorConstant.gray50001,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.MontserratMedium15Black900:
        return TextStyle(
          color: ColorConstant.black900,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.MontserratMedium15Blue600:
        return TextStyle(
          color: ColorConstant.blue600,
          fontSize: getFontSize(
            15,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      case TextFormFieldFontStyle.MontserratRomanMedium14:
        return TextStyle(
          color: ColorConstant.blueGray800,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
      default:
        return TextStyle(
          color: ColorConstant.gray50001,
          fontSize: getFontSize(
            18,
          ),
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
        );
    }
  }

  _setOutlineBorderRadius() {
    switch (shape) {
      case TextFormFieldShape.CustomBorderTL10:
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
      default:
        return BorderRadius.circular(
          getHorizontalSize(
            8.00,
          ),
        );
    }
  }

  _setBorderStyle() {
    switch (variant) {
      case TextFormFieldVariant.OutlineBluegray90047:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.FillBlue100:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.Dividers:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray300,
            width: 1,
          ),
        );
      case TextFormFieldVariant.FillWhiteA700:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.OutlineGray300:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray300,
            width: 2,
          ),
        );
      case TextFormFieldVariant.FillGray200:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.OutlineGray300_1:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray300,
            width: 2,
          ),
        );
      case TextFormFieldVariant.OutlinePink60001:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.pink60001,
            width: 1,
          ),
        );
      case TextFormFieldVariant.UnderLineGray300:
        return UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstant.gray300,
          ),
        );
      case TextFormFieldVariant.OutlineBlue30001:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.blue30001,
            width: 1,
          ),
        );
      case TextFormFieldVariant.OutlineBlack9003f:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide.none,
        );
      case TextFormFieldVariant.None:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderRadius: _setOutlineBorderRadius(),
          borderSide: BorderSide(
            color: ColorConstant.gray50001,
            width: 1,
          ),
        );
    }
  }

  _setFillColor() {
    switch (variant) {
      case TextFormFieldVariant.OutlineBluegray90047:
        return ColorConstant.whiteA700;
      case TextFormFieldVariant.FillBlue100:
        return ColorConstant.blue100;
      case TextFormFieldVariant.Dividers:
        return ColorConstant.whiteA700;
      case TextFormFieldVariant.FillWhiteA700:
        return ColorConstant.whiteA700;
      case TextFormFieldVariant.OutlineGray300:
        return ColorConstant.whiteA700;
      case TextFormFieldVariant.FillGray200:
        return ColorConstant.gray200;
      case TextFormFieldVariant.OutlineGray300_1:
        return ColorConstant.orange50;
      case TextFormFieldVariant.OutlineBlack9003f:
        return ColorConstant.whiteA700;
      default:
        return null;
    }
  }

  _setFilled() {
    switch (variant) {
      case TextFormFieldVariant.OutlineGray50001:
        return false;
      case TextFormFieldVariant.OutlineBluegray90047:
        return true;
      case TextFormFieldVariant.FillBlue100:
        return true;
      case TextFormFieldVariant.Dividers:
        return true;
      case TextFormFieldVariant.FillWhiteA700:
        return true;
      case TextFormFieldVariant.OutlineGray300:
        return true;
      case TextFormFieldVariant.FillGray200:
        return true;
      case TextFormFieldVariant.OutlineGray300_1:
        return true;
      case TextFormFieldVariant.OutlinePink60001:
        return false;
      case TextFormFieldVariant.UnderLineGray300:
        return false;
      case TextFormFieldVariant.OutlineBlue30001:
        return false;
      case TextFormFieldVariant.OutlineBlack9003f:
        return true;
      case TextFormFieldVariant.None:
        return false;
      default:
        return false;
    }
  }

  _setPadding() {
    switch (padding) {
      case TextFormFieldPadding.PaddingT26:
        return getPadding(
          top: 26,
          bottom: 26,
        );
      case TextFormFieldPadding.PaddingT28:
        return getPadding(
          left: 20,
          top: 28,
          bottom: 28,
        );
      case TextFormFieldPadding.PaddingT29:
        return getPadding(
          left: 20,
          top: 29,
          right: 20,
          bottom: 29,
        );
      case TextFormFieldPadding.PaddingT33:
        return getPadding(
          left: 20,
          top: 33,
          right: 20,
          bottom: 33,
        );
      case TextFormFieldPadding.PaddingAll12:
        return getPadding(
          all: 12,
        );
      case TextFormFieldPadding.PaddingAll5:
        return getPadding(
          all: 5,
        );
      case TextFormFieldPadding.PaddingT37:
        return getPadding(
          top: 37,
          right: 37,
          bottom: 37,
        );
      default:
        return getPadding(
          all: 17,
        );
    }
  }
}

enum TextFormFieldShape {
  RoundedBorder8,
  CustomBorderTL10,
}

enum TextFormFieldPadding {
  PaddingAll17,
  PaddingT26,
  PaddingT28,
  PaddingT29,
  PaddingT33,
  PaddingAll12,
  PaddingAll5,
  PaddingT37,
}

enum TextFormFieldVariant {
  None,
  OutlineGray50001,
  OutlineBluegray90047,
  FillBlue100,
  Dividers,
  FillWhiteA700,
  OutlineGray300,
  FillGray200,
  OutlineGray300_1,
  OutlinePink60001,
  UnderLineGray300,
  OutlineBlue30001,
  OutlineBlack9003f,
}

enum TextFormFieldFontStyle {
  MontserratMedium18,
  MontserratMedium15,
  MontserratSemiBold19,
  MontserratMedium17,
  MontserratMedium17Bluegray300,
  MontserratMedium15Gray50001,
  MontserratMedium15Black900,
  MontserratMedium15Blue600,
  MontserratRomanMedium14,
}
