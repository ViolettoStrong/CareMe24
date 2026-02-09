import 'package:careme24/models/contacts/contacts_model.dart';

abstract class ContactsState {}

class ContactsLoading extends ContactsState {}

class ContactsLoaded extends ContactsState {
  final List<ContactModel> contactsAll;
  final List<ContactModel> contactsUnverified;

  ContactsLoaded({
    required this.contactsAll,
    required this.contactsUnverified,
  });
}
