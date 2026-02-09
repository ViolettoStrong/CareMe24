import 'dart:convert';

import 'package:careme24/features/chat/models/message_model.dart';
import 'package:careme24/service/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatCtrl with ChangeNotifier {
  List<MessageModel> messages = [];
  WebSocketChannel? channel;

  ScrollController scrollController = ScrollController();

  bool isloading = false;

  String? chatId;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  getChatData(String serviceId) async {
    isloading = true;
    notifyListeners();

    try {
      String? token =
          await TokenManager.getToken(); // Replace with actual token

      final wsUrl = Uri.parse(
          'ws://v2290783.hosted-by-vdsina.ru/api/services/chat/$serviceId?token=$token');
      channel = WebSocketChannel.connect(wsUrl);

      channel?.stream.listen(
        onMessage,
        onError: (error) {
          isloading = false;
          notifyListeners();
          debugPrint("WebSocket Error: $error");
        },
        onDone: () {
          isloading = false;
          notifyListeners();
          debugPrint("WebSocket connection closed");
        },
      );
      debugPrint('connected to websocket');
    } catch (e) {
      isloading = false;
      notifyListeners();
      debugPrint(e.toString());
    }
  }

  onMessage(message) {
    isloading = false;
    //   // channel.sink.add('received!');
    debugPrint("Received message: ${message}"); // Log received data
    final msg = json.decode(message);

    if (msg['chat_id'] != null) {
      chatId = msg['chat_id'];
    }

    if (msg['message'] != null) {
      MessageModel? newMessage = MessageModel.fromJson(msg['message']);
      messages.add(newMessage);
    }
    if (msg['messages'] != null) {
      List<MessageModel> msgs = List.from(msg['messages'].map((e) {
        return MessageModel.fromJson(e);
      }));

      messages.addAll(msgs);
    }
    notifyListeners();
    animateToBottom();
  }

  animateToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 100,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}
