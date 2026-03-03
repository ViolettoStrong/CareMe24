import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/service/url_service.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactWidget extends StatelessWidget {
  final String id;
  final String imagePath;
  final String userName;
  final String phoneNumber;
  final bool isAdmin;
  final bool isActive;
  final VoidCallback onTap;
  final bool onlyDelete;
  final bool verifyButton;
  final VoidCallback? onVerifyButtonTap;
  final bool showNotificationToggle;
  final bool notifToMe;
  final bool sendNotifications;
  final Future<void> Function(bool value)? onNotificationToggle;

  const ContactWidget({
    super.key,
    required this.id,
    required this.imagePath,
    required this.userName,
    required this.phoneNumber,
    required this.onTap,
    required this.isActive,
    required this.isAdmin,
    this.onVerifyButtonTap,
    this.onlyDelete = false,
    this.verifyButton = false,
    this.showNotificationToggle = false,
    this.notifToMe = false,
    this.sendNotifications = false,
    this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Slidable(
        startActionPane: !onlyDelete
            ? ActionPane(motion: const BehindMotion(), children: [
                CustomSlidableAction(
                    backgroundColor: ColorConstant.blue4,
                    onPressed: (context) =>
                        UrlService.launchPhoneDialer(phoneNumber),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(ImageConstant.phone),
                        Text('Звонок', style: AppStyle.txtMontserratf12w600),
                      ],
                    )),
              ])
            : null,
        endActionPane: ActionPane(motion: const BehindMotion(), children: [
          if (!onlyDelete)
            CustomSlidableAction(
                backgroundColor: ColorConstant.gray2,
                onPressed: (context) {
                  Map<String, dynamic> data = {"admin": !isAdmin};
                  AppBloc.contactsCubit.updataContact(id, data);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(isAdmin
                        ? 'assets/images/admin.svg'
                        : 'assets/images/no_admin.svg'),
                    Text(isAdmin ? 'Aдмин' : 'Не админ',
                        style: AppStyle.txtMontserratf12w600),
                  ],
                )),
          if (!onlyDelete)
            SlidableAction(
                onPressed: (context) {
                  Map<String, dynamic> data = {"enabled": !isActive};
                  AppBloc.contactsCubit.updataContact(id, data);
                },
                icon: isActive ? Icons.pause : Icons.play_arrow,
                backgroundColor: ColorConstant.gray3,
                label: isActive ? 'Вкл.' : 'Выкл'),
          SlidableAction(
            onPressed: (context) {
              AppBloc.contactsCubit.deleteContact(id);
            },
            icon: Icons.delete,
            backgroundColor: ColorConstant.gray4,
            label: 'Удалить',
          ),
        ]),
        child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.only(left: 23, top: 17, bottom: 17),
                color: Colors.white,
                width: size.width,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: imagePath == ''
                          ? Container(
                              height: 50,
                              width: 50,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.person,
                                size: 24,
                              ),
                            )
                          : Image.network(
                              height: 50,
                              width: 50,
                              imagePath,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2c3e4f),
                          ),
                        ),
                        Text(
                          phoneNumber,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff8E969B),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (showNotificationToggle)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Уведомить',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: (notifToMe && sendNotifications)
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xff8E969B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            _RectangularNotificationSwitch(
                              value: notifToMe && sendNotifications,
                              onTap: () async {
                                if (!notifToMe) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Включите главный переключатель уведомлений',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final newValue = !(notifToMe && sendNotifications);
                                await onNotificationToggle?.call(newValue);
                              },
                            ),
                          ],
                        ),
                      ),
                    if (verifyButton)
                      Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: onVerifyButtonTap,
                            child: Container(
                              margin: const EdgeInsets.only(right: 24),
                              padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromRGBO(41, 142, 235, 1),
                                    Color.fromRGBO(65, 73, 255, 1)
                                  ])),
                              child: const Text(
                                'Подтвердить',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ))
                  ],
                ),
              ),
            )));
  }
}

class _RectangularNotificationSwitch extends StatelessWidget {
  const _RectangularNotificationSwitch({
    required this.value,
    required this.onTap,
  });

  final bool value;
  final VoidCallback onTap;

  static const double _width = 48;
  static const double _height = 26;
  static const double _radius = 5;
  static const Color _activeColor = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: _width,
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          color: value ? _activeColor : Colors.grey.shade300,
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
