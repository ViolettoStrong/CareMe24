import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:careme24/api/api.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/application/application_cubit.dart';
import 'package:careme24/blocs/application/application_state.dart';
import 'package:careme24/pages/calls/careme_reason_page.dart';
import 'package:careme24/pages/calls/reasonselectionpage.dart';
import 'package:careme24/pages/calls/sos_button.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class CaremeCallPage extends StatefulWidget {
  final bool noInternet;
  final bool isShake;
  const CaremeCallPage(
      {super.key, this.noInternet = false, this.isShake = false});

  @override
  State<CaremeCallPage> createState() => _CaremeCallPageState();
}

bool isSos = false;
bool isSend = false;
bool isUrgently = false;
bool isSending = false;

final ImagePicker _imagePicker = ImagePicker();
String id = '';

class _CaremeCallPageState extends State<CaremeCallPage> {
  double shakeThreshold = 10.0;
  bool _grow = true;
  List<Map<String, dynamic>> _requests = [];
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  late bool authorization;
  File? videoFile;
  String? selectedResone;
  int? selectedResoneIndex;
  @override
  void initState() {
    final appState = context.read<ApplicationCubit>().state;
    authorization = appState is ApplicationCompleted && appState.isAuthorized;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadRequests();
      if (_requests.isEmpty) {
        uploadVideo();
      }
    });
    super.initState();
  }

  Future<void> saveVideoToPrefs(File video) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bytes = await video.readAsBytes();
      final base64Video = base64Encode(bytes);
      await prefs.setString('offline_video', base64Video);

      print(' Video saved in SharedPreferences (${bytes.length} bytes)');
    } catch (e) {
      print('Error saving video: $e');
    }
  }

  Future<void> _loadRequests() async {
    final data = await Api.getRequests112();
    if (mounted) {
      setState(() {
        if (data.isNotEmpty) {
          _requests = data;
          isSend = true;
          id = data[0]['id'];
          selectedResone = data[0]['detail'].toString().isNotEmpty
              ? data[0]['detail']
              : data[0]['detail'];
          isSending = true;
          isSos = data[0]['sos'];
          isUrgently = data[0]['important'];
        } else {
          _requests = [];
        }
      });
    }
  }

  Future<void> _createRequest112() async {
    if (widget.noInternet) {
      await saveVideoToPrefs(videoFile!);
      sendEmergencySMS(selectedResone, isUrgently);
    } else {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReasonSelectionPage()),
      );
      if (result != null && result is Map) {
        final String text = result['text'] ?? '';
        final int? index = result['index'];

        setState(() {
          selectedResone = text;
          selectedResoneIndex = index;
          isSending = false;
        });

        if (selectedResone == null || selectedResone!.trim().isEmpty) {
          ElegantNotification.error(
            description: const Text('Нужно выбрать событие'),
          ).show(context);

          Navigator.pushReplacementNamed(context, AppRouter.appContainer);
          return;
        }

        final response = await AppBloc.requestCubit.createRequest112(
          selectedResone!,
          [videoFile!],
          isUrgently,
          selectedResoneIndex == 0
              ? 'pol'
              : selectedResoneIndex == 1
                  ? 'mch'
                  : selectedResoneIndex == 2
                      ? 'med'
                      : 'pol',
        );

        if (response.isSuccess) {
          await Future.delayed(const Duration(seconds: 4));
          ElegantNotification.success(
            description: const Text('Вызов отправлен'),
          ).show(context);
          if (mounted) {
            setState(() {
              isSending = true;
            });
          }
          await _loadRequests();
        }
      }
    }
  }

  Future<void> sendEmergencySMS(selectedReasone, isUrgently) async {
    const String phoneNumber = '+37441246441';
    double lat = AppBloc.requestCubit.lat;
    double lon = AppBloc.requestCubit.lon;
    String medCardId = AppBloc.requestCubit.medCardId;
    final String message = '''
⚠️ ЭКСТРЕННОЕ СООБЩЕНИЕ

detail: $selectedReasone
important: $isUrgently
type: $selectedReasone
card_id: $medCardId
lat: $lat
long: $lon
''';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Не удалось открыть SMS приложение';
    }
  }

  bool isNavigating = false;

  void uploadVideo() async {
    try {
      final pickedFile =
          await _imagePicker.pickVideo(source: ImageSource.camera);

      if (pickedFile == null) {
        Navigator.pushReplacementNamed(context, AppRouter.appContainer);
        return;
      }

      final File newVideoFile = File(pickedFile.path);

      setState(() {
        videoFile = newVideoFile;
      });

      if (_requests.isNotEmpty) {
        final requestId = _requests[0]['id'];

        final List<String> videos = await Api.getVideo112(requestId);

        final tempDir = await getTemporaryDirectory();
        final dio = Dio();
        final existingMultipartVideos = await Future.wait(
          videos.map((url) async {
            final response = await dio.get<List<int>>(
              url,
              options: Options(responseType: ResponseType.bytes),
            );

            final fileName = url.split('/').last;
            final file = File('${tempDir.path}/$fileName');
            await file.writeAsBytes(response.data!);

            return MultipartFile.fromFile(
              file.path,
              filename: fileName,
            );
          }),
        );

        final newMultipartVideo = await MultipartFile.fromFile(
          newVideoFile.path,
          filename: newVideoFile.path.split('/').last,
        );
        final allVideos = [
          ...existingMultipartVideos,
          newMultipartVideo,
        ];

        await AppBloc.requestCubit.updateRequest112(
          requestId,
          {
            'videos': allVideos,
          },
        );
      } else {
        await _createRequest112();
      }
    } catch (e) {
      log('Ошибка при выборе видео: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(25, 154, 139, 1),
    ));

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: authorization
            ? null
            : AppBar(
                backgroundColor: Colors.grey[300],
                elevation: 0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.registerEmailPage);
                  },
                  child: Text(
                    "Не активно",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(221, 29, 162, 228),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
        backgroundColor: const Color(0xFFA349A3),
        body: Column(
          children: [
            const SizedBox(height: 90),
            SizedBox(
              height: 110,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    uploadVideo();
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 17),
                      SvgPicture.asset(
                        'assets/icons/camera.svg',
                      ),
                      const SizedBox(width: 40),
                      const Center(
                        child: Text(
                          'Новое видео',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (videoFile != null || _requests.isNotEmpty)
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset('assets/icons/add.svg'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.white),
            SizedBox(
              height: 110,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    ElegantNotification.error(
                            description: Text('Событие нельзя изменить'))
                        .show(context);
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 17),
                      SvgPicture.asset(
                        'assets/images/listimage.svg',
                      ),
                      const SizedBox(width: 40),
                      const Center(
                        child: Text(
                          'Событие',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (selectedResone != null &&
                          selectedResone!.trim().isNotEmpty)
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            'assets/icons/selected.svg',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.white),
            SizedBox(
              height: 20,
              child: Row(
                children: [
                  const SizedBox(width: 17),
                  isSending
                      ? Transform.scale(
                          scale: 1.0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: _grow ? 0.8 : 1.4,
                            end: _grow ? 1.4 : 0.8,
                          ),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          onEnd: () {
                            if (!isSending) {
                              setState(() {
                                _grow = !_grow;
                              });
                            }
                          },
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                  const SizedBox(width: 8),

                  // 📝 TEXT
                  Text(
                    !isSending ? "Отправка видео" : "Видео отправлено",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            setState(() {
                              isSos = !isSos;
                            });
                            await AppBloc.requestCubit.updateRequest112(
                              _requests[0]['id'],
                              {'sos': isSos},
                            );
                          },
                          child: SosPulsingButton(isActive: isSos, size: 137)),
                      const SizedBox(width: 16),
                      Text(
                        "Я в опасности!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isSos
                              ? Colors.red
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ❌ Удалить
                        GestureDetector(
                            onTap: () async {
                              final response = await AppBloc.requestCubit
                                  .deleteRequest112(_requests[0]['id']);

                              if (response.isSuccess) {
                                ElegantNotification.success(
                                        description:
                                            const Text('Заявка отменена'))
                                    .show(context);
                                Navigator.pushReplacementNamed(
                                    context, AppRouter.appContainer);
                              }
                            },
                            child: Column(
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/close1.svg',
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Удалить",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),

                        // ✔️ Важно
                        GestureDetector(
                            onTap: () async {
                              setState(() {
                                isUrgently = !isUrgently;
                              });
                              await AppBloc.requestCubit.updateRequest112(
                                _requests[0]['id'],
                                {'important': isUrgently},
                              );
                            },
                            child: Column(
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    isUrgently
                                        ? 'assets/icons/checked.svg'
                                        : 'assets/icons/check.svg', //change to changed.svg in change
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Важно",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: getPadding(left: 17, bottom: 17),
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(), // for circular ripple
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: Colors.white24,
                          highlightColor: Colors.white10,
                          onTap: () {
                            setState(() {
                              isSend = false;
                            });

                            Navigator.pushReplacementNamed(
                                context, AppRouter.appContainer);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  String getCodeByText(String text) {
    if (text == '0') {
      return 'pol';
    } else if (text == '1') {
      return 'mch';
    } else if (text == '2') {
      return 'med';
    } else {
      return 'unknown';
    }
  }
}
/*

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:careme24/api/api.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/application/application_cubit.dart';
import 'package:careme24/blocs/application/application_state.dart';
import 'package:careme24/pages/calls/careme_reason_page.dart';
import 'package:careme24/pages/calls/reasonselectionpage.dart';
import 'package:careme24/pages/calls/sos_button.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:dio/dio.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

class CaremeCallPage extends StatefulWidget {
  final bool noInternet;
  final bool isShake;
  const CaremeCallPage(
      {super.key, this.noInternet = false, this.isShake = false});

  @override
  State<CaremeCallPage> createState() => _CaremeCallPageState();
}

bool isSos = false;
bool isSend = false;
bool isUrgently = false;
bool isSending = false;

final ImagePicker _imagePicker = ImagePicker();
int? selectedResoneIndex;
String id = '';

class _CaremeCallPageState extends State<CaremeCallPage> {
  double shakeThreshold = 10.0;
  List<Map<String, dynamic>> _requests = [];
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  late bool authorization;
  File? videoFile;
  String? selectedResone;
  @override
  void initState() {
    final appState = context.read<ApplicationCubit>().state;
    authorization = appState is ApplicationCompleted && appState.isAuthorized;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadRequests();

      if (_requests.isEmpty) {
        uploadVideo();
      }
      else if(_requests[0]['type']== "Будет отправлено в ближайшее время"){
                await _loadRequests();
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReasonSelectionPage()),
        );

        if (result != null) {
          setState(() {
            selectedResone = result;
          });
          await AppBloc.requestCubit.updateRequest112(
            _requests[0]['id'],
            {
              'type':  (selectedResone == null || selectedResone!.trim().isEmpty)
              ? 'Будет отправлено в ближайшее время'
              : selectedResone!,
            },
          );
        }
      }
      
    });
    super.initState();
  }

  Future<void> saveVideoToPrefs(File video) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bytes = await video.readAsBytes();
      final base64Video = base64Encode(bytes);
      await prefs.setString('offline_video', base64Video);

      print(' Video saved in SharedPreferences (${bytes.length} bytes)');
    } catch (e) {
      print('Error saving video: $e');
    }
  }

  Future<void> _loadRequests() async {
    final data = await Api.getRequests112();
    if (mounted) {
      setState(() {
        if (data.isNotEmpty) {
          _requests = data;
          isSend = true;
          id = data[0]['id'];
          selectedResone = data[0]['type']=='Будет отправлено в ближайшее время'?'':data[0]['type'];
          isSending = true;
        } else {
          _requests = [];
        }
      });
    }
  }

  Future<void> _createRequest112() async {
    if (widget.noInternet) {
      await saveVideoToPrefs(videoFile!);
      sendEmergencySMS(selectedResone, isUrgently);
    } else {
      final response = await AppBloc.requestCubit.createRequest112(
          (selectedResone == null || selectedResone!.trim().isEmpty)
              ? 'Будет отправлено в ближайшее время'
              : selectedResone!,
          [videoFile!],
          isUrgently);

      if (response.isSuccess) {
        ElegantNotification.success(
          description: const Text('Заявка отправлена'),
        ).show(context);
        setState(() {
          id = response.requestId;
          isSend = true;
        });
        await _loadRequests();
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReasonSelectionPage()),
        );

        if (result != null) {
          setState(() {
            selectedResone = result;
          });
          await AppBloc.requestCubit.updateRequest112(
            _requests[0]['id'],
            {
              'type':  (selectedResone == null || selectedResone!.trim().isEmpty)
              ? 'Будет отправлено в ближайшее время'
              : selectedResone!,
            },
          );
        }
      }
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        isSending = true;
      });
    }
  }

  Future<void> sendEmergencySMS(selectedReasone, isUrgently) async {
    const String phoneNumber = '+37441246441';
    double lat = AppBloc.requestCubit.lat;
    double lon = AppBloc.requestCubit.lon;
    String medCardId = AppBloc.requestCubit.medCardId;
    final String message = '''
⚠️ ЭКСТРЕННОЕ СООБЩЕНИЕ

detail: $selectedReasone
important: $isUrgently
type: $selectedReasone
card_id: $medCardId
lat: $lat
long: $lon
''';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{'body': message},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Не удалось открыть SMS приложение';
    }
  }

  bool isNavigating = false;

  void uploadVideo() async {
    try {
      final pickedFile =
          await _imagePicker.pickVideo(source: ImageSource.camera);

      if (pickedFile == null) {
        Navigator.pushReplacementNamed(context, AppRouter.appContainer);
        return;
      }

      final File newVideoFile = File(pickedFile.path);

      setState(() {
        videoFile = newVideoFile;
      });

      if (_requests.isNotEmpty) {
        final requestId = _requests[0]['id'];

        final List<String> videos = await Api.getVideo112(requestId);

        final tempDir = await getTemporaryDirectory();
        final dio = Dio();
        final existingMultipartVideos = await Future.wait(
          videos.map((url) async {
            final response = await dio.get<List<int>>(
              url,
              options: Options(responseType: ResponseType.bytes),
            );

            final fileName = url.split('/').last;
            final file = File('${tempDir.path}/$fileName');
            await file.writeAsBytes(response.data!);

            return MultipartFile.fromFile(
              file.path,
              filename: fileName,
            );
          }),
        );

        final newMultipartVideo = await MultipartFile.fromFile(
          newVideoFile.path,
          filename: newVideoFile.path.split('/').last,
        );
        final allVideos = [
          ...existingMultipartVideos,
          newMultipartVideo,
        ];

        await AppBloc.requestCubit.updateRequest112(
          requestId,
          {
            'videos': allVideos,
          },
        );
      } else {
        await _createRequest112();
      }
    } catch (e) {
      log('Ошибка при выборе видео: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(25, 154, 139, 1),
    ));

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: authorization
            ? null
            : AppBar(
                backgroundColor: Colors.grey[300],
                elevation: 0,
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.registerEmailPage);
                  },
                  child: Text(
                    "Не активно",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(221, 29, 162, 228),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
        backgroundColor: const Color(0xFFA349A3),
        body: Column(
          children: [
            const SizedBox(height: 90),
            SizedBox(
              height: 110,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    uploadVideo();
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 17),
                      SvgPicture.asset(
                        'assets/icons/camera.svg',
                      ),
                      const SizedBox(width: 40),
                      const Center(
                        child: Text(
                          'Новое видео',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (videoFile != null || _requests.isNotEmpty)
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset('assets/icons/add.svg'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.white),
            SizedBox(
              height: 110,
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReasonSelectionPage()),
                    );

                    if (result != null) {
                      await AppBloc.requestCubit.updateRequest112(
            _requests[0]['id'],
            {
              'type': result
            },
          );
                      setState(() {
                        selectedResone = result;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 17),
                      SvgPicture.asset(
                        'assets/images/listimage.svg',
                      ),
                      const SizedBox(width: 40),
                      const Center(
                        child: Text(
                          'Событие',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (selectedResone != null && selectedResone!.trim().isNotEmpty)
                        Align(
                          alignment: Alignment.topCenter,
                          child: SvgPicture.asset(
                            'assets/icons/selected.svg',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(color: Colors.white),
            SizedBox(
              height: 20,
              child: Row(
                      children: [
                        const SizedBox(width: 17),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.4),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: child,
                            );
                          },
                          onEnd: () {
                            setState(() {});
                          },
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                         Text(
                         isSending?"Отправка видео": "Видео отправлен",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
            ),

            SizedBox(
              height: 30,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isSos = !isSos;
                            });
                          },
                          child: SosPulsingButton(isActive: isSos, size: 137)),
                      const SizedBox(width: 16),
                      Text(
                        "Я в опасности!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isSos
                              ? Colors.red
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ❌ Удалить
                        GestureDetector(
                            onTap: () async {
                              final response = await AppBloc.requestCubit
                                  .deleteRequest112(_requests[0]['id']);
                              if (response.isSuccess) {
                                ElegantNotification.success(
                                        description:
                                            const Text('Заявка отменена'))
                                    .show(context);
                                Navigator.pushReplacementNamed(
                                    context, AppRouter.appContainer);
                              }
                            },
                            child: Column(
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/close1.svg', 
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Удалить",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),

                        // ✔️ Важно
                        GestureDetector(
                            onTap: () async {
                              setState(() {
                                isUrgently = !isUrgently;
                              });
                              await AppBloc.requestCubit.updateRequest112(
            _requests[0]['id'],
            {
              'important': isUrgently
            },
          );
                            },
                            child: Column(
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    isUrgently?'assets/icons/checked.svg':'assets/icons/check.svg', //change to changed.svg in change
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Важно",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: getPadding(left: 17, bottom: 17),
                      child: Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(), // for circular ripple
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          splashColor: Colors.white24,
                          highlightColor: Colors.white10,
                          onTap: () {
                            setState(() {
                              isSend = false;
                            });

                            Navigator.pushReplacementNamed(
                                context, AppRouter.appContainer);
                          }, 
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  String getCodeByText(String text) {
    if (text == '0') {
      return 'pol';
    } else if (text == '1') {
      return 'mch';
    } else if (text == '2') {
      return 'med';
    } else {
      return 'unknown';
    }
  }
}
*/
