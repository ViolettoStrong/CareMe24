import 'dart:developer';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/auth/cubit.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  String countryCode = '+7';
  bool isContinue = true;
  bool isPhoneNumber = false;
  final TextEditingController _controller = TextEditingController();

  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '### ### ## ##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLogin = prefs.getString('login') ?? '';
    final savedPassword = prefs.getString('password') ?? '';

    _passwordController.text = savedPassword;

    final startsWithDigit =
        RegExp(r'^\d').hasMatch(savedLogin) || savedLogin.startsWith('+');

    setState(() {
      isPhoneNumber = startsWithDigit;

      if (isPhoneNumber) {
        if (savedLogin.startsWith('+7')) {
          countryCode = '+7';
          _controller.text = savedLogin.replaceFirst('+7', '').trim();
        } else {
          _controller.text = savedLogin;
        }
      } else {
        _controller.text = savedLogin;
      }
    });
  }

  void _onInputChanged(String value) {
    final rawValue = value.replaceAll(' ', '');
    bool isNowPhoneNumber = RegExp(r'^\d+$').hasMatch(rawValue);

    if (isNowPhoneNumber != isPhoneNumber) {
      final oldText = _controller.text;

      setState(() {
        isPhoneNumber = isNowPhoneNumber;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthCodeState) {
          log('do');
          if (state.data.isSuccess) {
            Navigator.pushNamed(context, AppRouter.verificationPage);
          }
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
                        'Вход',
                        style: Theme.of(context).textTheme.headlineSmall!.merge(
                            const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 26.0),
                      child: Text(
                        'Мы отправим на номер SMS-сообщение с кодом подтверждения.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Text(
                      'Почта или номер телефона',
                      style: TextStyle(
                        color: Color.fromRGBO(164, 165, 165, 1),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 8),
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        onChanged: _onInputChanged,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          hintStyle: const TextStyle(
                              color: Color.fromRGBO(164, 165, 165, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          hintText: isPhoneNumber
                              ? '000 000 00 00'
                              : 'Почта или номер телефона',
                          prefixIcon: isPhoneNumber
                              ? CountryCodePicker(
                                  onChanged: (code) => setState(() {
                                    countryCode = code.dialCode!;
                                  }),
                                  flagWidth: 29,
                                  padding: EdgeInsets.zero,
                                  initialSelection: 'RU',
                                  favorite: const ['+39', 'FR'],
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Text(
                      'Пароль',
                      style: TextStyle(
                        color: Color.fromRGBO(164, 165, 165, 1),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Пароль',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(164, 165, 165, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
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
                              String inputText = _controller.text.trim();
                              String phoneNumber =
                                  '$countryCode $inputText'.replaceAll(" ", "");

                              final response = await AppBloc.authCubit.login(
                                  isPhoneNumber ? phoneNumber : inputText,
                                  _passwordController.text.trim());

                              if (!response.isSuccess) {
                                ElegantNotification.error(
                                  description: const Text('Неверные данные'),
                                ).show(context);
                              } else {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('password',
                                    _passwordController.text.trim());
                                await prefs.setString(
                                    'login', _controller.text.trim());
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(colors: [
                                  Color.fromRGBO(65, 73, 255, 1),
                                  Color.fromRGBO(41, 142, 235, 1),
                                ]),
                              ),
                              child: Center(
                                child: Text(
                                  'Получить код',
                                  style: AppStyle.txtMontserratf18w600,
                                ),
                              ),
                            ),
                          ),
                        )),
                    SizedBox(height: MediaQuery.of(context).size.height / 6.5),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Нет аккаунта?',
                              style: TextStyle(
                                  color: Color.fromRGBO(28, 29, 30, 1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRouter.registerEmailPage);
                            },
                            child: Text(
                              'Зарегистрироваться',
                              style:
                                  Theme.of(context).textTheme.bodyMedium!.merge(
                                        TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRouter.editEmail,
                              arguments: true);
                        },
                        child: Text(
                          'Забыли пароль?',
                          style: Theme.of(context).textTheme.bodyMedium!.merge(
                                TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
