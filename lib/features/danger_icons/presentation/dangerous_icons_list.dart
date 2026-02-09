import 'package:careme24/features/danger_icons/controller/danger_icons_ctrl.dart';
import 'package:careme24/injection_container.dart';
import 'package:flutter/material.dart';

class DangerousIconsList extends StatefulWidget {
  const DangerousIconsList({
    super.key,
    required this.isGeoEnable,
  });

  final bool isGeoEnable;

  @override
  DangerousIconsListState createState() => DangerousIconsListState();
}

class DangerousIconsListState extends State<DangerousIconsList> {
  DangerIconsCtrl dangerIconsCtrl = getIt<DangerIconsCtrl>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: dangerIconsCtrl,
        builder: (context, _) {
          print(dangerIconsCtrl.iconsData.length);
          return SizedBox(
            height: 131,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dangerIconsCtrl.iconsData.length,
              itemBuilder: (context, index) {
                return dangerIconsCtrl.iconsData[index]['widget'];
              },
            ),
          );
        });
  }
}
