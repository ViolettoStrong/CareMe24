import 'dart:developer';
import 'package:careme24/blocs/blocs.dart';
import 'package:careme24/models/contacts/contacts_model.dart';
import 'package:careme24/models/status_model.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/contact/calls_swith.dart';
import 'package:careme24/pages/contacts/contact_page.dart';
import 'package:careme24/widgets/contact/contact_widget.dart';
import 'package:careme24/widgets/contact/extrenal_calls_row.dart';
import 'package:careme24/widgets/contact/no_contact_widget.dart';
import 'package:flutter/material.dart';
import 'package:careme24/api/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage> {
  bool fromMe = true;
  late bool authorization;
  bool notifToMe = false;

  @override
  void initState() {
    super.initState();
    final appState = context.read<ApplicationCubit>().state;
    authorization = appState is ApplicationCompleted && appState.isAuthorized;
    AppBloc.contactsCubit.fetchData();
    _loadNotifToMe();
  }

  Future<void> _loadNotifToMe() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        notifToMe = prefs.getBool('pay_switch_value_notif_tome') ?? false;
      });
    }
  }

  Future<void> requestPermission() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      await Permission.contacts.request();
    }
  }

  void addUser() async {
    if (await FlutterContacts.requestPermission()) {
      Contact? contact = await FlutterContacts.openExternalPick();
      if (contact != null && contact.phones.isNotEmpty) {
        String stringPhone = contact.phones.first.number
            .replaceAll('+', '')
            .replaceAll(' ', '')
            .replaceAll('-', '');
        log(contact.phones.first.number);
        Map<String, dynamic> data = {
          "name": contact.displayName,
          "phone": stringPhone,
          "admin": false,
          "enabled": false,
        };

        StatusModel status = await AppBloc.contactsCubit.addContact(data);

        if (!status.isSuccess) {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close),
                          ),
                        )),
                    const Text(
                      'Пользователь не найден',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      } else {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return Container(
              width: double.maxFinite,
              margin: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Пожалуйста, выберите контакт с номером телефона.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          },
        );
      }
    } else {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(right: 24, left: 24, bottom: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Разрешение на доступ к контактам отказано.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      );
    }
  }

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
            text: "Вызов",
          ),
          styleType: Style.bgFillBlue60001,
          actions: [
            Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    addUser();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24.0),
                    child: Image.asset(
                      'assets/images/add_contact.png',
                    ),
                  ),
                )),
          ],
        ),
        body: BlocBuilder<ContactsCubit, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoaded) {
              List<ContactModel> contacts = [];
              List<ContactModel> isAdmin = [];
              List<ContactModel> active = [];
              List<ContactModel> noActive = [];
              List<ContactModel> noVerified = [];

              getContacts() {
                contacts = state.contactsAll;
                isAdmin = contacts
                    .where((contact) =>
                        contact.verified && contact.admin && contact.enable)
                    .toList();
                active = contacts
                    .where((contact) =>
                        contact.verified && !contact.admin && contact.enable)
                    .toList();
                noActive =
                    contacts.where((contact) => !contact.enable).toList();
                noVerified = state.contactsUnverified;
              }

              getContacts(); 

              return SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 23, left: 23),
                        child: authorization
                            ? CallsSwith(
                                onChanged: (callType) {
                                  if (callType == CallType.fromMe) {
                                    setState(() {
                                      fromMe = true;
                                    });
                                  } else {
                                    setState(() {
                                      fromMe = false;
                                    });
                                  }
                                },
                              )
                            : IgnorePointer(
                                ignoring: true,
                                child: CallsSwith(
                                  onChanged: (callType) {
                                    if (callType == CallType.fromMe) {
                                      setState(() {
                                        fromMe = true;
                                      });
                                    } else {
                                      setState(() {
                                        fromMe = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                      ),
                      authorization
                          ? ExtrenalCallsWidget(
                              fromMe: fromMe,
                              onNotifToMeChanged: _loadNotifToMe,
                            )
                          : IgnorePointer(
                              ignoring: true,
                              child: ExtrenalCallsWidget(fromMe: fromMe),
                            ),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 36, bottom: 15, right: 23, left: 23),
                        child: Text(
                          'Запрос на добавление ',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2c3e4f),
                          ),
                        ),
                      ),
                      ...List.generate(noVerified.length, (index) {
                        return ContactWidget(
                          isAdmin: noVerified[index].admin,
                          isActive: noVerified[index].enable,
                          id: noVerified[index].id,
                          imagePath: noVerified[index].user.personalInfo.avatar,
                          userName: noVerified[index].name,
                          phoneNumber: noVerified[index].phone.toString(),
                          onlyDelete: fromMe,
                          verifyButton: true,
                          onVerifyButtonTap: () {
                            AppBloc.contactsCubit
                                .verifyContact(noVerified[index].id);
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactPage(
                                          contact: noVerified[index],
                                          onlyDelete: true,
                                        )));
                          },
                        );
                      }),
                      if (noVerified.isEmpty) const NoContactWidget(),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 36, bottom: 15, right: 23, left: 23),
                        child: Text(
                          'Активные',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2c3e4f),
                          ),
                        ),
                      ),
                      ...List.generate(active.length, (index) {
                        return ContactWidget(
                          isActive: active[index].enable,
                          isAdmin: false,
                          id: active[index].id,
                          imagePath: active[index].user.personalInfo.avatar,
                          userName: active[index].name,
                          phoneNumber: active[index].phone.toString(),
                          showNotificationToggle: true,
                          notifToMe: notifToMe,
                          sendNotifications: active[index].sendNotifications,
                          onNotificationToggle: (value) async {
                            await Api.setContactSendNotifications(
                                active[index].id, value);
                            AppBloc.contactsCubit.fetchData();
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactPage(
                                          contact: active[index],
                                        )));
                          },
                        );
                      }),
                      if (active.isEmpty) const NoContactWidget(),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 36, bottom: 15, right: 23, left: 23),
                        child: Text(
                          'Администраторы',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2c3e4f),
                          ),
                        ),
                      ),
                      ...List.generate(isAdmin.length, (index) {
                        return ContactWidget(
                          isActive: isAdmin[index].enable,
                          isAdmin: true,
                          id: isAdmin[index].id,
                          imagePath: isAdmin[index].user.personalInfo.avatar,
                          userName: isAdmin[index].name,
                          phoneNumber: isAdmin[index].phone.toString(),
                          showNotificationToggle: true,
                          notifToMe: notifToMe,
                          sendNotifications: isAdmin[index].sendNotifications,
                          onNotificationToggle: (value) async {
                            await Api.setContactSendNotifications(
                                isAdmin[index].id, value);
                            AppBloc.contactsCubit.fetchData();
                          },
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactPage(
                                          contact: isAdmin[index],
                                        )));
                          },
                        );
                      }),
                      if (isAdmin.isEmpty) const NoContactWidget(),
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 36, bottom: 15, right: 23, left: 23),
                        child: Text(
                          'Неактивные',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2c3e4f),
                          ),
                        ),
                      ),
                      ...List.generate(noActive.length, (index) {
                        return ContactWidget(
                          id: noActive[index].id,
                          imagePath: noActive[index].user.personalInfo.avatar,
                          userName: noActive[index].name,
                          phoneNumber: noActive[index].phone.toString(),
                          isActive: false,
                          isAdmin: noActive[index].admin,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactPage(
                                          contact: noActive[index],
                                        )));
                          },
                        );
                      }),
                      if (noActive.isEmpty) const NoContactWidget()
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ));
  }
}
