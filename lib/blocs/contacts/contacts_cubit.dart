import 'dart:developer';

import 'package:careme24/blocs/contacts/contacts_state.dart';
import 'package:careme24/models/contacts/contacts_model.dart';
import 'package:careme24/models/status_model.dart';
import 'package:careme24/repositories/contacts_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(ContactsLoading());

  Future<void> fetchData() async {
    emit(ContactsLoading());

    final List<ContactModel> contactsUnverified =
        await ContactsRepository.loadContactsUnverified();
    final List<ContactModel> contacts =
        await ContactsRepository.loadContactsAll();

    emit(ContactsLoaded(
        contactsAll: contacts, contactsUnverified: contactsUnverified));
  }

  Future<bool> deleteContact(String id) async {
    final StatusModel response = await ContactsRepository.deleteContact(id);
    if (response.isSuccess) {
      fetchData();
    }
    return response.isSuccess;
  }

  Future verifyContact(String id) async {
    final StatusModel response = await ContactsRepository.verifyContact(id);
    if (response.isSuccess) {
      fetchData();
    }
  }

  Future updataContact(String id, Map<String, dynamic> data) async {
    final StatusModel response =
        await ContactsRepository.updateContact(id, data);
    if (response.isSuccess) {
      fetchData();
    }
  }

  Future<StatusModel> addContact(Map<String, dynamic> data) async {
    final StatusModel response = await ContactsRepository.addContact(data);
    log('${response.isSuccess}');
    if (response.isSuccess) {
      fetchData();
      return response;
    } else {
      return response;
    }
  }
}
