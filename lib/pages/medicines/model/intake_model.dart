class MedicineIntakeTime {
  final String id;
  final String day;
  final String time;
  final String medicineId;
  final Map<String, dynamic> medicine;

  MedicineIntakeTime({
    required this.id,
    required this.day,
    required this.time,
    required this.medicineId,
    required this.medicine,
  });

  // Factory method to create a MedicineIntakeTime from JSON
  factory MedicineIntakeTime.fromJson(Map<String, dynamic> json) {
    return MedicineIntakeTime(
      id: json['id'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      medicineId: json['medicine_id'] ?? '',
      medicine: json['medicine'] ?? {},
    );
  }
}
