import 'dart:async';
import 'dart:developer';
import 'package:careme24/app_container.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/application/application_cubit.dart';
import 'package:careme24/blocs/application/application_state.dart';
import 'package:careme24/blocs/auth/cubit.dart';
import 'package:careme24/theme/app_colors.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({
    super.key,
  });

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  TextEditingController textEditingController = TextEditingController();

  late Timer timer;
  int _start = 60;

  void startTimer() {
    setState(() {
      _start = 10;
    });
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  String? token = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
    super.initState();
    _initializeFirebase();
  }

  @override
  void dispose() {
    errorController!.close();
    timer.cancel();

    super.dispose();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get the FCM token
    token = await messaging.getToken();
    log("FCM Token: $token");
  }

  void doOnTrue() {
    context.read<ApplicationCubit>().emit(
          ApplicationCompleted(isAuthorized: true, error: false),
        );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AppContainer(0)),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyState) {
            state.data.isSuccess ? doOnTrue() : log('false');
          }
        },
        child: Scaffold(
          appBar: AppBar(),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 8.0),
                      child: Text(
                        'Введите код',
                        style: Theme.of(context).textTheme.headlineSmall!.merge(
                            const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60.0),
                      child: Text(
                        'Введите код подтверждения из SMS-сообщение, отправленный на номер',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      child: PinCodeTextField(
                        controller: textEditingController,
                        errorAnimationController: errorController,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 56,
                          fieldWidth: 46,
                          inactiveColor: Theme.of(context)
                              .inputDecorationTheme
                              .enabledBorder!
                              .borderSide
                              .color,
                          activeColor: Theme.of(context).primaryColor,
                          selectedColor: Theme.of(context).primaryColor,
                          errorBorderColor: AppColors.errorBorderColor,
                        ),
                        appContext: context,
                        length: 4,
                        onCompleted: (value) async {
                          if (value.length == 4) {
                            final response =
                                await AppBloc.authCubit.verify(value, token!);
                            if (!response.isSuccess) {
                              ElegantNotification.error(
                                      description: const Text('Неверный код'))
                                  .show(context);
                            }
                          }
                        },
                      ),
                    ),
                    Text(
                      hasError ? 'Неверный код' : '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .merge(const TextStyle(color: Colors.red)),
                    ),
                    _start > 0
                        ? Center(
                            child: Text(
                              'Повторно отправить код (через $_start секунд)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          )
                        : Container(),
                    _start == 0
                        ? Center(
                            child: InkWell(
                              onTap: () {
                                startTimer();
                              },
                              child: Text(
                                'Отправить повторно',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .merge(
                                      TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
