import 'package:flutter/material.dart';

import '../../theme/app_style.dart';

class AddPhoneNumber extends StatelessWidget {
  final VoidCallback onClose;
  const AddPhoneNumber({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onClose,
                  child: const Icon(
                    Icons.close,
                    size: 35,
                    color: Color(0xff2C3E4F),
                  ),
                ),
              )),
          const SizedBox(
            height: 7,
          ),
          Text(
            'Введите номер телефона для\nпоиска',
            textAlign: TextAlign.center,
            style: AppStyle.txtInterExtraBold12.copyWith(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xff8E969B)),
            width: MediaQuery.of(context).size.width,
            child: Text(
              'Добавить',
              style: AppStyle.txtInterExtraBold12.copyWith(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
