import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';

class AppDecoration {
  static BoxDecoration get gradientGreenA700GreenA70001 => BoxDecoration(
        gradient: LinearGradient(
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
        ),
      );
  static BoxDecoration get txtGradientAmberA700Orange300 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.8,
            0,
          ),
          end: const Alignment(
            0,
            0.9,
          ),
          colors: [
            ColorConstant.amberA700,
            ColorConstant.orange300,
          ],
        ),
      );
  static BoxDecoration get dividers => BoxDecoration(
        border: Border(
          top: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get outlineGray6003a => const BoxDecoration();
  static BoxDecoration get fillOrange50 => BoxDecoration(
        color: ColorConstant.orange50,
      );
  static BoxDecoration get txtFillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
  static BoxDecoration get outlineGray50001 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get txtOutlineGray50001 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            2,
          ),
        ),
      );
  static BoxDecoration get txtFillDeeppurpleA700 => BoxDecoration(
        color: ColorConstant.deepPurpleA700,
      );
  static BoxDecoration get txtFillYellowA40001 => BoxDecoration(
        color: ColorConstant.yellowA40001,
      );
  static BoxDecoration get outlineBlack90054 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90054,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              -0.5,
              -0.5,
            ),
          ),
        ],
      );
  static BoxDecoration get background => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.black900,
          width: getHorizontalSize(
            10,
          ),
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get fillIndigoA200 => BoxDecoration(
        color: ColorConstant.indigoA200,
      );
  static BoxDecoration get gradientIndigoA100IndigoA10001 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.96,
            -0.02,
          ),
          end: const Alignment(
            0,
            1,
          ),
          colors: [
            ColorConstant.indigoA100,
            ColorConstant.indigoA10001,
          ],
        ),
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
  static BoxDecoration get outlineGray300 => BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get outlineBlack9003a => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003a,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9003d => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003d,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get fillBlue600 => BoxDecoration(
        color: ColorConstant.blue600,
      );
  static BoxDecoration get outlineBlack9003f => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9003f1 => BoxDecoration(
        color: ColorConstant.gray20001,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9003f3 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get fillGray200 => BoxDecoration(
        color: ColorConstant.gray200,
      );
  static BoxDecoration get outlineBlack9003f2 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              -1,
            ),
          ),
        ],
      );
  static BoxDecoration get smallOutBlackLine => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              1,
            ),
            blurRadius: getHorizontalSize(
              1,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get txtOutlineRed90066 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.03,
            0.22,
          ),
          end: const Alignment(
            1,
            0.96,
          ),
          colors: [
            ColorConstant.redA200,
            ColorConstant.pink600,
          ],
        ),
      );
  static BoxDecoration get txtFillGray200 => BoxDecoration(
        color: ColorConstant.gray200,
      );
  static BoxDecoration get outlineBlack9003f5 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9003f4 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              -2,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get gradientAmberA700Amber400 => BoxDecoration(
        gradient: LinearGradient(
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
            ColorConstant.amber400,
          ],
        ),
      );
  static BoxDecoration get outlineBlack9003f7 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              1,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack9003f6 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get fillBluegray800 => BoxDecoration(
        color: ColorConstant.blueGray800,
      );
  static BoxDecoration get fillBlueA200 => BoxDecoration(
        color: ColorConstant.blueA200,
      );
  static BoxDecoration get gradientRedA200Pink600 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.03,
            0.22,
          ),
          end: const Alignment(
            1,
            0.96,
          ),
          colors: [
            ColorConstant.redA200,
            ColorConstant.pink600,
          ],
        ),
      );
  static BoxDecoration get outlineBlack90016 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90016,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineRed90066 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.03,
            0.22,
          ),
          end: const Alignment(
            1,
            0.96,
          ),
          colors: [
            ColorConstant.redA200,
            ColorConstant.pink600,
          ],
        ),
      );
  static BoxDecoration get txtFillLightgreen500 => BoxDecoration(
        color: ColorConstant.lightGreen500,
      );
  static BoxDecoration get outlineBlack90033 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90033,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineLightgreen90066 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            1,
            1,
          ),
          end: const Alignment(
            0.22,
            0,
          ),
          colors: [
            ColorConstant.cyan600,
            ColorConstant.deepPurple800,
            ColorConstant.purpleA700,
          ],
        ),
      );
  static BoxDecoration get outlineGray90001 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray90001,
          width: getHorizontalSize(
            10,
          ),
        ),
      );
  static BoxDecoration get outlineBluegray700 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.blueGray700,
          width: getHorizontalSize(
            3,
          ),
        ),
      );
  static BoxDecoration get outlineBlue600 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.blue600,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get fillIndigoA100 => BoxDecoration(
        color: ColorConstant.indigoA100,
      );
  static BoxDecoration get txtFillBlue30001 => BoxDecoration(
        color: ColorConstant.blue30001,
      );
  static BoxDecoration get outlineBlack9001c => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9001c,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack90026 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      );
  static BoxDecoration get fillBlue300 => BoxDecoration(
        color: ColorConstant.blue300,
      );
  static BoxDecoration get txtOutlineGray300 => BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              2,
            ),
          ),
        ),
      );
  static BoxDecoration get fillBluegray500 => BoxDecoration(
        color: ColorConstant.blueGray500,
      );
  static BoxDecoration get gradientAmberA700Orange300 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.8,
            0,
          ),
          end: const Alignment(
            0,
            0.9,
          ),
          colors: [
            ColorConstant.amberA700,
            ColorConstant.orange300,
          ],
        ),
      );
  static BoxDecoration get fillCyan300 => BoxDecoration(
        color: ColorConstant.cyan300,
      );
  static BoxDecoration get outlineBlack9003d1 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003d,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get gradientBlue60001IndigoA400 => BoxDecoration(
        gradient: LinearGradient(
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
        ),
      );
  static BoxDecoration get outlineIndigo200491 => BoxDecoration(
        gradient: LinearGradient(
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
        ),
      );
  static BoxDecoration get txtFillRed900 => BoxDecoration(
        color: ColorConstant.red900,
      );
  static BoxDecoration get gradientPink500Deeporange400 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.8,
            0,
          ),
          end: const Alignment(
            0,
            0.9,
          ),
          colors: [
            ColorConstant.pink500,
            ColorConstant.deepOrange400,
          ],
        ),
      );
  static BoxDecoration get txtFillRedA20001 => BoxDecoration(
        color: ColorConstant.redA20001,
      );
  static BoxDecoration get outlineBlue70049 => BoxDecoration(
        gradient: LinearGradient(
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
        ),
      );
  static BoxDecoration get gradientYellow500YellowA400 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.8,
            0,
          ),
          end: const Alignment(
            0,
            0.9,
          ),
          colors: [
            ColorConstant.yellow500,
            ColorConstant.yellowA400,
          ],
        ),
      );
  static BoxDecoration get outlineBlack90011 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90011,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              -4,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack90014 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90014,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineBlack900141 => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90014,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              2,
            ),
          ),
        ],
      );
  static BoxDecoration get fillYellow700 => BoxDecoration(
        color: ColorConstant.yellow700,
      );
  static BoxDecoration get gradientWhiteA700WhiteA70000 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.5,
            0,
          ),
          end: const Alignment(
            0.5,
            1,
          ),
          colors: [
            ColorConstant.whiteA700,
            ColorConstant.whiteA70000,
          ],
        ),
      );
  static BoxDecoration get txtDividers => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get outlineGray500 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.gray500,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get gradientLightgreenA200LightgreenA700 =>
      BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.8,
            0,
          ),
          end: const Alignment(
            0,
            0.9,
          ),
          colors: [
            ColorConstant.lightGreenA200,
            ColorConstant.lightGreenA700,
          ],
        ),
      );
  static BoxDecoration get gradientPink300PinkA100 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            1,
            0,
          ),
          end: const Alignment(
            0,
            1,
          ),
          colors: [
            ColorConstant.pink300,
            ColorConstant.pinkA100,
          ],
        ),
      );
  static BoxDecoration get outlineGray900011 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray90001,
          width: getHorizontalSize(
            10,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90011,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              -4,
            ),
          ),
        ],
      );
  static BoxDecoration get fillRed900 => BoxDecoration(
        color: ColorConstant.red900,
      );
  static BoxDecoration get txtFillBlue600 => BoxDecoration(
        color: ColorConstant.blue600,
      );
  static BoxDecoration get txtOutlineBlue600 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.blue600,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get outlineBlue6001 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.blue600,
          width: getHorizontalSize(
            2,
          ),
        ),
      );
  static BoxDecoration get outlineBlue6002 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.blue600,
          width: getHorizontalSize(
            2,
          ),
        ),
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.black900,
          width: getHorizontalSize(
            10,
          ),
          strokeAlign: strokeAlignOutside,
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90011,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              -4,
            ),
          ),
        ],
      );
  static BoxDecoration get txtOutlineGray3001 => BoxDecoration(
        color: ColorConstant.orange50,
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get txtOutlineGray3002 => BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get outlineIndigo20049 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            1,
            1,
          ),
          end: const Alignment(
            0.22,
            0,
          ),
          colors: [
            ColorConstant.cyan600,
            ColorConstant.deepPurple800,
            ColorConstant.purpleA700,
          ],
        ),
      );
  static BoxDecoration get txtOutlineGray3003 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get fillGray30001 => BoxDecoration(
        color: ColorConstant.gray30001,
      );
  static BoxDecoration get txtOutlineGray3004 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get txtGradientPink500Deeporange400 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.8,
            0,
          ),
          end: const Alignment(
            0,
            0.9,
          ),
          colors: [
            ColorConstant.pink500,
            ColorConstant.deepOrange400,
          ],
        ),
      );
  static BoxDecoration get txtOutlineGray3005 => BoxDecoration(
        color: ColorConstant.gray30002,
        border: Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get outlineGray500013 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get outlineGray500012 => const BoxDecoration();
  static BoxDecoration get outlineGreen40049 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.15,
            0.1,
          ),
          end: const Alignment(
            0.86,
            0.9,
          ),
          colors: [
            ColorConstant.green400,
            ColorConstant.green500,
          ],
        ),
      );
  static BoxDecoration get outlineGray500011 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray50001,
          width: getHorizontalSize(
            2,
          ),
        ),
      );
  static BoxDecoration get gradientWhiteA700WhiteA700 => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(
            0.5,
            0,
          ),
          end: const Alignment(
            0.5,
            1,
          ),
          colors: [
            ColorConstant.whiteA700,
            ColorConstant.whiteA700,
          ],
        ),
      );
  static BoxDecoration get fillBlue60001 => BoxDecoration(
        color: ColorConstant.blue60001,
      );
  static BoxDecoration get outlineBlack9001 => BoxDecoration(
        color: ColorConstant.blueGray800,
        border: Border.all(
          color: ColorConstant.black900,
          width: getHorizontalSize(
            10,
          ),
          strokeAlign: strokeAlignOutside,
        ),
      );
  static BoxDecoration get fillBlue30035 => BoxDecoration(
        color: ColorConstant.blue30035,
      );
  static BoxDecoration get txtOutlineBlue30001 => BoxDecoration(
        border: Border.all(
          color: ColorConstant.blue30001,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get txtGradientBlue60001IndigoA400 => BoxDecoration(
        gradient: LinearGradient(
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
        ),
      );
  static BoxDecoration get fillGray900 => BoxDecoration(
        color: ColorConstant.gray900,
      );
  static BoxDecoration get outlineGray3002 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get outlineGray3001 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get fillGreen40001 => BoxDecoration(
        color: ColorConstant.green40001,
      );
  static BoxDecoration get outlineGray3004 => BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get outlineGray3003 => BoxDecoration(
        color: ColorConstant.gray200,
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
      );
  static BoxDecoration get outlineGray3006 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get outlineGray3005 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border(
          bottom: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              2,
              0,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineGray3008 => BoxDecoration(
        color: ColorConstant.whiteA700,
        border: Border(
          top: BorderSide(
            color: ColorConstant.gray300,
            width: getHorizontalSize(
              1,
            ),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90019,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              3,
            ),
          ),
        ],
      );
  static BoxDecoration get outlineGray3007 => BoxDecoration(
        color: ColorConstant.gray30002,
        border: Border.all(
          color: ColorConstant.gray300,
          width: getHorizontalSize(
            1,
          ),
        ),
      );
  static BoxDecoration get fillGray50001 => BoxDecoration(
        color: ColorConstant.gray50001,
      );
  static BoxDecoration get txtFillPink50001 => BoxDecoration(
        color: ColorConstant.pink50001,
      );
  static BoxDecoration get fillGray50002 => BoxDecoration(
        color: ColorConstant.gray50002,
      );
  static BoxDecoration get white => BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black90019,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      );
  static BoxDecoration get fillBlue100 => BoxDecoration(
        color: ColorConstant.blue100,
      );
  static BoxDecoration get fillGray100 => BoxDecoration(
        color: ColorConstant.gray100,
      );
  static BoxDecoration get fillPink300 => BoxDecoration(
        color: ColorConstant.pink300,
      );

  static BoxDecoration get fillcyan300 => BoxDecoration(
        color: ColorConstant.cyan300,
      );

  static BoxDecoration get fillgrey => BoxDecoration(
        color: ColorConstant.gray1000,
      );
}

class BorderRadiusStyle {
  static BorderRadius customBorderTL10 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        10,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        7,
      ),
    ),
    bottomLeft: Radius.circular(
      getHorizontalSize(
        10,
      ),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(
        7,
      ),
    ),
  );

  static BorderRadius txtRoundedBorder21 = BorderRadius.circular(
    getHorizontalSize(
      21,
    ),
  );

  static BorderRadius customBorderBR301 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        10,
      ),
    ),
    bottomLeft: Radius.circular(
      getHorizontalSize(
        10,
      ),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(
        30,
      ),
    ),
  );

  static BorderRadius customBorderTL15 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        15,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        15,
      ),
    ),
  );

  static BorderRadius roundedBorder18 = BorderRadius.circular(
    getHorizontalSize(
      18,
    ),
  );

  static BorderRadius txtRoundedBorder49 = BorderRadius.circular(
    getHorizontalSize(
      49,
    ),
  );

  static BorderRadius roundedBorder7 = BorderRadius.circular(
    getHorizontalSize(
      7,
    ),
  );

  static BorderRadius roundedBorder65 = BorderRadius.circular(
    getHorizontalSize(
      65,
    ),
  );

  static BorderRadius roundedBorder2 = BorderRadius.circular(
    getHorizontalSize(
      2,
    ),
  );

  static BorderRadius txtRoundedBorder7 = BorderRadius.circular(
    getHorizontalSize(
      7,
    ),
  );

  static BorderRadius roundedBorder60 = BorderRadius.circular(
    getHorizontalSize(
      60,
    ),
  );

  static BorderRadius customBorderBR30 = BorderRadius.only(
    bottomRight: Radius.circular(
      getHorizontalSize(
        30,
      ),
    ),
  );

  static BorderRadius txtCircleBorder39 = BorderRadius.circular(
    getHorizontalSize(
      39,
    ),
  );

  static BorderRadius txtCustomBorderTL10 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        10,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        10,
      ),
    ),
  );

  static BorderRadius txtRoundedBorder10 = BorderRadius.circular(
    getHorizontalSize(
      10,
    ),
  );

  static BorderRadius circleBorder26 = BorderRadius.circular(
    getHorizontalSize(
      26,
    ),
  );

  static BorderRadius customBorderBL10 = BorderRadius.only(
    bottomLeft: Radius.circular(
      getHorizontalSize(
        10,
      ),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(
        10,
      ),
    ),
  );

  static BorderRadius txtRoundedBorder16 = BorderRadius.circular(
    getHorizontalSize(
      16,
    ),
  );

  static BorderRadius roundedBorder39 = BorderRadius.circular(
    getHorizontalSize(
      39,
    ),
  );

  static BorderRadius roundedBorder15 = BorderRadius.circular(
    getHorizontalSize(
      15,
    ),
  );

  static BorderRadius roundedBorder106 = BorderRadius.circular(
    getHorizontalSize(
      106,
    ),
  );

  static BorderRadius roundedBorder10 = BorderRadius.circular(
    getHorizontalSize(
      10,
    ),
  );

  static BorderRadius circleBorder53 = BorderRadius.circular(
    getHorizontalSize(
      53,
    ),
  );

  static BorderRadius roundedBorder71 = BorderRadius.circular(
    getHorizontalSize(
      71,
    ),
  );

  static BorderRadius roundedBorder91 = BorderRadius.circular(
    getHorizontalSize(
      91,
    ),
  );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;
