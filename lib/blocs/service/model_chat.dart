// Define the Service model
// class Service {
//   String login;
//   String password;
//   String type;
//   String name;
//   String specialization;
//   int experience;
//   double price;
//   List<String> diplomas;
//   List<String> reviews;
//   String workPlace;
//   bool goHome;
//   String institutionName;
//   bool institutionCommercial;
//   String institutionType;
//   String institutionAge;
//   String license;
//   String photo;
//   bool verified;
//   String otp;
//   String id;

//   Service({
//     required this.login,
//     required this.password,
//     required this.type,
//     required this.name,
//     required this.specialization,
//     required this.experience,
//     required this.price,
//     required this.diplomas,
//     required this.reviews,
//     required this.workPlace,
//     required this.goHome,
//     required this.institutionName,
//     required this.institutionCommercial,
//     required this.institutionType,
//     required this.institutionAge,
//     required this.license,
//     required this.photo,
//     required this.verified,
//     required this.otp,
//     required this.id,
//   });

//   // Factory method to create a Service from JSON
//   factory Service.fromJson(Map<String, dynamic> json) {
//     return Service(
//       login: json['login'],
//       password: json['password'],
//       type: json['type'],
//       name: json['name'],
//       specialization: json['specialization'],
//       experience: json['experience'],
//       price: json['price'].toDouble(),
//       diplomas: List<String>.from(json['diplomas']),
//       reviews: List<String>.from(json['reviews']),
//       workPlace: json['work_place'],
//       goHome: json['go_home'],
//       institutionName: json['institution_name'],
//       institutionCommercial: json['institution_commercial'],
//       institutionType: json['institution_type'],
//       institutionAge: json['institution_age'],
//       license: json['license'],
//       photo: json['photo'],
//       verified: json['verified'],
//       otp: json['otp'],
//       id: json['id'],
//     );
//   }

//   // Convert Service to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'login': login,
//       'password': password,
//       'type': type,
//       'name': name,
//       'specialization': specialization,
//       'experience': experience,
//       'price': price,
//       'diplomas': diplomas,
//       'reviews': reviews,
//       'work_place': workPlace,
//       'go_home': goHome,
//       'institution_name': institutionName,
//       'institution_commercial': institutionCommercial,
//       'institution_type': institutionType,
//       'institution_age': institutionAge,
//       'license': license,
//       'photo': photo,
//       'verified': verified,
//       'otp': otp,
//       'id': id,
//     };
//   }
// }

// // Define the main model for the entire response
// class ServiceResponse {
//   String serviceId;
//   String userId;
//   // List<Message> messages;
//   Service service;
//   int countOfUnreadMessages;
//   String id;

//   ServiceResponse({
//     required this.serviceId,
//     required this.userId,
//     // required this.messages,
//     required this.service,
//     required this.countOfUnreadMessages,
//     required this.id,
//   });

//   factory ServiceResponse.fromJson(Map<String, dynamic> json) {
//     return ServiceResponse(
//       serviceId: json['service_id'],
//       userId: json['user_id'],
//       // messages: (json['messages'] as List).map((msg) => Message.fromJson(msg)).toList(),
//       service: Service.fromJson(json['service']),
//       countOfUnreadMessages: json['count_of_unread_messages'],
//       id: json['id'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'service_id': serviceId,
//       'user_id': userId,
//       // 'messages': messages.map((msg) => msg.toJson()).toList(),
//       'service': service.toJson(),
//       'count_of_unread_messages': countOfUnreadMessages,
//       'id': id,
//     };
//   }
// }

// class Message {
//   String id;
//   String from;
//   String text;
//   String type;
//   String? file;
//   bool readByService;
//   bool readByUser;
//   DateTime createdAt;

//   Message({
//     required this.id,
//     required this.from,
//     required this.text,
//     required this.type,
//     this.file,
//     required this.readByService,
//     required this.readByUser,
//     required this.createdAt,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['id'],
//       from: json['from'],
//       text: json['text'],
//       type: json['type'],
//       file: json['file'],
//       readByService: json['read_by_service'],
//       readByUser: json['read_by_user'],
//       createdAt: DateTime.parse(json['created_at']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'from': from,
//       'text': text,
//       'type': type,
//       'file': file,
//       'read_by_service': readByService,
//       'read_by_user': readByUser,
//       'created_at': createdAt.toIso8601String(),
//     };
//   }
// }

// class ItemModel {
//   final String id;
//   final String name;
//   final String description;
//   final String ownerId;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   const ItemModel({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.ownerId,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory ItemModel.fromJson(Map<String, dynamic> json) {
//     return ItemModel(
//       id: json['id'] as String,
//       name: json['name'] as String,
//       description: json['description'] as String,
//       ownerId: json['owner_id'] as String,
//       createdAt: DateTime.parse(json['created_at'] as String),
//       updatedAt: DateTime.parse(json['updated_at'] as String),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'description': description,
//       'owner_id': ownerId,
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//     };
//   }

//   @override
//   List<Object?> get props => [id, name, description, ownerId, createdAt, updatedAt];
// }

import 'dart:convert';

class ChatRoom {
  final String serviceId;
  final String userId;
  final Service service;
  final int countOfUnreadMessages;
  final LastMessage? lastMessage;
  final String id;

  ChatRoom({
    required this.serviceId,
    required this.userId,
    required this.service,
    required this.countOfUnreadMessages,
    this.lastMessage,
    required this.id,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      serviceId: json['service_id'],
      userId: json['user_id'],
      service: Service.fromJson(json['service']),
      countOfUnreadMessages: json['count_of_unread_messages'] is int
          ? json['count_of_unread_messages']
          : int.tryParse(json['count_of_unread_messages'].toString()) ?? 0,
      lastMessage: json['last_message'] != null
          ? LastMessage.fromJson(json['last_message'])
          : null,
      id: json['id'],
    );
  }
}

class Service {
  final String login;
  final String password;
  final String type;
  final String name;
  final String specialization;
  final int experience;
  final double price;
  final List<String> diplomas;
  final List<String> reviews;
  final String workPlace;
  final bool goHome;
  final String institutionName;
  final bool institutionCommercial;
  final String institutionType;
  final String institutionAge;
  final String license;
  final String photo;
  final bool verified;
  final int otp;
  final String id;

  Service({
    required this.login,
    required this.password,
    required this.type,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.price,
    required this.diplomas,
    required this.reviews,
    required this.workPlace,
    required this.goHome,
    required this.institutionName,
    required this.institutionCommercial,
    required this.institutionType,
    required this.institutionAge,
    required this.license,
    required this.photo,
    required this.verified,
    required this.otp,
    required this.id,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      login: json['login'],
      password: json['password'],
      type: json['type'],
      name: json['name'],
      specialization: json['specialization'],
      experience: json['experience'] is int
          ? json['experience']
          : int.tryParse(json['experience'].toString()) ?? 0,
      price: json['price'] is double
          ? json['price']
          : double.tryParse(json['price'].toString()) ?? 0.0,
      diplomas: List<String>.from(json['diplomas']),
      reviews: List<String>.from(json['reviews']),
      workPlace: json['work_place'],
      goHome: json['go_home'],
      institutionName: json['institution_name'],
      institutionCommercial: json['institution_commercial'],
      institutionType: json['institution_type'],
      institutionAge: json['institution_age'],
      license: json['license'],
      photo: json['photo'],
      verified: json['verified'],
      otp: json['otp'] is int
          ? json['otp']
          : int.tryParse(json['otp'].toString()) ?? 0,
      id: json['id'],
    );
  }
}

class LastMessage {
  final String id;
  final String from;
  final String text;
  final String type;
  final String? file;
  final bool readByService;
  final bool readByUser;
  final DateTime createdAt;

  LastMessage({
    required this.id,
    required this.from,
    required this.text,
    required this.type,
    this.file,
    required this.readByService,
    required this.readByUser,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['id'],
      from: json['from'],
      text: json['text'],
      type: json['type'],
      file: json['file'],
      readByService: json['read_by_service'],
      readByUser: json['read_by_user'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

List<ChatRoom> parseServiceChat(String jsonStr) {
  final parsed = json.decode(jsonStr).cast<Map<String, dynamic>>();
  return parsed.map<ChatRoom>((json) => ChatRoom.fromJson(json)).toList();
}
