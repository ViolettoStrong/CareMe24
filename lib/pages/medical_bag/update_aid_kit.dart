import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:careme24/pages/medical_bag/cubit/aid_kit_cubit.dart';
import 'package:careme24/pages/medical_bag/cubit/aid_kit_state.dart';
import 'package:careme24/pages/medical_bag/widgets/custom_gradient_button.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class MedicineBagUpdateScreen extends StatefulWidget {
  final String title;
  final String id;
  final String image;
  MedicineBagUpdateScreen(
      {required this.title, required this.id, required this.image, Key? key})
      : super(key: key);

  @override
  _MedicineBagAddScreenState createState() => _MedicineBagAddScreenState();
}

class _MedicineBagAddScreenState extends State<MedicineBagUpdateScreen> {
  late TextEditingController titleController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
  }

  // Function to pick an image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to create AidKit

  Future<void> _updateAidKit() async {
    if (titleController.text.isNotEmpty) {
      try {
        File? imageFile;

        if (_selectedImage != null) {
          imageFile = _selectedImage!;
        } else if (widget.image.isNotEmpty) {
          if (widget.image.startsWith('http')) {
            // If it's a URL, download and convert it to a File
            imageFile = await _fileFromImageUrl(widget.image);
          } else {
            // If it's a local file path, use it directly
            imageFile = File(widget.image);
          }
        }

        if (imageFile == null) {
          ElegantNotification.error(
            description: const Text('Пожалуйста, выберите изображение'),
          ).show(context);
          return;
        }

        context.read<AidKitCubit>().updateAidKit(
              widget.id,
              titleController.text.trim(),
              imageFile,
            );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      }
    } else {
      ElegantNotification.error(
        description:
            const Text('Пожалуйста, заполните все поля и выберите изображение'),
      ).show(context);
    }
  }

  Future<File> _fileFromImageUrl(String imageUrlGet) async {
    Dio dio = Dio();
    final imageUrl = imageUrlGet;

    try {
      Response response = await dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final documentDirectory = await getApplicationDocumentsDirectory();
      // Modified path concatenation without path package
      final filePath = '${documentDirectory.path}/imagetest.png';
      final file = File(filePath);
      await file.writeAsBytes(response.data);
      return file;
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
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
          title: AppbarTitle(
            text: "Домашняя аптечка",
          ),
          styleType: Style.bgFillBlue60001,
        ),
        body: BlocListener<AidKitCubit, AidKitState>(
          listener: (context, state) {
            if (state is AidKitUpdated) {
              ElegantNotification.success(description: Text(state.detail))
                  .show(context);
              Navigator.pop(context);
            } else if (state is AidKitError) {
              ElegantNotification.error(
                title: const Text("Error"),
                description: Text(state.message), // Use `state.message`
              ).show(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    height: 45,
                    child: Row(
                      children: [
                        Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: _pickImage,
                              child: _selectedImage == null
                                  ? CustomImageView(
                                      url: widget.image,
                                      height: 40,
                                      width: 40,
                                    )
                                  : Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                            )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: "Введите название",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: CustomGradientButton(
                    text: 'Изменить аптечку',
                    onPressed: () {
                      _updateAidKit();
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
