import 'package:careme24/theme/app_style.dart';
import 'package:flutter/material.dart';

import '../../../utils/size_utils.dart';

class DangerousIcon extends StatelessWidget {
  final String warningName;
  final String infoOfWarning;
  final VoidCallback onTap;
  final Widget icon;

  const DangerousIcon({
    super.key,
    required this.warningName,
    required this.infoOfWarning,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: SizedBox(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 4.0, left: 4, right: 4),
                  child: Text(
                    warningName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.txtMontserratMedium12,
                  ),
                ),
                Container(
                  height: 79,
                  width: 79,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFF846),
                        Color(0xFFFFE600),
                      ],
                    ),
                  ),
                  child: icon,
                ),
                //Image.asset("assets/images/harmfully.png"),
                Padding(
                    padding: getPadding(top: 7),
                    child: Text(infoOfWarning,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtMontserratSemiBold12))
              ],
            ),
          ),
        ));
  }
}
