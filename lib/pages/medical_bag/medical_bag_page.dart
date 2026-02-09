import 'package:careme24/api/api.dart';
import 'package:careme24/models/contacts/contacts_model.dart';
import 'package:careme24/pages/medical_bag/create_aid_kit.dart';
import 'package:careme24/pages/medical_bag/cubit/aid_kit_cubit.dart';
import 'package:careme24/pages/medical_bag/cubit/aid_kit_state.dart';
import 'package:careme24/pages/medical_bag/medicina_list_scree.dart';
import 'package:careme24/pages/medical_bag/models/aid_kit_model.dart';
import 'package:careme24/pages/medical_bag/ped_card_page.dart';
import 'package:careme24/pages/medical_bag/update_aid_kit.dart';
import 'package:careme24/repositories/contacts_repository.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicalBagPage extends StatefulWidget {
  final bool? dear;
  final String? id;
  const MedicalBagPage({super.key, this.dear, this.id});

  @override
  State<MedicalBagPage> createState() => _MedicalBagPageState();
}

class _MedicalBagPageState extends State<MedicalBagPage> {
  List<dynamic> contacts = [];
  List<AidKitModel> aidKitListUser = [];

  @override
  void initState() {
    super.initState();
    widget.dear == true ? getAidKitListUser() : ();
    _loadData();
  }

  Future<void> _loadData() async {
    final allContacts = await Api.loadFriends();
    final loadedContacts =
        allContacts.where((c) => c["admin"] == true).toList();

    setState(() {
      contacts = loadedContacts;
    });

    context.read<AidKitCubit>().getAidKit();
  }

  Future<void> getAidKitListUser() async {
    final kitList = await Api.getAidKitUser(widget.id!);
    setState(() {
      aidKitListUser = kitList;
    });
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
          text:
              widget.dear != true ? "Домашняя аптечка" : "Аптечка родственника",
        ),
        styleType: Style.bgFillBlue60001,
        actions: [
          Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MedicineBagAddScreen(
                              dear: widget.dear ?? false,
                              userid: widget.id,
                            )),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      'assets/images/add_image.png',
                    ),
                  ),
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<AidKitCubit, AidKitState>(builder: (context, state) {
          if (state is AidKitLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AidKitError) {
            return Center(child: Text(state.message));
          } else if (state is AidKitLoaded) {
            final aidKitList =
                widget.dear != true ? state.aidKits : aidKitListUser;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle(
                  title: widget.dear != true
                      ? "МОЯ АПТЕЧКА"
                      : aidKitListUser.isEmpty
                          ? ""
                          : 'АПТЕЧКА РОДСТВЕННИКА',
                ),
                const SizedBox(height: 8),
                widget.dear == true && aidKitListUser.isEmpty
                    ? const Center(child: Text('Нет доступных данных'))
                    : SizedBox(
                        height: widget.dear != true
                            ? MediaQuery.of(context).size.height * 0.25
                            : MediaQuery.of(context).size.height * 0.5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: aidKitList.length,
                          itemBuilder: (context, index) {
                            final aidKit = aidKitList[index];
                            return MedicineBoxCard(
                              icon: aidKit.photo,
                              title: aidKit.title,
                              id: aidKit.id,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicineListScreen(
                                      title: aidKit.title,
                                      id: aidKit.id,
                                      photo: aidKit.photo,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                if (widget.dear != true) const SizedBox(height: 8),
                const SectionTitle(title: 'АПТЕЧКИ РОДНЫХ'),
                const SizedBox(height: 8),
                widget.dear != true
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            final contact = contacts[index];
                            return ContactCard(
                              icon: contact['other_profile']?['profile']
                                      ?['personal_info']?['avatar'] ??
                                  '',
                              title: contact['name'],
                              id: contact['other_profile']['id'],
                              phone: contact['other_profile']?['profile']
                                          ?['personal_info']?['phone']
                                      .toString() ??
                                  '',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicalBagPage(
                                      dear: true,
                                      id: contact['other_profile']['id'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Center(
                          child: Text('data'),
                        )),
              ],
            );
          } else {
            return const Center(child: Text('Нет доступных данных'));
          }
        }),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
    );
  }
}

class MedicineBoxCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  final String id;

  const MedicineBoxCard({
    super.key,
    required this.icon,
    required this.title,
    required this.id,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          onLongPress: () {
            _showOptions(context);
          },
          child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 72,
                child: Row(
                  children: [
                    CustomImageView(
                      url: icon,
                      height: 40,
                      width: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(title,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ))),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Изменить'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicineBagUpdateScreen(
                        id: id,
                        title: title,
                        image: icon,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Удалить'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  context.read<AidKitCubit>().deletAidKit(id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ContactCard extends StatelessWidget {
  final String icon;
  final String title;
  final String phone;
  final String id;
  final VoidCallback onTap;

  const ContactCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.phone,
    required this.id,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      icon,
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios,
                      size: 18, color: Colors.grey),
                ],
              ),
            ),
          )),
    );
  }
}

class AddButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AddButton({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// const SectionTitle(title: 'ЗАПРОСЫ'),
// const SizedBox(height: 8),
// AddButton(
//   title: 'Добавить запрос',
//   onTap: () {
//       Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => MedicineListScreen(title: "")),
// );
// Handle "Добавить запрос" button
//   },
// ),
// const SizedBox(height: 24),
// const SectionTitle(title: 'ДОПОЛНИТЕЛЬНО'),
// const SizedBox(height: 8),
// AddButton(
//   title: 'Добавить',
//   onTap: () {
//       Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => MedicineListScreen(title: "title")),
// );
// Handle "Добавить" button
//   },
// ),
