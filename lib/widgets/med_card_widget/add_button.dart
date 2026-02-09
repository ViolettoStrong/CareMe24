import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const AddButton({
    required this.buttonText,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            alignment: Alignment.center,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icon-plus.png',
                  height: 13,
                  color: const Color(0xff2C3E4F),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  buttonText,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff2C3E4F).withOpacity(0.8),
                      fontFamily: 'Montserrat'),
                )
              ],
            ),
          )),
    );
  }
}
