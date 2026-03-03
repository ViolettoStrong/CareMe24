import 'package:careme24/blocs/contacts/contacts_cubit.dart';
import 'package:careme24/blocs/contacts/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotifiedContactsPage extends StatefulWidget {
  const NotifiedContactsPage({super.key});

  @override
  State<NotifiedContactsPage> createState() => _NotifiedContactsPageState();
}

class _NotifiedContactsPageState extends State<NotifiedContactsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ContactsCubit>().fetchData();
  }

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
                final sendNotif = contact.sendNotifications;

                return ListTile(
                  leading: Icon(
                    contact.admin ? Icons.security : Icons.person,
                    color: contact.admin ? Colors.red : Colors.blue,
                  ),
                  title: Text(
                    contact.name.isEmpty ? 'Без имени' : contact.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    contact.phone.toString(),
                  ),
                  trailing: _NotifySwitchDisplay(value: sendNotif),
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


/// Только отображение: «Уведомить» + прямоугольный переключатель по булеву (без обработки нажатия).
class _NotifySwitchDisplay extends StatelessWidget {
  const _NotifySwitchDisplay({required this.value});

  final bool value;

  static const double _width = 48;
  static const double _height = 26;
  static const double _radius = 5;
  static const Color _activeColor = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Уведомить',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: value ? _activeColor : const Color(0xff8E969B),
          ),
        ),
        const SizedBox(height: 4),
        Container(
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
              child: Container(
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
      ],
    );
  }
}
