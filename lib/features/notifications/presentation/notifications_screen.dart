import 'package:careme24/features/danger_icons/controller/danger_icons_ctrl.dart';
import 'package:careme24/features/danger_icons/models/danger_model.dart';
import 'package:careme24/features/danger_icons/presentation/widgets/danger_icon_card.dart';
import 'package:careme24/features/notifications/presentation/widgets/notification_card_widget.dart';
import 'package:careme24/features/notifications/notifications_ctrl.dart';
import 'package:careme24/injection_container.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  NotificationsCtrl notificationsCtrl = NotificationsCtrl();
  DangerIconsCtrl dangerIconsCtrl = getIt<DangerIconsCtrl>();

  @override
  void dispose() {
    notificationsCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    notificationsCtrl.fetchNotifications(
        // lastActiveIcons: ['icon1', 'icon2'],
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: getVerticalSize(48),
        leadingWidth: 43,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: AppbarTitle(text: "Уведомления"),
        styleType: Style.bgFillBlue60001,
      ),
      body: ListenableBuilder(
        listenable: notificationsCtrl,
        builder: (context, _) {
          if (notificationsCtrl.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (notificationsCtrl.error != null) {
            return Center(child: Text('Ошибка: ${notificationsCtrl.error}'));
          } else if (notificationsCtrl.notifications.isNotEmpty ||
              dangerIconsCtrl.notifIcons.isNotEmpty) {
            return CustomScrollView(
              slivers: [
                ListenableBuilder(
                  listenable: dangerIconsCtrl,
                  builder: (context, _) {
                    return SliverPadding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 28,
                      ),
                      sliver: SliverList.builder(
                        itemCount: dangerIconsCtrl.notifIcons.length,
                        itemBuilder: (context, index) {
                          DangerModel icon = dangerIconsCtrl.notifIcons[index];
                          return DangerIconCard(
                            icon: icon,
                            onClose: () {
                              dangerIconsCtrl
                                  .removeDangerNotification(icon.incidentType);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  sliver: SliverList.builder(
                    itemCount: notificationsCtrl.notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationCardWidget(
                        notification: notificationsCtrl.notifications[index],
                        onClose: () {
                          notificationsCtrl.closeNotification(
                              e: notificationsCtrl.notifications[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Нет уведомлений'));
        },
      ),
    );
  }
}

// return ListView(
//   padding: const EdgeInsets.all(10),
//   children: notifications.map((notification) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   notification['title'] ?? '',
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 const Icon(Icons.close, color: Colors.grey),
//               ],
//             ),
//             if (notification.containsKey('phone'))
//               Text(notification['phone'],
//                   style: const TextStyle(color: Colors.blue)),
//             const SizedBox(height: 8),
//             if (notification.containsKey('message'))
//               Text(notification['message']),
//             const SizedBox(height: 10),
//             const Icon(Icons.notifications,
//                 color: Colors.blue, size: 40),
//             const SizedBox(height: 10),
//             if (notification.containsKey('danger')) ...[
//               Text(notification['location'],
//                   style: const TextStyle(color: Colors.blue)),
//               const SizedBox(height: 5),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red),
//                 child: Text(notification['danger']),
//               ),
//             ] else ...[
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 10, horizontal: 20),
//                 ),
//                 child: const Text('Перейти'),
//               ),
//             ],
//             if (notification.containsKey('comment')) ...[
//               const SizedBox(height: 10),
//               const Text(
//                 'Комментарий:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(notification['comment']),
//             ],
//           ],
//         ),
//       ),
//     );
//   }).toList(),
// );
