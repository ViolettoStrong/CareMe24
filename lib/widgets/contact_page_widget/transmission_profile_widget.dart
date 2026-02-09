import 'package:flutter/material.dart';

class TransmissionProfile extends StatelessWidget {
  final String name;
  const TransmissionProfile({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.fromLTRB(23, 60, 23, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.close,
                    size: 26,
                    color: Color(0xff2C3E4F),
                  ),
                ),
              )),
          Container(
            width: double.maxFinite,
            height: 43,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const FittedBox(
              alignment: Alignment.centerLeft,
              child: Text(
                'Выберите кому передать профиль',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            height: 30,
            color: const Color(0xffDDDEE2),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 28,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 18),
                      border: InputBorder.none,
                      errorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
/*          SizedBox(height: 12,),
          UserWidget(),
          SizedBox(height: 12,),
          UserWidget(),*/
        ],
      ),
    );
  }
}
