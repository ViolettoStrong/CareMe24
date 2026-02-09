import 'package:flutter/material.dart';

class AvatarWithNameWidget extends StatelessWidget {
  final String contactName;
  final String avatarPath;
  final String old;
  final bool isMale;
  const AvatarWithNameWidget(
      {required this.contactName,
      required this.avatarPath,
      required this.old,
      required this.isMale,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            height: 143,
            width: 143,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.asset(avatarPath),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isMale
                  ? Image.asset('assets/images/female.png')
                  : Image.asset('assets/images/female.png'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  contactName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2c3e4f),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '$old года',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff3384E2),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
