import 'dart:async';
import 'dart:developer';
import 'package:careme24/api/api.dart';
import 'package:careme24/app_container.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/auth/cubit.dart';
import 'package:careme24/pages/auth/login_page.dart';
import 'package:careme24/theme/app_colors.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyCodeResetMailPage extends StatefulWidget {
  final String phone;
  final String email;

  const VerifyCodeResetMailPage({
    required this.phone,
    required this.email,
    super.key,
  });

  @override
  State<VerifyCodeResetMailPage> createState() => _VerifyCodeResetPageState();
}

class _VerifyCodeResetPageState extends State<VerifyCodeResetMailPage> {
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
  final _formKey = GlobalKey<FormState>();
  bool isEmail = false;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
    super.initState();
    log(widget.email);
    log(widget.phone);
    isEmail = widget.email.contains('@');
    changeEmail();
  }

  Future<void> changeEmail() async {
    if (isEmail) {
      await Api.resetEmailResponse();
    }
  }

  @override
  void dispose() {
    errorController!.close();
    timer.cancel();

    super.dispose();
  }

  void doOnTrue() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyResetPasswordState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AppContainer(0)),
              (Route<dynamic> route) => false,
            );
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
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Text(
                        isEmail
                            ? 'Введите код подтверждения из SMS-сообщения, отправленный на ваш номер телефона'
                            : 'Введите код подтверждения из сообщения, отправленный на вашу почту',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Text(
                        '',
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
                        length: isEmail ? 4 : 6,
                        onCompleted: (value) async {
                          if (value.length >= 4) {
                            final response;
                            if (isEmail == true) {
                              response = await AppBloc.authCubit
                                  .verifyResetMail(
                                      int.parse(value), widget.email);
                            } else {
                              response = await AppBloc.authCubit
                                  .verifyResetMail(
                                      int.parse(value), widget.phone);
                            }
                            if (!response.isSuccess) {
                              ElegantNotification.error(
                                      description: const Text('Неверный код'))
                                  .show(context);
                              await Future.delayed(
                                  const Duration(milliseconds: 2500));
                            } else {
                              ElegantNotification.success(
                                      description:
                                          const Text('Данные успешно изменены'))
                                  .show(context);
                              await Future.delayed(
                                  const Duration(milliseconds: 2500));
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
