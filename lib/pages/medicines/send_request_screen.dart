import 'package:careme24/pages/medical_bag/cubit/aid_kit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/medcard/medcard_cubit.dart';
import 'package:careme24/blocs/medcard/medcard_state.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendRequestAidKid extends StatefulWidget {
  const SendRequestAidKid({Key? key}) : super(key: key);

  @override
  _SendRequestAidKidState createState() => _SendRequestAidKidState();
}

class _SendRequestAidKidState extends State<SendRequestAidKid> {
  final TextEditingController _searchController = TextEditingController();
  List<MedcardModel> _filteredContacts = [];
  List<MedcardModel> _allContacts = [];

  @override
  void initState() {
    super.initState();
    AppBloc.medCardCubit.fetchData();

    _searchController.addListener(_filterContacts);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filterContacts(); // Ensure filtering applies when dependencies change
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    if (mounted) {
      setState(() {
        _filteredContacts = _allContacts.where((contact) {
          return contact.personalInfo.full_name.toLowerCase().contains(query) ||
              contact.personalInfo.phone.toString().contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedCardCubit, MedCardState>(
      builder: (context, state) {
        if (state is MedCardLoading) {
          return _buildLoading();
        } else if (state is MedCardLoaded) {
          _allContacts = state.otherCards;
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => _filterContacts()); // Fixes the setState error
          return _buildContactList();
        }
        return _buildEmpty();
      },
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: Text("Нет данных")),
    );
  }

  Widget _buildContactList() {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Мои администраторы",
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            /// Search field
            Container(
              height: 40,
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: "Поиск...",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Contacts list
            _filteredContacts.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      MedcardModel contact = _filteredContacts[index];
                      return Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {},
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: contact
                                        .personalInfo.avatar.isNotEmpty
                                    ? NetworkImage(contact.personalInfo.avatar)
                                    : null,
                                child: contact.personalInfo.avatar.isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(
                                contact.personalInfo.full_name,
                                style: const TextStyle(color: Colors.blue),
                              ),
                              subtitle:
                                  Text(contact.personalInfo.phone.toString()),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                context
                                    .read<AidKitCubit>()
                                    .getAidKitUser(contact.id);
                                // Navigator.pop(context, contact);
                              },
                            )),
                      );
                    },
                  )
                : const Center(child: Text("Нет совпадений")),
          ],
        ),
      ),
    );
  }
}
