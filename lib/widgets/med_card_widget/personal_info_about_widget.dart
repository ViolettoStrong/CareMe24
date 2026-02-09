// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:careme24/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonalInfoAboutWidget extends StatefulWidget {
  final TextEditingController date;
  final TextEditingController countryAndAddres;
  final TextEditingController serial;
  final TextEditingController number;
  final TextEditingController place;
  final TextEditingController data;
  final Function(
    bool dateBorder,
    bool addressBorder,
    bool serialBorder,
    bool numberBorder,
    bool placeBorder,
    bool dataBorder,
  )? onValidate;

  const PersonalInfoAboutWidget(
      {super.key,
      required this.date,
      required this.countryAndAddres,
      required this.number,
      required this.serial,
      required this.place,
      required this.data,
      this.onValidate});

  @override
  State<PersonalInfoAboutWidget> createState() =>
      _PersonalInfoAboutWidgetState();
}

class _PersonalInfoAboutWidgetState extends State<PersonalInfoAboutWidget> {
  final dateFormatter = MaskTextInputFormatter(
    mask: '##.##.####', // Format: DD.MM.YYYY
    filter: {"#": RegExp(r'[0-9]')},
  );

  final passportSerialFormatter = MaskTextInputFormatter(
    mask: 'AA #######',
    filter: {"A": RegExp(r'[A-Za-z]'), "#": RegExp(r'[0-9]')},
  );

  final passportNumberFormatter = MaskTextInputFormatter(
    mask: '#########',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // Border colors
  Color dateBorderColor = Colors.pink;
  Color addressBorderColor = Colors.pink;
  Color serialBorderColor = Colors.pink;
  Color numberBorderColor = Colors.pink;
  Color placeBorderColor = Colors.pink;
  Color dataBorderColor = Colors.pink;

  bool dateBorder = false;
  bool addressBorder = false;
  bool serialBorder = false;
  bool numberBorder = false;
  bool placeBorder = false;
  bool dataBorder = false;

  void _validateField(
      TextEditingController controller, Function(Color) setColor,
      {bool Function(String)? validator}) {
    final text = controller.text.trim();
    final isValid = validator?.call(text) ?? text.isNotEmpty;
    setState(() {
      setColor(isValid ? Colors.green : Colors.pink);
    });
  }

  Future<void> _selectDate(BuildContext context,
      TextEditingController controller, Function(Color) setColor) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}"
          ".${pickedDate.month.toString().padLeft(2, '0')}"
          ".${pickedDate.year}";
      setState(() {
        controller.text = formattedDate;
      });
      _validateField(controller, setColor,
          validator: (t) => RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(t));
    }
  }

  @override
  void initState() {
    _validateField(widget.date, (c) => dateBorderColor = c,
        validator: (t) => RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(t));
    _validateField(widget.countryAndAddres, (c) => addressBorderColor = c);
    _validateField(widget.serial, (c) => serialBorderColor = c,
        validator: (t) => RegExp(r'^\d{4}$').hasMatch(t));
    _validateField(widget.number, (c) => numberBorderColor = c,
        validator: (t) => RegExp(r'^\d{6}$').hasMatch(t));
    _validateField(widget.place, (c) => placeBorderColor = c);
    _validateField(widget.data, (c) => dataBorderColor = c,
        validator: (t) => RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(t));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // === Дата рождения ===
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () =>
              _selectDate(context, widget.date, (c) => dateBorderColor = c),
          child: AbsorbPointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: dateBorderColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomTextField(
                keyboardType: TextInputType.number,
                controller: widget.date,
                hintText: 'Дата рождения',
                color: Colors.black,
                inputFormatters: [dateFormatter],
                onChanged: (val) => _validateField(
                    widget.date, (c) => dateBorderColor = c, validator: (t) {
                  final isValid = RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(t);
                  dateBorder = isValid;
                  widget.onValidate?.call(dateBorder, addressBorder,
                      serialBorder, numberBorder, placeBorder, dataBorder);
                  return isValid;
                }),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),

        // === Адрес ===
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: addressBorderColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomTextField(
            controller: widget.countryAndAddres,
            hintText: 'Адрес',
            color: Colors.black,
            onChanged: (val) => _validateField(
                widget.countryAndAddres, (c) => addressBorderColor = c,
                validator: (t) {
              final isValid = true;
              addressBorder = isValid;
              widget.onValidate?.call(dateBorder, addressBorder, serialBorder,
                  numberBorder, placeBorder, dataBorder);
              return isValid;
            }),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        // === Серия паспорта ===
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: serialBorderColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomTextField(
            keyboardType: TextInputType.text,
            controller: widget.serial,
            hintText: 'Серия паспорта',
            color: const Color(0xff2C3E4F),
            onChanged: (val) => _validateField(
                widget.serial, (c) => serialBorderColor = c, validator: (t) {
              final isValid = RegExp(r'^\d{4}$').hasMatch(t);
              serialBorder = isValid;
              widget.onValidate?.call(dateBorder, addressBorder, serialBorder,
                  numberBorder, placeBorder, dataBorder);
              return isValid;
            }),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        // === Номер паспорта ===
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: numberBorderColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomTextField(
            keyboardType: TextInputType.number,
            controller: widget.number,
            hintText: 'Номер паспорта',
            color: const Color(0xff2C3E4F),
            inputFormatters: [passportNumberFormatter],
            onChanged: (val) => _validateField(
                widget.number, (c) => numberBorderColor = c, validator: (t) {
              final isValid = RegExp(r'^\d{6}$').hasMatch(t);
              numberBorder = isValid;
              widget.onValidate?.call(dateBorder, addressBorder, serialBorder,
                  numberBorder, placeBorder, dataBorder);
              return isValid;
            }),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        // === Место выдачи ===
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: placeBorderColor, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomTextField(
            controller: widget.place,
            hintText: 'Место выдачи',
            color: const Color(0xff2C3E4F),
            onChanged: (val) => _validateField(
                widget.place, (c) => placeBorderColor = c, validator: (t) {
              final isValid = true;
              placeBorder = isValid;
              widget.onValidate?.call(dateBorder, addressBorder, serialBorder,
                  numberBorder, placeBorder, dataBorder);
              return isValid;
            }),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        // === Дата выдачи ===
        GestureDetector(
          onTap: () =>
              _selectDate(context, widget.data, (c) => dataBorderColor = c),
          child: AbsorbPointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: dataBorderColor, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomTextField(
                keyboardType: TextInputType.number,
                controller: widget.data,
                hintText: 'Дата выдачи',
                color: const Color(0xff2C3E4F),
                inputFormatters: [dateFormatter],
                onChanged: (val) => _validateField(
                    widget.data, (c) => dataBorderColor = c, validator: (t) {
                  final isValid = RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(t);
                  dataBorder = isValid;
                  widget.onValidate?.call(dateBorder, addressBorder,
                      serialBorder, numberBorder, placeBorder, dataBorder);
                  return isValid;
                }),
              ),
            ),
          ),
        ),
        SizedBox(height: 20)
      ],
    );
  }
}

// CustomTextField(
//   keyboardType: TextInputType.number,
//   controller: widget.date, hintText: 'Дата рождения', color: Colors.black),
// CustomTextField(
//   controller: widget.countryAndAddres,
//   hintText: 'Адрес',
//   color: Colors.black
// ),
// CustomTextField(
//   keyboardType: TextInputType.number,
//   controller: widget.serial,
//   hintText: 'Cерия паспорта',
//   color: const Color(0xff2C3E4F)
// ),
// CustomTextField(
//   keyboardType: TextInputType.number,
//   controller: widget.number,
//   hintText: 'Номер паспорта',
//   color: const Color(0xff2C3E4F)
// ),
// CustomTextField(
//   controller: widget.place,
//   hintText: 'Место выдачи',
//   color: const Color(0xff2C3E4F)
// ),
// CustomTextField(
//   keyboardType: TextInputType.number,
//   controller: widget.data,
//   hintText: 'Дата выдачи',
//   color: const Color(0xff2C3E4F)
// ),
/*    Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon-plus.png',
              width: 12,
              height: 12,
              color: const Color(0xff2C3E4F),
            ),
            const SizedBox(width: 5,),
            const Text(
              'Добавить файл',
              style: TextStyle(
                color: Color(0xff2C3E4F),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        const Text(
          'документы',
          style: TextStyle(
            color: Color(0xff2C3E4F),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon-plus.png',
              color: const Color(0xff2C3E4F),
              width: 12,
              height: 12,
            ),
            const SizedBox(width: 5,),
            const Text(
              'Добавить файл',
              style: TextStyle(
                color: Color(0xff2C3E4F),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ), */
