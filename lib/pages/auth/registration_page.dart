import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/auth/cubit.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String countryCode = '+7';
  bool isContinue = true;
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
                    padding: const EdgeInsets.only(top: 32, bottom: 8.0),
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
                      'Мы отправим на номер SMS-сообщение с кодом подтверждения.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 62.0),
                    child: TextFormField(
                      controller: _controller,
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '### ### ## ##',
                            filter: {"#": RegExp(r'[0-9]')},
                            type: MaskAutoCompletionType.lazy),
                      ],
                      decoration: InputDecoration(
                        hintText: '000 000 00 00',
                        prefixIcon: CountryCodePicker(
                          onChanged: (code) => setState(() {
                            countryCode = code.dialCode!;
                          }),
                          flagWidth: 29,
                          padding: EdgeInsets.zero,
                          initialSelection: 'RU',
                          favorite: const ['+39', 'FR'],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              String phoneNumber =
                                  '$countryCode ${_controller.text}'
                                      .replaceAll(" ", "");
                              final response =
                                  await AppBloc.authCubit.register(phoneNumber);
                              if (!response.isSuccess) {
                                ElegantNotification.error(
                                        description:
                                            const Text('Неверные данные'))
                                    .show(context);
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
                                  'Получить код',
                                  style: AppStyle.txtMontserratf18w600,
                                ),
                              ),
                            ),
                          ))),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text('Уже есть аккаунт?',
                              style: TextStyle(
                                  color: Color.fromRGBO(28, 29, 30, 1),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, AppRouter.loginPage);
                          },
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
