import 'dart:async';

import 'package:careme24/main.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CaremeCallStartPage extends StatefulWidget {
  final bool noInternet;
  final bool isShake;
  const CaremeCallStartPage(
      {super.key, this.noInternet = false, this.isShake = false});

  @override
  State<CaremeCallStartPage> createState() => _CaremeCallStartPageState();
}

class _CaremeCallStartPageState extends State<CaremeCallStartPage> {
  bool isNavigating = false;
  StreamSubscription<UserAccelerometerEvent>? _accelerometerSubscription;
  @override
  void initState() {
    super.initState();
    _initializeShakeListener();
  }

  void _initializeShakeListener() {
    _accelerometerSubscription = userAccelerometerEvents.listen((event) {
      if (!mounted) return;

      double acceleration = event.x.abs() + event.y.abs() + event.z.abs();

      if (acceleration > 8 && !isNavigating) {
        _openShakePage();
      }
    });
  }

  void _openShakePage() {
    isNavigating = true;
    _accelerometerSubscription?.cancel();
    navigatorKey.currentState?.pushNamed(AppRouter.careMeScreen, arguments: {
      'isShake': true,
      'noInternet': widget.noInternet
    }).then((_) {
      setState(() {
        isNavigating = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Material(
          color: const Color(0xFFA349A3),
          child: Stack(
            children: [
              const Positioned(
                top: 126,
                left: 0,
                right: 0,
                child: Text(
                  'Встряхните телефон!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Align(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Я очевидец!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 49,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Преступление\nБедствие\nНужна помощь',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              // ----------------- ՆԵՐՔԵՎ ԱՋ ICON -----------------
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomImageView(
                  width: 260,
                  height: 275,
                  svgPath: ImageConstant.camera,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
