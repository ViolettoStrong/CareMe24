import 'dart:io';

import 'package:careme24/theme/app_style.dart';
import 'package:careme24/widgets/custom_text_field.dart';
import 'package:careme24/widgets/file_piceker.dart';
import 'package:flutter/material.dart';

class MedicalDataWidget extends StatefulWidget {
  final TextEditingController bloodTypeController;
  final TextEditingController numberPoliceController;
  final TextEditingController insuranceNumberController;
  final TextEditingController validityPeriodController;
  final TextEditingController insuranceNameController;
  final String file;
  final Function() onTap;
  final Function(File) onChange;
  final bool showInsurance;
  final Function(bool bloodTypeValid, bool numberPoliceValid)? onValidate;

  const MedicalDataWidget({
    super.key,
    required this.bloodTypeController,
    required this.numberPoliceController,
    required this.insuranceNumberController,
    required this.validityPeriodController,
    required this.file,
    required this.insuranceNameController,
    required this.onTap,
    required this.onChange,
    this.showInsurance = true,
    this.onValidate,
  });

  @override
  State<MedicalDataWidget> createState() => _MedicalDataWidgetState();
}

class _MedicalDataWidgetState extends State<MedicalDataWidget> {
  bool isVisibality = false;
  bool numberpolice = false;
  bool bloodType = false;

  // Border colors
  Color bloodTypeBorderColor = Colors.pink;
  Color numberPoliceBorderColor = Colors.pink;

  @override
  void initState() {
    super.initState();

    _validateField(
      widget.bloodTypeController,
      (c) => bloodTypeBorderColor = c,
      validator: (t) => RegExp(r'^(?:[1-4][+-])$').hasMatch(t),
    );
    _validateField(
      widget.numberPoliceController,
      (c) => numberPoliceBorderColor = c,
      validator: (t) => RegExp(r'^\d{10}$').hasMatch(t),
    );
  }

  void _validateField(
      TextEditingController controller, Function(Color) setColor,
      {bool Function(String)? validator}) {
    final text = controller.text.trim();
    final isValid = validator?.call(text) ?? text.isNotEmpty;
    setState(() {
      setColor(isValid ? Colors.green : Colors.pink);
    });
  }

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
        children: <Widget>[
          const Text(
            'Медицинские данные',
            style: TextStyle(
              color: Color(0xff5CA2C8),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!widget.showInsurance)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 27),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
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
                          ),
                  ),
                ),
              ),
            ),
          Column(
            children: [
              const SizedBox(height: 8),
              // === Группа крови ===
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Группа крови ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      height: 45, // նույն բարձրությունը, ինչ CustomTextField-ը
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: bloodTypeBorderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            builder: (_) => _BloodTypeSelectorModal(
                              selectedValue: widget.bloodTypeController.text,
                            ),
                          );

                          if (result != null) {
                            widget.bloodTypeController.text = result;

                            final isValid = RegExp(
                                    r'^[1-4]\s\/\s(?:I\s\(O\)|II\s\(A\)|III\s\(B\)|IV\s\(AB\))\s\/\s[+-]$')
                                .hasMatch(result);

                            bloodType = isValid;
                            widget.onValidate?.call(bloodType, numberpolice);

                            setState(() {
                              bloodTypeBorderColor =
                                  isValid ? Colors.green : Colors.red;
                            });
                          }
                        },
                        child: DropdownButtonHideUnderline(
                          child: InputDecorator(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                enabledBorder:
                                    InputBorder.none, // 🔹 Երբ widget-ը ակտիվ է
                                focusedBorder: InputBorder.none),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.bloodTypeController.text.isEmpty
                                      ? 'Выбрать'
                                      : widget.bloodTypeController.text,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.black54),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              // === Номер полиса ===
              Row(
                children: [
                  const Text(
                    'Номер полиса',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: numberPoliceBorderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomTextField(
                        controller: widget.numberPoliceController,
                        hintText: 'Номер полиса',
                        color: Colors.black,
                        onChanged: (val) => _validateField(
                            widget.numberPoliceController,
                            (c) => numberPoliceBorderColor = c, validator: (t) {
                          final isValid = RegExp(r'^\d{10}$').hasMatch(t);
                          numberpolice = isValid;
                          widget.onValidate?.call(bloodType, numberpolice);
                          return isValid;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isVisibality && !widget.showInsurance)
            Column(
              children: [
                const Text(
                  'Медицинская страховка',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromRGBO(36, 0, 0, 1)),
                ),
                Row(
                  children: [
                    const Text(
                      'Номер',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: CustomTextField(
                            controller: widget.insuranceNumberController,
                            hintText: 'Номер',
                            color: Colors.black))
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Срок действия',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: CustomTextField(
                            controller: widget.validityPeriodController,
                            hintText: 'Срок действия',
                            color: Colors.black))
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Наименование\nстраховой\nкомпании',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: CustomTextField(
                            controller: widget.insuranceNameController,
                            hintText: 'Наименование страховой компании',
                            color: Colors.black))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Фото',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 20),
                    FileZone(
                      file: widget.file,
                      onChange: (file) {
                        widget.onChange(file);
                      },
                    )
                  ],
                ),
                if (isVisibality && !widget.showInsurance)
                  Padding(
                      padding: const EdgeInsets.only(top: 24.0, bottom: 24),
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: widget.onTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromRGBO(65, 73, 255, 1),
                                    Color.fromRGBO(41, 142, 235, 1),
                                  ])),
                              child: Center(
                                child: Text(
                                  'Обновить данные',
                                  style: AppStyle.txtMontserratf18w600,
                                ),
                              ),
                            ),
                          ))),
              ],
            )
        ],
      ),
    );
  }
}

class _BloodTypeSelectorModal extends StatefulWidget {
  final String selectedValue;
  const _BloodTypeSelectorModal({required this.selectedValue});

  @override
  State<_BloodTypeSelectorModal> createState() =>
      _BloodTypeSelectorModalState();
}

class _BloodTypeSelectorModalState extends State<_BloodTypeSelectorModal> {
  int? selectedGroup;
  String? selectedRh;

  final groups = const {
    1: 'I (O)',
    2: 'II (A)',
    3: 'III (B)',
    4: 'IV (AB)',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Выберите группу крови",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            // ────────────────────────────────
            //     LEFT (Groups)   |  RIGHT (+/-)
            // ────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LEFT COLUMN — Groups
                Expanded(
                  flex: 2,
                  child: Column(
                    children: groups.entries.map((entry) {
                      final isSelected = selectedGroup == entry.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedGroup = entry.key;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.grey.shade500,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${entry.key} – ${entry.value}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(width: 16),

                // RIGHT COLUMN — + and -
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _rhButton("+"),
                      const SizedBox(height: 14),
                      _rhButton("-"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // CONFIRM BUTTON
            Center(
              child: ElevatedButton(
                onPressed: (selectedGroup != null && selectedRh != null)
                    ? () {
                        final result =
                            "${selectedGroup!} / ${groups[selectedGroup]!} / $selectedRh";
                        Navigator.pop(context, result);
                      }
                    : null,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
                  child: Text("Выбрать"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rhButton(String value) {
    final isSelected = selectedRh == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRh = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade500,
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
