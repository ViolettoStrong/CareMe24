import 'package:flutter/material.dart';

class NoContactWidget extends StatelessWidget {
  const NoContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Image.asset('assets/images/Search.png'),
          const Padding(
            padding: EdgeInsets.only(
              top: 9,
            ),
            child: Text(
              'Список пуст',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xff8E969B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
