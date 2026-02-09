import 'dart:developer';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:careme24/pages/medicines/cubit/intake_cubit.dart';
import 'package:careme24/pages/medicines/model/owner_id_model.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class AlarmDialog extends StatefulWidget {
  final List<MedicineItem> medicine;
  final String day;
  final String time;
  final String id;
  final int uId;

  const AlarmDialog({
    super.key,
    required this.medicine,
    required this.day,
    required this.time,
    required this.id,
    required this.uId,
  });
  @override
  AlarmDialogState createState() => AlarmDialogState();
}

class AlarmDialogState extends State<AlarmDialog> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  String selectTime = '';

  // @override
  // void initState() {
  //   super.initState();
  //   // Listen for alarm events
  //   Alarm.ringStream.stream.listen((alarmId) {
  //     _showAlarmDialog();
  //   });
  // }

  void _pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      _setTime(pickedTime);
    }
  }

  _setTime(TimeOfDay time) {
    setState(() {
      _selectedTime = time;
      final now = DateTime.now();
      final selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      if (widget.time != '0 : 0') {
        context.read<InTakeTimeCubit>().updateMedicines(
              widget.id,
              widget.day,
              DateFormat('HH:mm').format(selectedDateTime),
              widget.medicine[0].aidKit.medicines[0].id,
            );
        ElegantNotification.success(
                description: const Text("Время приема обновлено"))
            .show(context);
        Navigator.pop(context);
      } else {
        context.read<InTakeTimeCubit>().createMedicines(
            widget.day,
            DateFormat('HH:mm').format(selectedDateTime),
            widget.medicine[0].aidKit.medicines[0].id);
        ElegantNotification.success(
                description: const Text("Время приема создано"))
            .show(context);
        Navigator.pop(context);
      }
    });
    _scheduleAlarm();
  }

  void _scheduleAlarm() async {
    final now = DateTime.now();
    DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final alarmSettings = AlarmSettings(
      id: widget.uId,
      dateTime: selectedDateTime,
      assetAudioPath: 'assets/alarm_sound.mp3',
      loopAudio: false,
      vibrate: true,
      warningNotificationOnKill: Platform.isIOS,
      androidFullScreenIntent: true,
      notificationSettings: const NotificationSettings(
        title: 'Прием лекарств',
        body: 'Время принять лекарство',
        stopButton: 'СТОП',
        icon: 'notification_icon',
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);

    log('Alarm scheduled');
  }

  void _stopAlarm() {
    Alarm.stop(widget.uId);
    Navigator.pop(context);
  }

  void _snoozeAlarm(Duration dur) {
    Alarm.stop(widget.uId);

    int mins = dur.inMinutes % 60;
    int hours = dur.inMinutes ~/ 60;

    mins = _selectedTime.minute + mins;
    hours = _selectedTime.hour + hours;
    if (mins > 59) {
      mins = mins - 60;
      hours += 1;
    }
    if (hours > 23) {
      hours = 0;
    }
    _selectedTime = TimeOfDay(hour: hours, minute: mins);

    _setTime(_selectedTime);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _pickTime(context),
            child: Text(
              widget.time == '0 : 0' ? '0:0' : widget.time,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          ...List.generate(
            1,
            (index) {
              return Text(widget.medicine.map((e) => e.title).join(', '),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black));
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _stopAlarm,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(50),
              backgroundColor: Colors.redAccent,
            ),
            child: const Center(
              child: Text(
                'СТОП',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => _snoozeAlarm(const Duration(minutes: 30)),
            child: const Text(
              'Отложить на 30 минут',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => _snoozeAlarm(const Duration(minutes: 60)),
            child: const Text(
              'Отложить на час',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          // ElevatedButton(
          //   onPressed: _scheduleAlarm,
          //   child: Text('СТОП',
          //       style: TextStyle(fontSize: 18, color: Colors.white)),
          //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          // ),
          TextButton(
            onPressed: () {
              _stopAlarm();
              context
                  .read<InTakeTimeCubit>()
                  .deletMedicines(widget.id, widget.day);
              ElegantNotification.success(
                      description: const Text('Время приема удалено'))
                  .show(context);
            },
            child: const Text(
              'Отменить прием',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
