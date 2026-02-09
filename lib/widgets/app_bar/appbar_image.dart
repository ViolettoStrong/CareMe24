import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class AppbarImage extends StatelessWidget {
  const AppbarImage(
      {super.key,
      required this.height,
      required this.width,
      this.imagePath,
      this.svgPath,
      this.margin,
      this.onTap});

  final double height;

  final double width;

  final String? imagePath;

  final String? svgPath;

  final EdgeInsetsGeometry? margin;

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          svgPath: svgPath,
          imagePath: imagePath,
          height: height,
          width: width,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
