import 'dart:io';

import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/models/service_model.dart';
import 'package:careme24/pages/med/appointment_page.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/files_zone.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';

class CreateStatementScreen extends StatefulWidget {
  const CreateStatementScreen(
      {super.key,
      required this.reason,
      required this.serviceId,
      required this.serviceModel,
      required this.cardId,
      required this.type});

  final String reason;
  final String serviceId;
  final ServiceModel serviceModel;
  final String cardId;
  final String type;
  @override
  State<CreateStatementScreen> createState() => _CreateStatementScreenState();
}

class _CreateStatementScreenState extends State<CreateStatementScreen> {
  List<File> files = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          title: AppbarTitle(text: 'Заявление'),
          styleType: Style.bgFillBlue60001),
      body: SingleChildScrollView(
          padding: getPadding(top: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Введите текст заявления',
                  border: InputBorder.none,
                ),
                maxLines: 6,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: FilesZone(
                  files: [],
                  onChange: (newFiles) {
                    files = newFiles;
                  }),
            ),
            Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    final String statementText = _controller.text.trim();
                    if (statementText.isEmpty) {
                      ElegantNotification.error(
                              description: const Text(
                                  'Пожалуйста, введите текст заявления'))
                          .show(context);
                    } else {
                      if (widget.cardId == '') {
                        ElegantNotification.error(
                                description: const Text('У вас нет профиля'))
                            .show(context);
                      } else {
                        final response = await AppBloc.requestCubit
                            .createStatement(widget.reason, widget.serviceId,
                                statementText, widget.cardId, files);
                        if (response.isSuccess) {
                          ElegantNotification.success(
                                  description:
                                      const Text('Заявление отправлено'))
                              .show(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentListPage(
                                  finalPage: true, type: widget.type),
                            ),
                          );
                        } else {
                          ElegantNotification.error(
                                  description: const Text(
                                      'Не удалось отправить заявление'))
                              .show(context);
                        }
                      }
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 21, right: 25, top: 95),
                    padding: const EdgeInsets.symmetric(vertical: 19.5),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(41, 142, 235, 1),
                          Color.fromRGBO(65, 73, 255, 1),
                        ])),
                    child: const Center(
                        child: Text('Отправить',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600))),
                  ),
                ))
          ])),
    );
  }
}
