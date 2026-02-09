import 'dart:developer';
import 'dart:io';

import 'package:careme24/api/api.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/pages/calls/notif_contacts_page.dart';
import 'package:careme24/pages/calls/sos_button.dart';
import 'package:careme24/pages/home/main_page.dart';
import 'package:careme24/pages/tracking_screen/tracking_screen.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';

class MainCallPage extends StatefulWidget {
  const MainCallPage({
    super.key,
    required this.text,
    required this.requestId,
    required this.show,
    required this.type,
    this.latestCalls,
  });

  final String text;
  final String requestId;
  final bool show;
  final String type;
  final dynamic latestCalls;

  @override
  State<MainCallPage> createState() => _MainCallPageState();
}

bool show = false;
bool sos = false;

final ImagePicker _imagePicker = ImagePicker();
File? videoFile;

class _MainCallPageState extends State<MainCallPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Future uploadVideo() async {
    try {
      final pickedFile =
          await _imagePicker.pickVideo(source: ImageSource.camera);
      if (pickedFile == null) {
        return;
      }
      videoFile = File(pickedFile.path);
    } catch (e) {
      log('Ошибка при выборе видео: $e');
    }
  }

  @override
  void initState() {
    show = widget.show;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          height: getVerticalSize(48),
          leadingWidth: 43,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => {
                      Navigator.pushReplacementNamed(
                          context, AppRouter.appContainer)
                    }),
          ),
          centerTitle: true,
          title: AppbarTitle(text: widget.text),
          styleType: Style.bgFillBlue60001),
      body: Column(
        children: [
          SizedBox(height: 7),
          Padding(
              padding: const EdgeInsets.all(18),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      final response = await AppBloc.requestCubit
                          .deleteRequest(widget.requestId);
                      if (response.isSuccess) {
                        ElegantNotification.success(
                                description: const Text('Заявка отменена'))
                            .show(context);
                        Navigator.pushReplacementNamed(
                            context, AppRouter.appContainer);
                      } else {}
                    },
                    child: const Text(
                      'Отмена вызова',
                      style: TextStyle(
                          color: Color.fromRGBO(255, 0, 0, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    )),
              )),
          const Divider(
            height: 1,
            color: Color.fromRGBO(221, 222, 226, 1),
          ),
          const SizedBox(height: 11),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    widget.latestCalls.values.first['car'] != null
                        ? getText('car')
                        : widget.latestCalls.values.first['group'] != null
                            ? getText(widget.type)
                            : 'Вызов отправлен',
                    style: const TextStyle(
                        color: Color.fromRGBO(51, 132, 226, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Color.fromRGBO(221, 222, 226, 1),
                ),
                Padding(
                    padding: EdgeInsets.all(18),
                    child: widget.latestCalls.values.first['group'] != null ||
                            widget.latestCalls.values.first['car'] != null
                        ? Text(
                            'Время ожидания 10 минут',
                            style: TextStyle(
                                color: Color.fromRGBO(44, 62, 79, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )
                        : Center(
                            child: Text(
                              'Вызов ожидает подтверждения',
                              style: TextStyle(
                                  color: Color.fromRGBO(44, 62, 79, 1),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (!sos) {
                          await _audioPlayer.setReleaseMode(ReleaseMode.loop);
                          await _audioPlayer.play(AssetSource('sos_media.mp3'));
                        } else {
                          await _audioPlayer.stop();
                        }

                        final response = await AppBloc.requestCubit
                            .updateRequest(widget.requestId, {
                          "important": !sos,
                          "creation_date_user": DateTime.now(),
                        });

                        if (response.isSuccess) {
                          setState(() {
                            sos = !sos;
                          });
                        }
                      },
                      child: SosPulsingButton(
                        isActive: sos,
                        size: 80,
                      ),
                    )),
                const SizedBox(height: 14),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 33,
                  ),
                  child: Text(
                      'Нажмите для срочной помощи\nподготовленных людей',
                      style: TextStyle(
                          color: Color.fromRGBO(219, 19, 91, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          if (show)
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotifiedContactsPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/info.svg'),
                        const SizedBox(
                          width: 12,
                        ),
                        const Text('Родственники оповещены',
                            style: TextStyle(
                                color: Color.fromRGBO(44, 62, 79, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        const Spacer(),
                        Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () {
                                  setState(() {
                                    show = false;
                                  });
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/close.svg'))),
                      ],
                    ),
                  ),
                )),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 50, left: 50, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Подтверждение действия'),
                            content: Text(
                              'Вы уверены, что хотите отменить заявку в институт и отправить запрос ближайшей спецмашине (такси)?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Нет'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text('Да'),
                              ),
                            ],
                          ),
                        );

                        if (confirm != true) return;

                        final requestId = widget.requestId;

                        try {
                          /*final response = await AppBloc.requestCubit
                            .deleteRequest(requestId);*/
                          if (true) {
                            if (widget.latestCalls.values.first['car'] !=
                                null) {
                              ElegantNotification.info(
                                title: Text('Спецмашита в пути'),
                                description: Text('Ждите на месте'),
                              ).show(context);
                            } else {
                              await Api.callCar(requestId);

                              ElegantNotification.success(
                                title: Text('Успешно'),
                                description: Text('Заявка передана спецмашине'),
                              ).show(context);
                              await Future.delayed(
                                  const Duration(milliseconds: 2500));
                            }
                            /*Navigator.pushNamedAndRemoveUntil(
  context,
  AppRouter.appContainer,
  (route) => false,
);*/
                          }
                          /* */
                        } catch (e) {
                          ElegantNotification.error(
                            title: Text('Ошибка'),
                            description: Text('Произошла ошибка: $e'),
                          ).show(context);
                        }
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/taxi.svg',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Такси',
                      style: TextStyle(
                          color: Color.fromRGBO(142, 150, 155, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        await uploadVideo();
                        if (videoFile != null) {
                          final response = await AppBloc.requestCubit
                              .updateRequest(widget.requestId, {
                            "video":
                                await MultipartFile.fromFile(videoFile!.path),
                            "creation_date_user": DateTime.now(),
                          });
                          if (response.isSuccess) {
                            ElegantNotification.success(
                                    description: const Text(
                                        'Видео отправлено на сервер'))
                                .show(context);
                          } else {
                            ElegantNotification.error(
                                    description: const Text(
                                        'не удалось отправить видео на сервер'))
                                .show(context);
                          }
                        }
                      },
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/video.svg',
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Видео',
                            style: TextStyle(
                                color: Color.fromRGBO(142, 150, 155, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    )),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (widget.latestCalls.values.first['group'] == null &&
                            widget.latestCalls.values.first['car'] == null) {
                          ElegantNotification.error(
                            description: const Text(
                                'Вызов ожидает подтверждения от службы'),
                          ).show(context);
                          return;
                        }
                        final hasCar =
                            widget.latestCalls.values.first['car'] != null;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TrackingScreen(
                                latestCalls: widget.latestCalls!,
                                hasCar: hasCar),
                          ),
                        );
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/map.svg',
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Отследить',
                      style: TextStyle(
                          color: Color.fromRGBO(142, 150, 155, 1),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(colors: [
                  Color.fromRGBO(255, 168, 0, 1),
                  Color.fromRGBO(255, 213, 89, 1),
                ])),
            child: const Center(
              child: Text(
                'Что делать',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }

  String getText(String service) {
    switch (service) {
      case 'med':
        return 'Скорая помощь вызвана';
      case 'pol':
        return 'Полиция вызвана';
      case 'mch':
        return 'МЧС вызвана';
      case 'car':
        return 'Такси вызвана';
      default:
        return 'Неизвестная служба';
    }
  }
}
