import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:careme24/widgets/avatar_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

class FilesZone extends StatefulWidget {
  const FilesZone({
    super.key,
    required this.files,
    required this.onChange,
  });

  final List<String> files;

  final dynamic onChange;

  @override
  State<FilesZone> createState() => _FilesZoneState();
}

class _FilesZoneState extends State<FilesZone> {
  final ImagePicker _imagePicker = ImagePicker();

  final List<String> _files = [];

  final List<File> _filelist = [];

  Future<File> _urlToFile(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      final uri = Uri.parse(url);
      final lastSeg = (uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'file_${DateTime.now().millisecondsSinceEpoch}');
      final filePath = '${dir.path}/$lastSeg';

      final f = File(filePath);
      if (await f.exists() && (await f.length()) > 0) {
        return f; // reuse cached file
      }
      await Dio().download(url, filePath);
      return File(filePath);
    } catch (e) {
      log('urlToFile error: $e');
      rethrow;
    }
  }

  bool _looksLikeHttpUrl(String p) =>
      p.startsWith('http://') || p.startsWith('https://');

  /// file:// URI -> local path
  String _normalizeLocalPath(String p) {
    if (p.startsWith('file://')) {
      return Uri.parse(p).toFilePath();
    }
    return p;
  }

  @override
  void initState() {
    super.initState();
    _prepareInitialFiles();
  }

  Future<void> _prepareInitialFiles() async {
    try {
      for (final raw in widget.files) {
        if (_looksLikeHttpUrl(raw)) {
          final downloaded = await _urlToFile(raw);
          _files.add(downloaded.path);
          _filelist.add(downloaded);
        } else {
          final localPath = _normalizeLocalPath(raw);
          final file = File(localPath);
          if (await file.exists()) {
            _files.add(localPath);
            _filelist.add(file);
          } else {
            log('Skip missing local path: $localPath');
          }
        }
      }
      if (!mounted) return;
      setState(() {});
      widget.onChange(_filelist);
    } catch (e) {
      log('prepareInitialFiles error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...List.generate(_files.length, (index) {
              return fileZone(context, _files[index], index);
            }),
            Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    _pickFromSource(context);
                  },
                  child: Container(
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
                  ),
                )),
          ],
        ),
      ],
    );
  }

  void _pickFromSource(BuildContext context) {
    showBarModalBottomSheet(
      expand: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => const PickUploadSource(file: true),
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
        _files.add(pickedFile.path);
        _filelist.add(File(pickedFile.path));
      });
      widget.onChange(_filelist);
    } catch (e) {
      log('$e');
    }
  }

  void _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.single.path != null) {
        setState(() {
          _files.add(result.files.single.path!);
          _filelist.add(File(result.files.single.path!));
        });
        widget.onChange(_filelist);
      }
    } catch (e) {
      log('$e');
    }
  }

  Widget fileZone(BuildContext context, String filePath, int fileIndex) {
    final size = MediaQuery.sizeOf(context);
    final lower = filePath.toLowerCase();
    final isImage = lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.heic');
    final isPdf = lower.endsWith('.pdf');

    return Stack(
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
                      child: Image.file(
                        File(filePath),
                        width: size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else if (isPdf) {
                  OpenFile.open(filePath);
                } else {
                  OpenFile.open(filePath);
                }
              },
              child: Container(
                height: size.width * 0.25,
                width: size.width * 0.32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromRGBO(242, 243, 245, 1),
                ),
                child: isImage
                    ? Image.file(File(filePath), fit: BoxFit.cover)
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.insert_drive_file,
                                size: 50, color: Colors.grey),
                            Text('Файл', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
              ),
            )),
        Positioned(
            right: 8,
            top: 8,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  setState(() {
                    final removedPath = _files.removeAt(fileIndex);
                    _filelist.removeWhere((f) => f.path == removedPath);
                    widget.onChange(_filelist);
                  });
                },
                child: Container(
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
              ),
            )),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
