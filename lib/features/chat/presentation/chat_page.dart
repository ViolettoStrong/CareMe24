import 'dart:io';

import 'package:careme24/blocs/service/service_cubit.dart';
import 'package:careme24/features/chat/controller/chat_ctrl.dart';
import 'package:careme24/features/chat/presentation/pages/image_viewer_page.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_text_form_field.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  // final ChatRoom chatRoom;
  // final ServiceModel service;
  final String serviceId;
  final String serviceName;
  final String serviceSpecialization;
  final String servicePhoto;
  const ChatPage({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.serviceSpecialization,
    required this.servicePhoto,
    // required this.chatRoom,
    // required this.service,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatCtrl chatCtrl = ChatCtrl();

  final TextEditingController messageController = TextEditingController();
  final Dio dio = Dio();

  int? chatId;

  @override
  void initState() {
    chatCtrl.getChatData(widget.serviceId);
    super.initState();
  }

  @override
  void dispose() {
    chatCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage({File? file}) async {
    String message = messageController.text.trim();
    if (message.isEmpty && file == null) return;

    if (chatCtrl.chatId != null) {
      context.read<ServiceCubit>().sendMessage(
            // widget.chatRoom.id,
            chatCtrl.chatId!,
            message,
            file?.path,
          );
      messageController.clear();
    }
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      _sendMessage(file: file);
    }
  }

  onTapTextField() async {
    await Future.delayed(const Duration(milliseconds: 100));
    chatCtrl.animateToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.whiteA700,
        // resizeToAvoidBottomInset: true,

        appBar: CustomAppBar(
          height: getVerticalSize(69),
          leadingWidth: 39,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Padding(
            padding: getPadding(left: 27),
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CustomImageView(
                    fit: BoxFit.cover,
                    url: widget.servicePhoto,
                    radius: BorderRadius.circular(100),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: getPadding(left: 10, top: 3, bottom: 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppbarSubtitle2(text: widget.serviceSpecialization),
                        const SizedBox(height: 4),
                        AppbarSubtitle2(text: widget.serviceName),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          styleType: Style.bgFillBlue60001,
        ),
        body: Container(
          width: double.maxFinite,
          padding: getPadding(top: 12, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListenableBuilder(
                  listenable: chatCtrl,
                  builder: (context, _) {
                    if (chatCtrl.isloading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return ListView.builder(
                      controller: chatCtrl.scrollController,
                      shrinkWrap: true,
                      itemCount: chatCtrl.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatCtrl.messages[index];

                        DateTime dateTime =
                            DateTime.parse(message.createdAt.toString())
                                .toLocal();

                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(dateTime);
                        String formattedTime =
                            DateFormat('hh:mm a').format(dateTime);

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                if (message.file != null)
                                  Container(
                                    height: 340,
                                    padding: const EdgeInsets.all(10),
                                    // constraints:
                                    //     const BoxConstraints(maxHeight: 400),
                                    child: CustomImageView(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImageViewerPage(
                                                    imageUrl: message.file!),
                                          ),
                                        );
                                      },
                                      file: message.file!.startsWith('http')
                                          ? null
                                          : File(message.file!),
                                      url: message.file!.startsWith('http')
                                          ? message.file!
                                          : null,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ListTile(
                                  leading: Icon(
                                    message.from == "user"
                                        ? Icons.person
                                        : Icons.support_agent,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    message.text,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    "$formattedDate • $formattedTime",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  trailing: message.readByService
                                      ? const Icon(Icons.done_all,
                                          color: Colors.blue)
                                      : const Icon(
                                          Icons.done,
                                          color: Colors.grey,
                                        ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // child: ListView.builder(
                //   itemCount: widget.message.length,
                //   itemBuilder: (context, index) {
                //     final message = widget.message[index];
                //     DateTime dateTime =
                //         DateTime.parse(message.createdAt.toString());
                //     String formattedDate =
                //         DateFormat('yyyy-MM-dd').format(dateTime);
                //     String formattedTime =
                //         DateFormat('hh:mm a').format(dateTime);

                //     return Padding(
                //       padding: const EdgeInsets.symmetric(
                //           vertical: 4.0, horizontal: 8.0),
                //       child: Card(
                //         elevation: 2,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //         child: ListTile(
                //           title: Text(
                //             message.text,
                //             style: const TextStyle(
                //                 fontSize: 16, fontWeight: FontWeight.w500),
                //           ),
                //           subtitle: Text(
                //             "$formattedDate • $formattedTime",
                //             style: const TextStyle(
                //                 fontSize: 12, color: Colors.grey),
                //           ),
                //           trailing: message.readByService
                //               ? const Icon(Icons.done_all, color: Colors.blue)
                //               : const Icon(Icons.done, color: Colors.grey),
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                    ), // Disabled look
                    onPressed: _selectFile, // Disable file attachment
                  ),
                  Expanded(
                    child: CustomTextFormField(
                      controller: messageController,
                      textInputAction: TextInputAction.done,
                      onTap: onTapTextField,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.grey),
                    onPressed: _sendMessage, // Disable send
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
