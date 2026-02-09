// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:careme24/pages/medical_bag/widgets/custom_gradient_button.dart';
import 'package:careme24/pages/medical_bag/widgets/custom_text_field_dialog.dart';
import 'package:careme24/pages/medicines/cubit/in_take_state.dart';
import 'package:careme24/pages/medicines/cubit/intake_cubit.dart';
import 'package:careme24/pages/medicines/cubit/medicines_cubit.dart';
import 'package:careme24/pages/medicines/cubit/medicines_state.dart';
import 'package:careme24/pages/medicines/model/owner_id_model.dart';
import 'package:careme24/pages/medicines/widgets/alarm_dialog.dart';
import 'package:careme24/utils/helper_utils.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class MonthDaysSelector extends StatefulWidget {
  const MonthDaysSelector({super.key});

  @override
  MonthDaysSelectorState createState() => MonthDaysSelectorState();
}

class MonthDaysSelectorState extends State<MonthDaysSelector> {
  int? selectedIndex;
  List<DateTime> dates = [];
  String currentMonth = "";

  @override
  void initState() {
    super.initState();
    generateDaysList();
    context.read<MedicineCubit>().getMedicines();
    String day = DateFormat('d').format(dates[0]);
    selectedIndex = 0;
    context.read<InTakeTimeCubit>().getInTakeTimeMed(day);
  }

  void generateDaysList() {
    DateTime now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      dates.add(now.add(Duration(days: i)));
    }
    currentMonth = DateFormat('MMMM', 'ru').format(dates.first);
  }

  void updateMonth(int index) {
    String newMonth = DateFormat('MMMM', 'ru').format(dates[index]);
    if (newMonth != currentMonth) {
      setState(() {
        currentMonth = newMonth;
      });
    }
  }

  String id_aifkit = '';

  List<MedicineItem> medicines = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: getVerticalSize(48),
        leadingWidth: 43,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: AppbarTitle(
          text: "Прием лекарств",
        ),
        styleType: Style.bgFillBlue60001,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    currentMonth,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 10),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            updateMonth(index);
                            String day = DateFormat('d').format(dates[index]);
                            log(day);

                            context
                                .read<InTakeTimeCubit>()
                                .getInTakeTimeMed(day);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              color: selectedIndex == index
                                  ? Colors.blue
                                  : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                DateFormat('d').format(dates[index]),
                                style: TextStyle(
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey, width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Лекарства',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            fontFamily: "Montserrat",
                            color: Colors.blue),
                      ),
                      BlocBuilder<InTakeTimeCubit, InTakeMedicinesState>(
                          builder: (context, state) {
                        if (state is InTakeMedicinesLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is InTakeMedicinesLoaded) {
                          final time = state.aidKits;
                          return Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlarmDialog(
                                        id: time[0].id,
                                        uId: convertStringId(time[0].id),
                                        medicine: medicines,
                                        day: DateFormat('d')
                                            .format(dates[selectedIndex!]),
                                        time: time[0].time,
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icons/time.svg"),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              time[0].time,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  fontFamily: "Montserrat",
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ])),
                              ));
                        } else {
                          return Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlarmDialog(
                                        id: "",
                                        uId: 1,
                                        medicine: medicines,
                                        day: DateFormat('d')
                                            .format(dates[selectedIndex!]),
                                        time: '0 : 0',
                                      );
                                    },
                                  );
                                },
                                child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icons/time.svg"),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                              '0 : 0',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                  fontFamily: "Montserrat",
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ])),
                              ));
                        }
                      }),
                      BlocBuilder<MedicineCubit, MedicinesState>(
                          builder: (context, state) {
                        if (state is MedicinesLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is MedicinesError) {
                          return Center(child: Text(state.message));
                        } else if (state is MedicinesGetLoaded) {
                          final medicineList = state.aidKits;
                          medicines.clear();
                          medicines.addAll(medicineList);
                          return ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 0),
                            itemCount: medicineList.length,
                            itemBuilder: (context, index) {
                              id_aifkit = medicineList[index].aidKitId;
                              return Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AddMedicineMedicinesDialogEdit(
                                                medicineName:
                                                    medicineList[index].title,
                                                dosage: medicineList[index]
                                                    .count
                                                    .toString(),
                                                id: medicineList[index].id,
                                                aid_kit_id: medicineList[index]
                                                    .aidKitId,
                                                date: medicineList[index]
                                                    .expirationDate
                                                    .toString()),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            medicineList[index].title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: Colors.black),
                                          ),
                                          Text(
                                            medicineList[index]
                                                .count
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                fontFamily: "Montserrat",
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('Нет доступных данных'));
                        }
                      }),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              size: 24,
                            ),
                            Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AddMedicineDialog(
                                          id: id_aifkit,
                                        );
                                      },
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      'Добавить',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          fontFamily: "Montserrat",
                                          color: Colors.black),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AddMedicineMedicinesDialogEdit extends StatelessWidget {
  final String medicineName;
  final String dosage;
  final String id;
  final String aid_kit_id;
  final String date;

  AddMedicineMedicinesDialogEdit({
    required this.medicineName,
    required this.dosage,
    required this.id,
    required this.aid_kit_id,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: medicineName);
    TextEditingController dosageController =
        TextEditingController(text: dosage);

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: SizedBox(
        height: 310,
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            size: 34,
                          ))),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Редактировать лекарства',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: CustomTextFieldDialog(
                controller: nameController,
                hintText: 'Наименование',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomTextFieldDialog(
                controller: dosageController,
                hintText: 'Дозировка',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: BlocConsumer<MedicineCubit, MedicinesState>(
                  listener: (context, state) {
                if (state is MedicinesUpdated) {
                  ElegantNotification.success(description: Text(state.detail))
                      .show(context);
                  Navigator.pop(context);
                } else if (state is MedicinesError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              }, builder: (context, state) {
                return CustomGradientButton(
                  text: 'Изменить',
                  onPressed: () {
                    context.read<MedicineCubit>().updateMedicinesGet(
                        id,
                        nameController.text,
                        date,
                        dosageController.text,
                        aid_kit_id);
                    Navigator.pop(context);
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: BlocConsumer<MedicineCubit, MedicinesState>(
                  listener: (context, state) {
                if (state is MedicinesDeleted) {
                  ElegantNotification.success(description: Text(state.detail))
                      .show(context);
                  //
                } else if (state is MedicinesError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              }, builder: (context, state) {
                return CustomGradientRedButton(
                  text: 'Удалить',
                  onPressed: () {
                    context.read<MedicineCubit>().deletMedicinesGet(id);
                    Navigator.pop(context);
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

class AddMedicineDialog extends StatefulWidget {
  final String id;

  const AddMedicineDialog({required this.id, super.key});

  @override
  State<AddMedicineDialog> createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    expirationController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to today
      firstDate: DateTime(2000), // Start year
      lastDate: DateTime(2100), // End year
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        expirationController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: SizedBox(
        height: 300,
        width: MediaQuery.of(context).size.width - 20,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            size: 34,
                          ))),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Введите лекарства',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontFamily: "Montserrat",
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: CustomTextFieldDialog(
                hintText: 'Наименование',
                controller: nameController,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () =>
                        _selectDate(context), // Open date picker on tap
                    child: AbsorbPointer(
                      child: CustomTextFieldDialog(
                        hintText: 'Срок годности',
                        controller: expirationController,
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomTextFieldDialog(
                hintText: 'Количество',
                controller: quantityController,
              ),
            ),
            const SizedBox(height: 10),
            BlocConsumer<MedicineCubit, MedicinesState>(
              listener: (context, state) {
                if (state is MedicinesCreated) {
                  ElegantNotification.success(description: Text(state.detail))
                      .show(context);
                } else if (state is MedicinesError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              builder: (context, state) {
                return CustomGradientButton(
                  text:
                      state is MedicinesLoading ? 'Добавление...' : 'Добавить',
                  onPressed: () {
                    context.read<MedicineCubit>().createMedicinesGet(
                          nameController.text,
                          expirationController.text,
                          quantityController.text,
                          widget.id,
                        );
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
