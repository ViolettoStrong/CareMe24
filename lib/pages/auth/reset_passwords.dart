import 'dart:developer';

import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/auth/cubit.dart';
import 'package:careme24/pages/auth/verify_code_reset_page.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditEmailPage extends StatefulWidget {
  final bool loginPage;
  const EditEmailPage({super.key, this.loginPage = false});

  @override
  State<EditEmailPage> createState() => _EditEmailPageState();
}

class _EditEmailPageState extends State<EditEmailPage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mypasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  String countryCode = '+7';
  bool isContinue = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeResetState) {
            log('do');
            state.data.isSuccess
                ? Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VerifyCodeResetPage(
                          loginPage: widget.loginPage,
                          password: _passwordController.text,
                          email: _controller.text,
                        )))
                : null;
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SafeArea(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 32, bottom: 8.0),
                        child: Text(
                          'Редактирование ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .merge(const TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 26.0),
                        child: Text(
                          'Введите ваш email или номер телефона и новый пароль',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      // Text('Email', style: TextStyle(color: Color.fromRGBO(164, 165, 165, 1), fontSize: 17, fontWeight: FontWeight.w700)),

                      // Container(
                      //   padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                      //   child: TextFormField(
                      //     controller: _controllerEmail,
                      //     /* inputFormatters: [
                      //       MaskTextInputFormatter(
                      //           mask: '### ### ## ##',
                      //           filter: {"#": RegExp(r'[0-9]')},
                      //           type: MaskAutoCompletionType.lazy),
                      //     ], */
                      //     decoration: InputDecoration(
                      //       hintText: 'Введите email',
                      //       hintStyle: TextStyle(color: Color.fromRGBO(164, 165, 165, 1), fontSize: 16, fontWeight: FontWeight.w500),
                      //       contentPadding: EdgeInsets.all(8)
                      //      /*  prefixIcon: CountryCodePicker(
                      //         onChanged: (code) => setState(() {
                      //           countryCode = code.dialCode!;
                      //         }),
                      //         flagWidth: 29,
                      //         padding: EdgeInsets.zero,
                      //         initialSelection: 'RU',
                      //         favorite: const ['+39', 'FR'],
                      //       ), */
                      //     ),
                      //   ),
                      // ),

                      const Text('Email или номер телефона',
                          style: TextStyle(
                              color: Color.fromRGBO(164, 165, 165, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),

                      Container(
                        padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                        child: TextFormField(
                          controller: _controller,
                          /* inputFormatters: [
                            MaskTextInputFormatter(
                                mask: '### ### ## ##',
                                filter: {"#": RegExp(r'[0-9]')},
                                type: MaskAutoCompletionType.lazy),
                          ], */
                          decoration: const InputDecoration(
                              hintText: 'Введите email или номер телефона',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 165, 165, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              contentPadding: EdgeInsets.all(8)
                              /*  prefixIcon: CountryCodePicker(
                              onChanged: (code) => setState(() {
                                countryCode = code.dialCode!;
                              }),
                              flagWidth: 29,
                              padding: EdgeInsets.zero,
                              initialSelection: 'RU',
                              favorite: const ['+39', 'FR'],
                            ), */
                              ),
                        ),
                      ),
                      widget.loginPage == false
                          ? const Text('Пароль',
                              style: TextStyle(
                                  color: Color.fromRGBO(164, 165, 165, 1),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700))
                          : Container(),
                      widget.loginPage == false
                          ? Container(
                              margin: const EdgeInsets.only(
                                top: 8,
                                bottom: 16.0,
                              ),
                              child: TextFormField(
                                controller: _mypasswordController,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(8),
                                    hintText: 'Введите ваш действуйщий пароль',
                                    hintStyle: TextStyle(
                                        color: Color.fromRGBO(164, 165, 165, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                            )
                          : Container(),
                      const Text('Пароль',
                          style: TextStyle(
                              color: Color.fromRGBO(164, 165, 165, 1),
                              fontSize: 17,
                              fontWeight: FontWeight.w700)),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintText: 'Введите ваш новый пароль',
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(164, 165, 165, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 62.0),
                          child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final savedPassword =
                                      prefs.getString('password') ?? '';
                                  if (widget.loginPage == false) {
                                    if (_mypasswordController.text.trim() !=
                                        savedPassword) {
                                      ElegantNotification.error(
                                        description:
                                            const Text('Неверный пароль'),
                                      ).show(context);
                                      return;
                                    }
                                    if (_mypasswordController.text.trim() ==
                                        _passwordController.text.trim()) {
                                      ElegantNotification.error(
                                        description: const Text(
                                            'Новый пароль не должен совпадать с текущим'),
                                      ).show(context);
                                      return;
                                    }
                                    final response =
                                        await AppBloc.authCubit.resetPassoword(
                                      _controller.text.trim(),
                                    );
                                    if (!response.isSuccess) {
                                      ElegantNotification.error(
                                              description:
                                                  const Text('Неверные данные'))
                                          .show(context);
                                    }
                                  } else {
                                    final response =
                                        await AppBloc.authCubit.resetPassoword(
                                      _controller.text.trim(),
                                    );
                                    if (!response.isSuccess) {
                                      ElegantNotification.error(
                                              description:
                                                  const Text('Неверные данные'))
                                          .show(context);
                                    }
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: const LinearGradient(colors: [
                                        Color.fromRGBO(65, 73, 255, 1),
                                        Color.fromRGBO(41, 142, 235, 1),
                                      ])),
                                  child: Center(
                                    child: Text(
                                      'Продолжить',
                                      style: AppStyle.txtMontserratf18w600,
                                    ),
                                  ),
                                ),
                              ))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
