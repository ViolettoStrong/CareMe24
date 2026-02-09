import 'package:careme24/features/danger_icons/domain/danger_icon_props_usecase.dart';
import 'package:careme24/features/danger_icons/models/danger_model.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DangerIconCard extends StatelessWidget {
  final DangerModel icon;
  final Function()? onClose;
  const DangerIconCard({
    super.key,
    required this.icon,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 14),
        width: double.maxFinite,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(120, 120, 120, 0.24), blurRadius: 13)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: onClose,
                    child: const Icon(Icons.close),
                  ),
                )),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    gradient: icon.isActive
                        ? getGradient(icon.dangerLevel)
                        : DangerousColors.grey,
                  ),
                  child: SvgPicture.asset(
                    getIcon(icon.incidentType),
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 26),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        icon.incidentType,
                        style: const TextStyle(
                          color: Color.fromRGBO(44, 62, 79, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // const SizedBox(height: 8),
                      // Text(
                      //   icon.city,
                      //   style: const TextStyle(
                      //     color: Color.fromRGBO(51, 132, 226, 1),
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.w500,
                      //   ),
                      // ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: getGradient(icon.dangerLevel),
                        ),
                        child: Center(
                          child: Text(
                            icon.dangerLevel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            const Text(
              'Комментарий:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              icon.comment,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
