final List<Map<String, String>> dataIcons = [
  {
    "incident_type": "Электромагнитное излучение",
    "danger_level": " ",
  },
  {
    "incident_type": "Радиактивный фон",
    "danger_level": " ",
  },
  {
    "incident_type": "Торнадо смерч",
    "danger_level": " ",
  },
  {
    "incident_type": "Солнечная радиация",
    "danger_level": " ",
  },
  {
    "incident_type": "Пожар",
    "danger_level": " ",
  },
  {
    "incident_type": "Террористическая опасность",
    "danger_level": " ",
  },
  {
    "incident_type": "Воздушная тревога",
    "danger_level": " ",
  },
  {
    "incident_type": "Землятрясение",
    "danger_level": " ",
  },
  {
    "incident_type": "Наводнение",
    "danger_level": " ",
  },
  {
    "incident_type": "Цунами",
    "danger_level": " ",
  },
  {
    "incident_type": "Химическое заражение",
    "danger_level": " ",
  },
  {
    "incident_type": "Вирусное заражение",
    "danger_level": " ",
  },
  {
    "incident_type": "Гололёд",
    "danger_level": " ",
  },
  {
    "incident_type": "Сильный туман",
    "danger_level": " ",
  },
  {
    "incident_type": "Снежная лавина",
    "danger_level": " ",
  },
  {
    "incident_type": "Камнепад",
    "danger_level": " ",
  },
  {
    "incident_type": "Извержение вулкана",
    "danger_level": " ",
  },
  {
    "incident_type": "Крупный град",
    "danger_level": " ",
  },
];

//  final defaultIcons = (dataIcons["icons"] as List).map((e) => DangerModel.fromJson(e)).toList();

// // Merge API icons with default icons (add missing ones)
// final existingTypes = widget.icons.map((e) => e.incidentType).toSet();
// for (final defaultIcon in defaultIcons) {
//   if (!existingTypes.contains(defaultIcon.incidentType)) {
//     infoIconData.add(DangerModel(
//       incidentType: defaultIcon.incidentType,
//       dangerLevel: defaultIcon.dangerLevel,
//       country: '',
//       city: '',
//       comment: '',
//       type: 'circle',
//       centerLat: 0.0,
//       centerLon: 0.0,
//       radius: 0.0,
//       isActive: false,
//     ));
//   }
// }
