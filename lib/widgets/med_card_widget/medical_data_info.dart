// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MedicalDataInfoWidget extends StatefulWidget {
  final String numberPolice;
  final String nameCompany;
  final String dateAction;
  final String medicien;
  final String medicineInfo;
  const MedicalDataInfoWidget({
    super.key,
    required this.numberPolice,
    required this.nameCompany,
    required this.dateAction,
    required this.medicien,
    required this.medicineInfo,
  });

  @override
  State<MedicalDataInfoWidget> createState() => _MedicalDataInfoWidgetState();
}

class _MedicalDataInfoWidgetState extends State<MedicalDataInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(29, 15, 17, 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [const Text('Срок действия'), Text(widget.dateAction)],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130,
                  height: 51,
                  child: Text('Наименование страховой компании'),
                ),
                Text('data')
              ],
            ),
            const AddFileWidget(),
            const Text('Не переносимость лекарств'),
            const AddFileWidget(),
            const Text('Аллергии'),
            const AddFileWidget(),
            const Text('Диагнозы'),
            const AddFileWidget(),
            const Text('Прививки'),
            const AddFileWidget(),
            const Text('Приём лекарств'),
            BottomInfoWidget(
              text: widget.medicien,
              textInfo: widget.medicineInfo,
            ),
            BottomInfoWidget(
              text: widget.medicien,
              textInfo: widget.medicineInfo,
            ),
            BottomInfoWidget(
              text: widget.medicien,
              textInfo: widget.medicineInfo,
            ),
          ],
        ));
  }
}

class AddFileWidget extends StatelessWidget {
  const AddFileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/icon-plus.png',
          color: const Color(0xff2C3E4F),
          width: 12,
          height: 12,
        ),
        const SizedBox(
          width: 5,
        ),
        const Text(
          'Добавить файл',
          style: TextStyle(
            color: Color(0xff2C3E4F),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class BottomInfoWidget extends StatelessWidget {
  final String text;
  final String textInfo;
  const BottomInfoWidget({
    super.key,
    required this.text,
    required this.textInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(text), Text(textInfo)],
    );
  }
}
