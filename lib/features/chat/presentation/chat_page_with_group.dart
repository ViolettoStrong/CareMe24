import 'dart:convert';
import 'dart:io';
import 'package:careme24/api/api.dart';
import 'package:careme24/service/token_storage.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWithGroupPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final bool hasCar;

  const ChatWithGroupPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.hasCar});

  @override
  State<ChatWithGroupPage> createState() => _ChatWithGroupPageState();
}

class _ChatWithGroupPageState extends State<ChatWithGroupPage> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  String chatId = '';

  WebSocketChannel? _channel;

  @override
  void initState() {
    super.initState();
    getChat();
    _connectWebSocket();
  }

  Future<void> getChat() async {
    final allChats =
        widget.hasCar ? await Api.getChatCar() : await Api.getChatGroup();

    final groupChat = widget.hasCar
        ? allChats.firstWhere(
            (chat) => chat['car_id'] == widget.groupId,
            orElse: () => null,
          )
        : allChats.firstWhere(
            (chat) => chat['group_id'] == widget.groupId,
            orElse: () => null,
          );

    if (groupChat == null) return;

    setState(() {
      chatId = groupChat['id'];
    });
  }

  void _sendMessage({String? filePath}) async {
    final text = messageController.text.trim();
    if (text.isEmpty && filePath == null) return;

    final response = widget.hasCar
        ? await Api.sendMessageCar(
            chatId: chatId,
            message: text,
            messageType: filePath != null ? 'file' : 'text',
            filePath: filePath,
          )
        : await Api.sendMessageGroup(
            chatId: chatId,
            message: text,
            messageType: filePath != null ? 'file' : 'text',
            filePath: filePath,
          );

    if (response["status"] == "success") {
      messageController.clear();
      scrollController.animateTo(
        scrollController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      ElegantNotification.error(
          description: const Text("Ошибка отправки сообщения"));
    }
  }

  void _connectWebSocket() async {
    final token = await TokenManager.getToken();
    final encodedToken = Uri.encodeComponent(token ?? '');

    final uri = Uri.parse(
      widget.hasCar
          ? 'ws://v2290783.hosted-by-vdsina.ru/api/requests/chat/car/${widget.groupId}?token=$encodedToken'
          : 'ws://v2290783.hosted-by-vdsina.ru/api/requests/chat/group/${widget.groupId}?token=$encodedToken',
    );

    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen((data) {
      final decoded = jsonDecode(data);

      // History load
      if (decoded is Map<String, dynamic> && decoded['messages'] is List) {
        final List msgs = decoded['messages'];
        setState(() {
          messages = msgs
              .map((m) => {
                    'from': m['from'],
                    'text': m['text'],
                    'file': m['file'],
                    'timestamp': DateTime.tryParse(m['created_at'] ?? '') ??
                        DateTime.now(),
                  })
              .toList();
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          }
        });
      }

      // New message format: {"status":"new message","message":{...}}
      else if (decoded is Map<String, dynamic> &&
          decoded['status'] == 'new message' &&
          decoded['message'] != null) {
        final msg = decoded['message'];
        setState(() {
          messages.add({
            'from': msg['from'] ?? 'group',
            'text': msg['text'],
            'file': msg['file'],
            'timestamp':
                DateTime.tryParse(msg['created_at'] ?? '') ?? DateTime.now(),
          });
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    }, onError: (e) {
      print('WebSocket error: $e');
    }, onDone: () {
      print('WebSocket closed');
    });
  }

  Future<void> _pickFileAndSend() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      _sendMessage(filePath: result.files.single.path!);
    }
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    final isUser = message['from'] == 'user';
    final text = message['text'] ?? '';
    final fileName = message['file'];
    final filePath = message['filePath'];

    Widget content;

    if (fileName != null) {
      final lower = fileName.toLowerCase();
      final isImage = lower.endsWith('.png') ||
          lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.gif') ||
          lower.endsWith('.webp');

      if (isImage) {
        if (filePath != null && File(filePath).existsSync()) {
          content = Image.file(File(filePath), width: 200);
        } else {
          final imageUrl = fileName;
          content = Image.network(imageUrl, width: 200);
        }
      } else {
        content = InkWell(
          onTap: () {},
          child: Text(
            fileName,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      }
    } else {
      content = Text(text);
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: const Color.fromARGB(255, 61, 128, 244),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(messages[index]);
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _pickFileAndSend,
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Напишите сообщение',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
