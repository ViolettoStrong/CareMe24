import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/widgets/file_piceker.dart';
import 'package:flutter/material.dart';

class TestResultWidget extends StatefulWidget {
  final List<ResponseModel> response;
  final Function()? onTap;

  const TestResultWidget(
      {super.key, required this.response, required this.onTap});

  @override
  State<TestResultWidget> createState() => _DoctorReportWidgetState();
}

class _DoctorReportWidgetState extends State<TestResultWidget> {
  bool isVisibality = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(29, 15, 17, 17),
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: const Color(0xffB3B3B3))),
      child: Column(
        children: [
          const Text(
            'Результаты анализов',
            style: TextStyle(
              color: Color(0xff5CA2C8),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 27),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isVisibality = !isVisibality;
                    });
                  },
                  child: isVisibality
                      ? Image.asset(
                          'assets/images/Vector 177.png',
                          width: 24,
                          height: 15,
                        )
                      : Image.asset(
                          'assets/images/arrow_down.png',
                        )),
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(widget.response.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.response[index].name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  widget.response[index].file != ''
                      ? FileZone(
                          canChange: false,
                          file: widget.response[index].file,
                          onChange: (p) {})
                      : const Text('Нет Файла',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                  Text(
                    widget.response[index].date,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            );
          }),
          if (widget.response.isEmpty)
            const Text('Нет данных',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          const SizedBox(height: 10),
          if (isVisibality)
            GestureDetector(
              onTap: widget.onTap,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  Text(
                    'Добавить заключение',
                    style: TextStyle(
                        color: Color.fromRGBO(44, 62, 79, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
