import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AvatarPicker extends StatefulWidget {
  const AvatarPicker({
    super.key,
    required this.imagePath,
    required this.onChange,
  });

  final Function(File?) onChange;
  final String imagePath;

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  bool isMenuOpen = false;
  final ImagePicker _imagePicker = ImagePicker();
  File? _file;

  void _pickFromSource(BuildContext context) {
    showBarModalBottomSheet(
      expand: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const PickUploadSource(
        file: false,
      ),
    ).then((value) {
      if (value is ImageSource) {
        _uploadImage(value);
      }
    });
  }

  void _uploadImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile == null) return;

      setState(() {
        _file = File(pickedFile.path);
      });

      widget.onChange(_file);
    } catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return _file == null && widget.imagePath == ''
        ? Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _pickFromSource(context),
              child: Container(
                  height: 143,
                  width: 143,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 50,
                  )),
            ))
        : Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _pickFromSource(context),
                child: SizedBox(
                    height: 143,
                    width: 143,
                    child: _file == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: CachedNetworkImage(
                                fit: BoxFit.cover, imageUrl: widget.imagePath))
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: Image.file(
                              _file!,
                              fit: BoxFit.cover,
                            ),
                          ))),
          );
  }
}

class PickUploadSource extends StatefulWidget {
  const PickUploadSource({
    super.key,
    required this.file,
  });
  final bool file;

  @override
  State<PickUploadSource> createState() => _PickUploadSourceState();
}

class _PickUploadSourceState extends State<PickUploadSource> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Из камеры'),
              leading: const Icon(Icons.camera_alt_outlined),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              title: const Text('Из галереи'),
              leading: const Icon(Icons.photo_album_outlined),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            if (widget.file)
              ListTile(
                title: const Text('Выбрать файл'),
                leading: const Icon(Icons.attach_file),
                onTap: () => Navigator.of(context).pop('file'),
              ),
          ],
        ),
      ),
    ));
  }
}
