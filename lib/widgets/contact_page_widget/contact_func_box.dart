import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactFuncBox extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final bool isIcon;
  final IconData icon;

  const ContactFuncBox({
    required this.imagePath,
    required this.title,
    required this.color,
    required this.onTap,
    this.isIcon = false,
    this.icon = Icons.abc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          color: color,
          height: 54,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !isIcon
                    ? SvgPicture.asset(imagePath)
                    : Icon(
                        icon,
                        color: Colors.white,
                      ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
