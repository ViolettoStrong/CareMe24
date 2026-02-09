import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:careme24/api/api.dart';
import 'package:careme24/main.dart';
import 'package:careme24/pages/calls/careme_call_page.dart';
import 'package:careme24/router/app_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoInternetOverlay extends StatefulWidget {
  final Widget child;

  const NoInternetOverlay({super.key, required this.child});

  @override
  State<NoInternetOverlay> createState() => _NoInternetOverlayState();
}

class _NoInternetOverlayState extends State<NoInternetOverlay> {
  bool _hasInternet = true;
  late StreamSubscription<List<ConnectivityResult>> _subscription;
  List<Map<String, dynamic>> _requests = [];

  Future<void> _checkConnection() async {
    final result = await Connectivity().checkConnectivity();

    final hasConnection = switch (result) {
      ConnectivityResult.mobile => true,
      ConnectivityResult.wifi => true,
      ConnectivityResult.ethernet => true,
      ConnectivityResult.vpn => true,
      _ => false,
    };

    if (mounted) {
      setState(() {
        _hasInternet = true; //hasConnection;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _subscription = Connectivity().onConnectivityChanged.listen((result) async {
      final hasConnection = result.any((r) => r != ConnectivityResult.none);
      if (mounted) {
        setState(() {
          _hasInternet = hasConnection;
        });
      }
      if (hasConnection) {
        await _loadRequests();
      }
    });
  }

  Future<File?> getVideoFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final base64Video = prefs.getString('offline_video');

      if (base64Video == null) return null;

      final bytes = base64Decode(base64Video);

      final tempDir = Directory.systemTemp;
      final file = File('${tempDir.path}/recovered_video.mp4');

      await file.writeAsBytes(bytes);

      print('✅ Video restored from SharedPreferences: ${file.path}');
      return file;
    } catch (e) {
      print('❌ Error reading video: $e');
      return null;
    }
  }

  Future<void> _loadRequests() async {
    try {
      final data = await Api.getRequests112();

      if (data.isNotEmpty) {
        _requests = data;

        final videoFile = await getVideoFromPrefs();
        if (videoFile == null) {
          print('⚠️ No offline video found');
          return;
        }

        final params = {"request_id": _requests[0]['id']};
        final body = {
          "video":
              videoFile, // 👈 անհրաժեշտ է, որ Api.updateRequest112 աջակցի multipart-ին
        };

        // 📨 ուղարկում ենք վիդեոն backend-ին
        await Api.updateRequest112(params, body);
        print('✅ Offline video uploaded successfully');

        // 🗑️ ջնջում ենք SharedPrefs-ի տվյալը
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('offline_video');

        // 🧹 ջնջում ենք նաև ֆայլը local temp-ից
        if (await videoFile.exists()) {
          await videoFile.delete();
          print('🧹 Local video file deleted: ${videoFile.path}');
        }
      } else {
        _requests = [];
      }
    } catch (e) {
      print('❌ Error in _loadRequests: $e');
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColorFiltered(
        colorFilter: _hasInternet
            ? const ColorFilter.mode(
                Colors.transparent,
                BlendMode.dst,
              )
            : ColorFilter.mode(
                Colors.grey.withOpacity(0.7),
                BlendMode.saturation,
              ),
        child: Stack(
          children: [
            IgnorePointer(
              ignoring: !_hasInternet ? true : false,
              child: widget.child,
            ),
            if (!_hasInternet)
              Positioned.fill(
                child: Container(
                  color: Colors.transparent,
                  child: Align(
                    alignment: const Alignment(0, 0.7),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.30,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.black,
                          width: 0.2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Соединение с интернетом отсутствует",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 132, 255),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _checkConnection,
                              child: const Text(
                                "Обновить",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 13),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 17, 0),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _hasInternet = true;
                                });

                                navigatorKey.currentState?.pushNamed(
                                    AppRouter.careMeScreen,
                                    arguments: {'noInternet': true}).then((_) {
                                  setState(() {
                                    _hasInternet = false;
                                  });
                                });
                              },
                              child: const Text(
                                "Экстренный вызов",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
