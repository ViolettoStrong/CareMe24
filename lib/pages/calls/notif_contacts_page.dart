import 'package:careme24/blocs/contacts/contacts_cubit.dart';
import 'package:careme24/blocs/contacts/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifiedContactsPage extends StatelessWidget {
  const NotifiedContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Оповещены',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<ContactsCubit, ContactsState>(
        builder: (context, state) {
          if (state is ContactsLoaded) {
            final contacts = state.contactsAll;

            final notified = contacts
                .where((c) =>
                        c.verified &&
                        c.enable &&
                        (c.admin || !c.admin) // ակտիվ բոլորը
                    )
                .toList();

            if (notified.isEmpty) {
              return const Center(
                child: Text('Нет оповещённых'),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notified.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final contact = notified[index];

                return ListTile(
                  leading: Icon(
                    contact.admin ? Icons.security : Icons.person,
                    color: contact.admin ? Colors.red : Colors.blue,
                  ),
                  title: Text(
                    contact.name ?? 'Без имени',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    contact.phone.toString(),
                  ),
                  trailing: const Icon(
                    Icons.notifications_active,
                    color: Colors.green,
                  ),
                );
              },
            );
          }

          if (state is ContactsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(child: Text('Ошибка загрузки'));
        },
      ),
    );
  }
}
