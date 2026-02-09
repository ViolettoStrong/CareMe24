import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class ForWhom extends StatefulWidget {
  late String name;

  ForWhom({
    super.key,
    required this.name,
  });

  @override
  State<ForWhom> createState() => _ForWhomState();
}

class _ForWhomState extends State<ForWhom> {
  callBackName(varName) {
    setState(() {
      widget.name = varName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        // GestureDetector(
        //   onTap: (){
        //     widget.callBack();
        //     //Navigator.push(context, MaterialPageRoute(builder: (context) => WhomPage(callback: callBackName,)));
        //   },
        //   child:
        widget.name == "Мне"
            ? CustomButton(
                width: getHorizontalSize(200),
                text: widget.name,
                margin: getMargin(top: 1),
                variant: ButtonVariant.GradientGreenA700GreenA70001,
                fontStyle: ButtonFontStyle.MontserratSemiBold18)
            : widget.name == "Другому"
                ? CustomButton(
                    width: getHorizontalSize(200),
                    text: widget.name,
                    margin: getMargin(top: 1),
                    variant: ButtonVariant.GradientGray,
                    fontStyle: ButtonFontStyle.MontserratSemiBold18)
                : CustomButton(
                    width: getHorizontalSize(200),
                    text: widget.name,
                    margin: getMargin(top: 1),
                    variant: ButtonVariant.GradientBlue500LightblueA200,
                    fontStyle: ButtonFontStyle.MontserratSemiBold18);
    // );
  }
}
