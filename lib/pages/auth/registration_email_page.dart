import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/auth/cubit.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RegistrationEmailPage extends StatefulWidget {
  const RegistrationEmailPage({super.key});

  @override
  State<RegistrationEmailPage> createState() => _RegistrationEmailPageState();
}

class _RegistrationEmailPageState extends State<RegistrationEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String countryCode = '+7';
  bool isContinue = true;
  bool isConn = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthCodeState) {
          state.data.isSuccess
              ? Navigator.pushNamed(context, AppRouter.verificationPage)
              : null;
        }
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 8.0),
                    child: Text(
                      'Регистрация',
                      style: Theme.of(context).textTheme.headlineSmall!.merge(
                          const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26.0),
                    child: Text(
                      'Введите ваш email и придумайте пароль',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const Text('Email',
                      style: TextStyle(
                          color: Color.fromRGBO(164, 165, 165, 1),
                          fontSize: 17,
                          fontWeight: FontWeight.w700)),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          hintText: 'Введите email',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(164, 165, 165, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
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
                          hintText: 'Придумайте пароль',
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(164, 165, 165, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const Row(
                    children: [
                      Spacer(),
                      Text(
                        'Пароль должен состоять минимум из 6 символов',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(173, 173, 173, 1)),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    value: isConn,
                    activeColor: Colors.green,
                    // սվիչը կփոխի միայն state-ը
                    onChanged: (bool value) {
                      setState(() {
                        isConn = value;
                      });
                    },
                    title: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const InstructionPage(),
                          ),
                        );
                      },
                      child: const Text('Согласие на обработку данных'),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              if (isConn == false) {
                                ElegantNotification.error(
                                        description: const Text(
                                            'Необходимо ваше согласие на обработку данных'))
                                    .show(context);
                              } else if (_passwordController.text.length < 6) {
                                ElegantNotification.error(
                                        description: const Text(
                                            'Пароль должен состоять минимум из 6 символов'))
                                    .show(context);
                              } else if (!EmailValidator.validate(
                                  _emailController.text)) {
                                ElegantNotification.error(
                                        description: const Text(
                                            'Введите корректный email'))
                                    .show(context);
                              } else {
                                AppBloc.authCubit.setEmailPassword(
                                    _emailController.text,
                                    _passwordController.text);
                                Navigator.pushNamed(
                                    context, AppRouter.registerPage);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
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
                  SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          "Инструкция по работе CareMe24",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InstructionPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InstructionPage(),
                            ),
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/logo.svg',
                          width: 68,
                          height: 68,
                        ),
                      ),
                    ],
                  ),
                  /*Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 75, bottom: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            'Уже есть аккаунт?',
                            style: TextStyle(
                              color: Color.fromRGBO(28, 29, 30, 1),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, AppRouter.loginPage),
                          style: TextButton.styleFrom(
                            // Add padding to increase clickable area
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            // Ensure minimum touch target size
                            minimumSize: const Size(48, 36),
                            // Align the text properly within the button
                            alignment: Alignment.center,
                          ),
                          child: Text(
                            'Войти',
                            style:
                                Theme.of(context).textTheme.bodyMedium!.merge(
                                      TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Spacer()*/
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Уже есть аккаунт?',
                style: TextStyle(
                  color: Color.fromRGBO(28, 29, 30, 1),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, AppRouter.loginPage),
                child: Text(
                  'Войти',
                  style: Theme.of(context).textTheme.bodyMedium!.merge(
                        TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InstructionPage extends StatelessWidget {
  const InstructionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Инструкция по работе CareMe24",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "Текст Текст Текст Текст Текст Текст Текст Текст Текст Текст "
            "Текст Текст Текст Текст Текст Текст Текст Текст Текст Текст "
            "Текст Текст Текст Текст Текст Текст Текст Текст Текст Текст "
            "Текст Текст Текст Текст Текст Текст Текст Текст Текст Текст "
            "Текст Текст Текст Текст Текст Текст Текст Текст Текст Текст "
            "Текст Текст Текст Текст Текст Текст Текст Текст Текст Текст "
            "Текст Текст Текст Текст Текст Текст Текст Текст Текст Текст ",
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ),
    );
  }
}
