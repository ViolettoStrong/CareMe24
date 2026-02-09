import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/widgets/custom_icon_button.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';

class RecomendationPage extends StatelessWidget {
  const RecomendationPage({super.key, required this.recomendations});

  final List<Recomendation> recomendations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 43,
        centerTitle: true,
        title: const Text(
          "Фактор опасности",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 22, bottom: 14, left: 23, right: 23),
              child: Text(
                "Рекомендации по охране здоровья",
                textAlign: TextAlign.left,
                style: AppStyle.txtMontserratRomanSemiBold18Bluegray800,
              ),
            ),
            ...List.generate(
              recomendations.length,
              (index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 23, vertical: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: AppDecoration.outlineBlack9003f.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIconButton(
                        height: 54,
                        width: 54,
                        child: CustomImageView(
                          svgPath: recomendations[index].imagePath,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          recomendations[index].text,
                          maxLines: null,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtMontserratRomanMedium15,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Recomendation {
  final String imagePath;
  final String text;

  Recomendation({
    required this.imagePath,
    required this.text,
  });
}
