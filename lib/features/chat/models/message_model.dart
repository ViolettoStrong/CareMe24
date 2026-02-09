class MessageModel {
  final String id;
  final String from;
  final String text;
  final String type;
  final String? file;
  final bool readByService;
  final bool readByUser;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.from,
    required this.text,
    required this.type,
    this.file,
    required this.readByService,
    required this.readByUser,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      from: json['from'] ?? '',
      text: json['text'] ?? '',
      type: json['type'] ?? '',
      file: json['file'],
      readByService: json['read_by_service'] ?? false,
      readByUser: json['read_by_user'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? '',
      ),
    );
  }
}
