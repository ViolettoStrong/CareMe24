import 'package:careme24/theme/app_style.dart';
import 'package:flutter/material.dart';

class SendRequest extends StatelessWidget {
  const SendRequest({
    super.key,
    required this.onYesTap,
    required this.onNoTap,
    required this.myProfileName,
    required this.sendToProfileName,
  });

  final VoidCallback onYesTap;
  final VoidCallback onNoTap;
  final String myProfileName;
  final String sendToProfileName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: size.width,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Center(
            child: Text(
              'Вы уверены в передаче профиля $myProfileName, профилю $sendToProfileName ?',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onYesTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(65, 73, 255, 1),
                          Color.fromRGBO(41, 142, 235, 1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Да',
                        style: AppStyle.txtMontserratf12w600,
                      ),
                    ),
                  ),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onNoTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 89, 99, 1),
                          Color.fromRGBO(224, 14, 102, 1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Нет',
                        style: AppStyle.txtMontserratf12w600,
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
