import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/models/contacts/contacts_model.dart';
import 'package:careme24/service/url_service.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/contact_page_widget/contact_func_box.dart';
import 'package:careme24/widgets/contact_page_widget/contact_info_box.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_bar/custom_app_bar.dart';

class ContactPage extends StatefulWidget {
  const ContactPage(
      {super.key, required this.contact, this.onlyDelete = false});

  final ContactModel contact;
  final bool onlyDelete;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  bool isAdmin = false;
  bool isActive = false;
  @override
  void initState() {
    isAdmin = widget.contact.admin;
    isActive = widget.contact.enable;
    super.initState();
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
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(23, 0, 23, 0),
        height: double.maxFinite,
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: widget.contact.user.personalInfo.avatar == ''
                      ? Container(
                          height: 143,
                          width: 143,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.person,
                            size: 50,
                          ),
                        )
                      : Image.network(
                          height: 143,
                          width: 143,
                          widget.contact.user.personalInfo.avatar,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ContactInfoBox(
                  name: widget.contact.user.personalInfo.full_name,
                  phoneNumber: '${widget.contact.phone}',
                  address: widget.contact.user.personalInfo.address != ''
                      ? widget.contact.user.personalInfo.address
                      : 'Нет данных'),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  if (!widget.onlyDelete)
                    ContactFuncBox(
                      onTap: () {
                        setState(() {
                          Map<String, dynamic> data = {"admin": !isAdmin};
                          AppBloc.contactsCubit
                              .updataContact(widget.contact.id, data);
                          isAdmin = !isAdmin;
                        });
                      },
                      color: const Color(0xff2C3E4F),
                      imagePath: isAdmin
                          ? 'assets/images/admin.svg'
                          : 'assets/images/no_admin.svg',
                      title: isAdmin ? 'Aдмин' : 'Не админ',
                    ),
                  if (!widget.onlyDelete)
                    ContactFuncBox(
                      onTap: () {
                        setState(() {
                          Map<String, dynamic> data = {"enabled": !isActive};
                          AppBloc.contactsCubit
                              .updataContact(widget.contact.id, data);
                          isActive = !isActive;
                        });
                      },
                      isIcon: true,
                      icon: isActive ? Icons.play_arrow : Icons.pause,
                      color: const Color(0xff57738D),
                      imagePath: 'assets/images/Frame 8071.png',
                      title: isActive ? 'Вкл.' : 'Выкл.',
                    ),
                  ContactFuncBox(
                    onTap: () async {
                      bool isSecces = await AppBloc.contactsCubit
                          .deleteContact(widget.contact.id);
                      if (isSecces) {
                        AppBloc.contactsCubit.fetchData();
                        Navigator.pop(context);
                      }
                    },
                    color: const Color(0xff8E969B),
                    imagePath: 'assets/images/basket.svg',
                    title: 'Удалить',
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              if (!widget.onlyDelete)
                Row(
                  children: [
                    ContactFuncBox(
                      onTap: () {
                        UrlService.launchPhoneDialer(
                            widget.contact.phone.toString());
                      },
                      color: const Color(0xff4380E9),
                      imagePath: ImageConstant.phone,
                      title: 'Звонок',
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
