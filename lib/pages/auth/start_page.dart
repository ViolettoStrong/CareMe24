import 'package:careme24/app_container.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  final List<String> options = [
    'assets/home_images/1.png',
    'assets/home_images/2.png',
    'assets/home_images/3.png',
    'assets/home_images/4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height - 290,
            child: Stack(
              children: [
                Positioned.fill(
                  child: PageView.builder(
                    onPageChanged: (page) {
                      setState(() {
                        currentPage = page;
                      });
                    },
                    controller: _pageController,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) =>
                        Image.asset(
                      options[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 55,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: options
                        .map((item) => AnimatedContainer(
                              duration: const Duration(milliseconds: 50),
                              height: 8,
                              width: 8,
                              margin: const EdgeInsets.only(right: 8.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: currentPage == options.indexOf(item)
                                      ? Colors.white
                                      : const Color.fromRGBO(
                                          177, 177, 177, 0.6)),
                            ))
                        .toList(),
                  ),
                ),
                Positioned(
                  bottom: 85,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset('./assets/logo.svg'),
                ),
                Positioned(
                  bottom: -2,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.bluegradient,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    height: 30,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(23),
              decoration: BoxDecoration(
                color: ColorConstant.bluegradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'CareMe24',
                      style: AppStyle.txtMontserratf20w700,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 33),
                      child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRouter.registerEmailPage);
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromRGBO(255, 89, 99, 1),
                                    Color.fromRGBO(224, 14, 102, 1)
                                  ])),
                              child: Center(
                                child: Text(
                                  'Регистрация',
                                  style: AppStyle.txtMontserratf18w600,
                                ),
                              ),
                            ),
                          ))),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: SvgPicture.asset('./assets/ru_flag.svg'),
                          ),
                          const Text('RU'),
                          const Icon(Icons.arrow_drop_down_sharp),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text('Уже есть аккаунт?',
                              style: AppStyle.txtMontserratf13w600),
                        ),
                        InkWell(
                          onTap: () {
                            //Navigator.pushNamed(context, AppRouter.loginPage);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AppContainer(0)),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text('Войти',
                              style: AppStyle.txtMontserratf15w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
