import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/medcard/medcard_cubit.dart';
import 'package:careme24/blocs/medcard/medcard_state.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactSelectDialogMed extends StatefulWidget {
  const ContactSelectDialogMed({Key? key}) : super(key: key);

  @override
  _ContactSelectDialogMedState createState() => _ContactSelectDialogMedState();
}

class _ContactSelectDialogMedState extends State<ContactSelectDialogMed> {
  final TextEditingController _searchController = TextEditingController();
  List<MedcardModel> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    AppBloc.medCardCubit.fetchData();
    _filterContacts();
    _searchController.addListener(_filterContacts);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterContacts);
    _searchController.dispose();
    super.dispose();
  }

  void _filterContacts() {
    final state = AppBloc.medCardCubit.state;
    if (state is MedCardLoaded) {
      String query = _searchController.text.toLowerCase();
      setState(() {
        _filteredContacts = state.otherCards
            .where((contact) =>
                contact.personalInfo.full_name.toLowerCase().contains(query) ||
                contact.personalInfo.phone.toString().contains(query))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: BlocBuilder<MedCardCubit, MedCardState>(
        builder: (context, state) {
          if (state is MedCardLoading) {
            return _buildLoading();
          } else {
            if (state is MedCardLoaded) {
              String query = _searchController.text.toLowerCase();
              _filteredContacts = state.otherCards
                  .where((contact) =>
                      contact.personalInfo.full_name
                          .toLowerCase()
                          .contains(query) ||
                      contact.personalInfo.phone.toString().contains(query))
                  .toList();
              return _buildContactList(context, state);
            }
          }
          return _buildEmpty();
        },
      ),
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

  Widget _buildContactList(BuildContext context, MedCardLoaded state) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxHeight: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Close button
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          /// Title
          const Text(
            "Выберите пользователя, которому хотите создать заявку",
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 12),

          /// Search field
          Container(
            height: 40,
            padding: const EdgeInsets.only(left: 10, bottom: 0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(0),
            ),
            child: TextField(
              controller: _searchController,
              maxLines: 1,
              cursorHeight: 20,
              scrollPadding: EdgeInsets.zero,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                isDense: true,
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.zero,
                hintText: "Поиск...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Добавляем пункт "Мне"
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: const Text(
              "Мне",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pop(context, null);
            },
          ),

          const Divider(),

          /// Contacts list
          _filteredContacts.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      MedcardModel contact = _filteredContacts[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              contact.personalInfo.avatar.isNotEmpty
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
                        subtitle: Text(contact.personalInfo.phone.toString()),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pop(context, contact);
                        },
                      );
                    },
                  ),
                )
              : const Center(child: Text("Нет совпадений")),
        ],
      ),
    );
  }
}
