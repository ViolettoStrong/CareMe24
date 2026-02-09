import 'package:careme24/models/request_model.dart';
import 'package:careme24/pages/contact_help_info.dart';
import 'package:careme24/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotificationCardWidget extends StatelessWidget {
  final RequestModel notification;
  final Function()? onClose;
  const NotificationCardWidget({
    super.key,
    required this.notification,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Text(
                    notification.fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              maskPhoneNum(notification.phone),
              style: const TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 8),
            if (notification.detail.isNotEmpty)
              Text(
                notification.detail,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 10),

            SvgPicture.asset(
              'assets/icons/${notification.type}.svg',
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.notifications,
                  color: Colors.blue,
                  size: 40,
                );
              },
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ContactHelpInfo(request: notification),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: const Text(
                  'Перейти',
                ),
              ),
            ),

            // if (notification.comment.isNotEmpty) ...[
            //   const SizedBox(height: 10),
            //   const Text(
            //     'Комментарий:',
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            //   Text(notification.comment),
            // ],
          ],
        ),
      ),
    );
  }
}
