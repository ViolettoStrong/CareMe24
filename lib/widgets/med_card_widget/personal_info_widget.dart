import 'dart:io';

import 'package:careme24/theme/app_style.dart';
import 'package:careme24/widgets/files_zone.dart';
import 'package:careme24/widgets/med_card_widget/personal_info_about_widget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PersonalInfoWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController numberController;
  final TextEditingController countryAndAddresController;
  final TextEditingController dateController;
  final TextEditingController passportNumberController;
  final TextEditingController passportSerialController;
  final TextEditingController passportPlaceController;
  final TextEditingController passportDataController;
  final List<String> files;
  final bool createMode;
  final Function(List<File>?) onChange;
  final Function() onTap;
  final Function(
      bool dateBorder,
      bool addressBorder,
      bool serialBorder,
      bool numberBorder,
      bool placeBorder,
      bool dataBorder,
      bool fio,
      bool phone)? onValidate;

  const PersonalInfoWidget(
      {required this.nameController,
      required this.numberController,
      required this.countryAndAddresController,
      required this.dateController,
      required this.passportNumberController,
      required this.passportSerialController,
      required this.passportPlaceController,
      required this.passportDataController,
      required this.onChange,
      required this.files,
      required this.onTap,
      this.createMode = false,
      super.key,
      this.onValidate});

  @override
  State<PersonalInfoWidget> createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends State<PersonalInfoWidget> {
  bool isVisibality = true;
  List<File> selectedFiles = [];

  String countryCode = '+7';

  // Border colors
  Color fioBorderColor = Colors.pink;
  Color phoneBorderColor = Colors.pink;
  bool fio = false;
  bool phone = false;
  bool dateBordern = false;
  bool addressBordern = false;
  bool serialBordern = false;
  bool numberBordern = false;
  bool placeBordern = false;
  bool dataBordern = false;
  bool numberpolice = false;
  bool bloodType = false;

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
  void initState() {
    super.initState();

    // Նախնական ստուգումներ
    _validateField(
      widget.nameController,
      (c) => fioBorderColor = c,
      validator: (t) =>
          RegExp(r'^[А-Яа-яA-Za-z]+ [А-Яа-яA-Za-z]+ [А-Яа-яA-Za-z]+$')
              .hasMatch(t),
    );
    _validateField(
      widget.numberController,
      (c) => phoneBorderColor = c,
      validator: (t) => RegExp(r'^\d{7,15}$').hasMatch(t),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(29, 15, 17, 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: const Color(0xffB3B3B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Личные данные',
            style: TextStyle(
              color: Color(0xff5CA2C8),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: fioBorderColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: widget.nameController,
                        cursorColor: Colors.black,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: 'ФИО',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                        ),
                        onChanged: (val) => _validateField(
                            widget.nameController, (c) => fioBorderColor = c,
                            validator: (t) {
                          final isValid = RegExp(
                                  r'^[А-Яа-яA-Za-z]+ [А-Яа-яA-Za-z]+ [А-Яа-яA-Za-z]+$')
                              .hasMatch(t);
                          fio = isValid;
                          widget.onValidate?.call(
                              dateBordern,
                              addressBordern,
                              serialBordern,
                              numberBordern,
                              placeBordern,
                              dataBordern,
                              fio,
                              phone);
                          return isValid;
                        }),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
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
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: phoneBorderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: widget.numberController,
              keyboardType: TextInputType.phone,
              /*inputFormatters: [
                MaskTextInputFormatter(
                  mask: '### ### ## ##',
                  filter: {"#": RegExp(r'[0-9]')},
                  type: MaskAutoCompletionType.lazy,
                ),
              ],*/
              decoration: InputDecoration(
                hintText: 'Номер телефона',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                prefixIcon: IntrinsicWidth(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CountryCodePicker(
                        onChanged: (code) => setState(() {
                          countryCode = code.dialCode!;
                        }),
                        padding: EdgeInsets.zero,
                        showFlag: false,
                        showFlagDialog: false,
                        initialSelection: 'RU',
                        favorite: const ['+39', 'FR'],
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onChanged: (val) => _validateField(
                  widget.numberController, (c) => phoneBorderColor = c,
                  validator: (t) {
                final isValid = RegExp(r'^\d{7,15}$').hasMatch(t);
                phone = isValid;
                widget.onValidate?.call(
                    dateBordern,
                    addressBordern,
                    serialBordern,
                    numberBordern,
                    placeBordern,
                    dataBordern,
                    fio,
                    phone);
                return isValid;
              }),
            ),
          ),

          // CustomTextField(
          //   controller: widget.numberController,
          //   hintText: 'Номер телефона',
          //   color: Colors.black,
          //   keyboardType: TextInputType.number,
          // ),
          if (isVisibality)
            PersonalInfoAboutWidget(
              countryAndAddres: widget.countryAndAddresController,
              date: widget.dateController,
              serial: widget.passportSerialController,
              number: widget.passportNumberController,
              place: widget.passportPlaceController,
              data: widget.passportDataController,
              onValidate: (dateBorder, addressBorder, serialBorder,
                  numberBorder, placeBorder, dataBorder) {
                setState(() {
                  dateBordern = dateBorder;
                  addressBordern = addressBorder;
                  serialBordern = serialBorder;
                  numberBordern = numberBorder;
                  placeBordern = placeBorder;
                  dateBordern = dataBorder;
                });
                widget.onValidate?.call(
                    dateBordern,
                    addressBordern,
                    serialBordern,
                    numberBordern,
                    placeBordern,
                    dataBordern,
                    fio,
                    phone);
              },
            ),
          if (isVisibality)
            FilesZone(
                files: widget.createMode ? [] : widget.files,
                onChange: (files) {
                  setState(() {
                    selectedFiles = files;
                    widget.onChange(files);
                  });
                }),
          if (isVisibality && !widget.createMode)
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
      ),
    );
  }
}
