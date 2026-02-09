import 'package:cached_network_image/cached_network_image.dart';
import 'package:careme24/blocs/drawer/drawer_cubit.dart';
import 'package:careme24/blocs/drawer/drawer_state.dart';
import 'package:careme24/pages/medical_bag/medical_bag_page.dart';
import 'package:careme24/pages/medical_bag/widgets/custom_gradient_button.dart';
import 'package:careme24/router/app_router.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<bool> centerSwitchNotifier = ValueNotifier(false);
ValueNotifier<bool> shakeSwitchNotifier = ValueNotifier(false);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String lat = '';
  String long = '';
  late bool centerValue = false;
  late bool shakeValue = false;
  Country? _selectedCountry = Country.parse('RU'); // default Россия

  @override
  void initState() {
    super.initState();
    _loadSavedSwitchValue();
    _determinePosition();
  }

  Future<void> _loadSavedSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    bool? cValue = prefs.getBool('center_shake_switch_value');
    bool? sValue = prefs.getBool('volume_shake_switch_value');
    if (cValue != null) {
      centerValue = cValue;
    } else {
      centerValue = false;
    }
    if (sValue != null) {
      shakeValue = sValue;
    } else {
      shakeValue = false;
    }
  }

  Future<void> _determinePosition() async {
    Position location = await Geolocator.getCurrentPosition();
    setState(() {
      lat = location.latitude.toString();
      long = location.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: getVerticalSize(48),
        leadingWidth: 43,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: AppbarTitle(
          text: "Настройки",
        ),
        styleType: Style.bgFillBlue60001,
        actions: const [],
      ),
      body: SafeArea(child:
          BlocBuilder<DrawerCubit, DrawerState>(builder: (context, state) {
        if (state is DrawerStateLoaded) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle(title: ' МОЙ АККАУНТ'),
                Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundImage: CachedNetworkImageProvider(
                                    state.userInfo.personalInfo.avatar,
                                    scale: 1),
                                child:
                                    state.userInfo.personalInfo.avatar == '' ||
                                            state.userInfo.personalInfo.avatar
                                                .isEmpty
                                        ? const Icon(Icons.person, size: 26)
                                        : null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      state.userInfo.personalInfo.full_name,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      state.userInfo.phone.toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                const SizedBox(height: 24),
                const SectionTitle(title: 'МОЯ ГЕОЛОКАЦИЯ'),
                const SizedBox(height: 8),
                AddButtonSettings(
                  title: '[$lat, $long]',
                  onTap: () {},
                ),
                SectionTitle(title: 'ЯЗЫК ПРИЛОЖЕНИЯ'),
                const SizedBox(height: 8),
                AddButtonSettings(
                  title: _selectedCountry == null
                      ? 'Выберите страну'
                      : '${_selectedCountry!.name} ${_selectedCountry!.flagEmoji}',
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: false,
                      onSelect: (Country country) {
                        setState(() {
                          _selectedCountry = country;
                        });
                      },
                    );
                  },
                ),
                SectionTitle(title: 'Я ОЧЕВИДЕЦ'),
                const SizedBox(height: 8),
                Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width - 100,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: const Text(
                            'Зажать центр экрана + потрясти',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      SquareSwitch(
                        value: centerValue,
                        onChanged: (value) {
                          setState(() {
                            centerValue = value;
                          });
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setBool('center_shake_switch_value', value);
                            centerSwitchNotifier.value = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width - 100,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: const Text(
                            'Зажать кнопку громкости вверх + потрясти',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                      SquareSwitch(
                        value: shakeValue,
                        onChanged: (value) {
                          setState(() {
                            shakeValue = value;
                          });
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setBool('volume_shake_switch_value', value);
                            shakeSwitchNotifier.value = value;
                          });
                        },
                      ),
                    ],
                  ),
                ]),
                const Spacer(),
                AddButtonSettings(
                  title: 'Удалить аккаунт',
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AddMedicineDialogSettings();
                      },
                    );
                    //       Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MedicineListScreen(title: "title")),
                    // );
                    // Handle "Добавить" button
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRouter.resetEmailPhone);
                        },
                        child: Text(
                          'Изменить email или номер телефона',
                          textAlign: TextAlign.center,
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
                )
              ],
            ),
          );
        }
        return Container();
      })),
    );
  }
}

class AddButtonSettings extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AddButtonSettings({Key? key, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddMedicineDialogSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, DrawerState>(builder: (context, state) {
      if (state is DrawerStateDeletingAccount) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is DrawerStateDeleteFailure) {
        return Text("Error: ${state.errorMessage}",
            style: const TextStyle(color: Colors.red));
      }
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        content: SizedBox(
          height: 230,
          width: MediaQuery.of(context).size.width - 20,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close,
                              size: 34,
                            ))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: const Text(
                        'Вы уверены, что хотите удалить учетную запись CareMe24?',
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            fontFamily: "Montserrat",
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CustomGradientButton(
                        text: 'Да',
                        onPressed: () {
                          context.read<DrawerCubit>().deletAccount(context);
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CustomGradientRedButton(
                        text: 'Нет',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class SquareSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SquareSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 55,
        height: 35,
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(4), // square
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 25,
            height: 31,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4), // square thumb
            ),
          ),
        ),
      ),
    );
  }
}
