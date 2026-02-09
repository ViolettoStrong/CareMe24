import 'dart:developer';
import 'dart:io';
import 'package:careme24/widgets/avatar_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

class FileZone extends StatefulWidget {
  const FileZone({
    super.key,
    this.canChange = true,
    required this.file,
    required this.onChange,
  });

  final Function(File) onChange;
  final bool canChange;
  final String file;

  @override
  State<FileZone> createState() => _FileZoneState();
}

class _FileZoneState extends State<FileZone> {
  final ImagePicker _imagePicker = ImagePicker();
  late String _file;
  late File _fileObj;

  @override
  void initState() {
    super.initState();
    _file = widget.file;
    _fileObj = File(_file);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    bool isImage = _file.endsWith('.png') ||
        _file.endsWith('.jpg') ||
        _file.endsWith('.jpeg');
    bool isPdf = _file.endsWith('.pdf');
    bool isUrl = Uri.tryParse(_file)?.hasScheme == true;

    return _file != ''
        ? Stack(
            children: [
              Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      if (isImage) {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            child: isUrl
                                ? Image.network(
                                    _file,
                                    width: size.width,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _fileObj,
                                    width: size.width,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        );
                      } else if (isPdf || isUrl) {
                        _launchURL(_file);
                      } else {
                        OpenFile.open(_file);
                      }
                    },
                    child: Container(
                      height: size.width * 0.25,
                      width: size.width * 0.32,
                      color: const Color.fromRGBO(242, 243, 245, 1),
                      child: isImage
                          ? isUrl
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:
                                      Image.network(_file, fit: BoxFit.cover),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child:
                                      Image.file(_fileObj, fit: BoxFit.cover),
                                )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.insert_drive_file,
                                        size: 50, color: Colors.grey),
                                    Text('Файл',
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  )),
              if (widget.canChange)
                Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        setState(() {
                          _file = '';
                          _fileObj = File('');
                        });
                        widget.onChange(_fileObj);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8, top: 8),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 15.0,
                        ),
                      ),
                    ))
            ],
          )
        : Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  _pickFromSource(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  height: size.width * 0.25,
                  width: size.width * 0.32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromRGBO(242, 243, 245, 1),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Color.fromRGBO(129, 140, 153, 1),
                      ),
                    ],
                  ),
                )),
          );
  }

  void _pickFromSource(BuildContext context) {
    showBarModalBottomSheet(
      expand: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const PickUploadSource(
        file: true,
      ),
    ).then((value) {
      if (value is ImageSource) {
        _uploadImage(value);
      } else if (value == 'file') {
        _pickFile();
      }
    });
  }

  void _uploadImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile == null) return;

      setState(() {
        _file = pickedFile.path;
        _fileObj = File(pickedFile.path);
      });
      widget.onChange(_fileObj);
    } catch (e) {
      log('$e');
    }
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        setState(() {
          _file = result.files.single.path!;
          _fileObj = File(_file);
        });
        widget.onChange(_fileObj);
      }
    } catch (e) {
      log('$e');
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
