import 'package:careme24/api/api.dart';
import 'package:careme24/models/contacts/contacts_model.dart';
import 'package:careme24/models/status_model.dart';

class ContactsRepository {
  static Future<List<ContactModel>> loadContactsAll() async {
    final response = await Api.loadContactsAll();
    return response;
  }

  static Future<List<ContactModel>> loadContactsUnverified() async {
    final response = await Api.loadContactsUnverified();
    return response;
  }

  static Future<StatusModel> deleteContact(String id) async {
    final StatusModel response = await Api.deleteContact(id);
    return response;
  }

  static Future<StatusModel> verifyContact(String id) async {
    final StatusModel response = await Api.verifyContact(id);
    return response;
  }

  static Future<StatusModel> updateContact(
      String id, Map<String, dynamic> data) async {
    final StatusModel response = await Api.updateContact(id, data);
    return response;
  }

  static Future<StatusModel> addContact(Map<String, dynamic> data) async {
    final StatusModel response = await Api.addContact(data);
    return response;
  }
}
