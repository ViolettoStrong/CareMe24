import 'package:flutter/material.dart';

class ContactInfoBox extends StatelessWidget {
  final String phoneNumber;
  final String name;
  final String address;
  const ContactInfoBox(
      {required this.phoneNumber,
      required this.name,
      required this.address,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 40),
        child: Row(children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Телефон:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff2c3e4f),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'ФИО:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff2c3e4f),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Адрес:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff2c3e4f),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phoneNumber,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff3384E2),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff3384E2),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff3384E2),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
