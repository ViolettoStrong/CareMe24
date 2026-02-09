import 'package:careme24/api/api.dart';
import 'package:careme24/features/chat/presentation/chat_page.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentListPage extends StatelessWidget {
  final String type;
  final bool finalPage;
  const AppointmentListPage(
      {super.key, required this.type, this.finalPage = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppbarTitle(
          text: type == 'med' ? 'Записи на приём' : 'История заявок',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (finalPage) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: type == 'pol' || type == 'mch'
            ? Api.getStatments(type)
            : Api.getAppointments(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('Нет записей на приём'));
          }
          data.sort((a, b) {
            try {
              if (type == 'pol' || type == 'mch') {
                final dateA = DateTime.parse(a['created_at']).toLocal();
                final dateB = DateTime.parse(b['created_at']).toLocal();
                return dateB.compareTo(dateA);
              } else {
                final dateA = DateTime.parse(a['appointment_time']).toLocal();
                final dateB = DateTime.parse(b['appointment_time']).toLocal();
                return dateB.compareTo(dateA);
              }
            } catch (_) {
              return 0;
            }
          });

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final service = item['service'];
              final doctorName = service?['name'] ?? 'Без имени';
              final photoUrl = service?['photo'];
              final appointmentTime = item['appointment_time'] ?? '';
              final address = service?['work_place'] ?? 'Адрес не указан';
              final createdAt = DateTime.parse(item['created_at']);
              final registerDate =
                  DateFormat('dd.MM.yyyy HH:mm').format(createdAt);

              String dateStr = '';
              String timeStr = '';
              try {
                final dateTime = DateTime.parse(appointmentTime).toLocal();
                dateStr = DateFormat('dd.MM.yyyy', 'ru').format(dateTime);
                timeStr = DateFormat('HH:mm', 'ru').format(dateTime);
              } catch (_) {}

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: photoUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photoUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.person, size: 50),
                  title: Text(
                    'Запись к $doctorName',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    type == 'pol' || type == 'mch'
                        ? "Дата регистрации: $registerDate\nАдрес: $address"
                        : "Дата: $dateStr\nВремя: $timeStr\nАдрес: $address",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
