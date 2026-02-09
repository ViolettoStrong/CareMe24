import 'package:careme24/features/danger_icons/domain/danger_icon_props_usecase.dart';
import 'package:careme24/features/danger_icons/models/danger_model.dart';
import 'package:careme24/theme/app_decoration.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:careme24/widgets/custom_icon_button.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DangerInfoScreen extends StatelessWidget {
  const DangerInfoScreen({
    super.key,
    required this.model,
    required this.city,
  });

  final DangerModel model;
  final String city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 14),
              child: Row(
                children: [
                  model.isActive == false
                      ? Container(
                          height: 79,
                          width: 79,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: model.dangerLevel == 'Не активно'
                                ? DangerousColors.grey
                                : model.dangerLevel == 'В норме'
                                    ? DangerousColors.green
                                    : DangerousColors.darkgrey,
                          ),
                          child: SvgPicture.asset(
                            getIcon(model.incidentType),
                            color: Colors.black,
                          ))
                      : Container(
                          height: 79,
                          width: 79,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: getGradient(model.dangerLevel)),
                          child: SvgPicture.asset(
                            getIcon(model.incidentType),
                            color: Colors.black,
                          ),
                        ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.incidentType,
                          style: AppStyle.txtMontserratBold18,
                        ),
                        // Text(
                        //   city,
                        //   style: const TextStyle(
                        //     color: Color.fromRGBO(51, 132, 226, 1),
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        model.isActive == false
                            ? Container(
                                margin: const EdgeInsets.only(top: 9),
                                decoration: BoxDecoration(
                                  gradient: model.dangerLevel == 'Не активно'
                                      ? DangerousColors.grey
                                      : model.dangerLevel == 'В норме'
                                          ? DangerousColors.green
                                          : DangerousColors.darkgrey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17, vertical: 8),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  model.dangerLevel,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 9),
                                decoration: BoxDecoration(
                                  gradient: getGradient(model.dangerLevel),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17, vertical: 8),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  model.dangerLevel,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
              getRec(model.incidentType).length,
              (index) {
                final recommendations = getRec(model.incidentType);
                final recommendation = recommendations[index];

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
                          imagePath: recommendation.imagePath,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          recommendation.text,
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
