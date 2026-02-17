import 'package:careme24/api/api.dart';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/dangerous/dangerous_cubit.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/models/institution_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/models/request_status_model.dart';
import 'package:careme24/pages/calls/dialog_select_contact_med.dart';
import 'package:careme24/pages/calls/main_call_page.dart';
import 'package:careme24/pages/calls/police_call_page.dart';
import 'package:careme24/pages/calls/select_instituts.dart';
import 'package:careme24/repositories/medcard_repository.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/service/pref_service.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/widgets/for_whom.dart';
import 'package:careme24/widgets/paid_service_swither.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoliceCallButton extends StatefulWidget {
  const PoliceCallButton({
    super.key,
    required this.text,
    required this.selectedContact,
  });

  final String text;
  final MedcardModel? selectedContact;

  @override
  State<PoliceCallButton> createState() => _PoliceCallPageState();
}

class _PoliceCallPageState extends State<PoliceCallButton> {
  bool on = false;
  bool default_institution = false;
  bool isNotifContact = false;
  InstitutionModel? institutionModel;
  String distance = '';
  String duration = '';
  List<Map<String, dynamic>>? favours;

  @override
  void initState() {
    setValue();
    super.initState();
    _loadDefaultInstitution('pol');
    widget.selectedContact != null
        ? _selectedContact = widget.selectedContact
        : _selectedContact = null;
    if (_selectedContact == null) {
      MedcardRepository.fetchMyCard().then((value) {
        AppBloc.requestCubit.medCardId = value.id;
      });
    } else {
      AppBloc.requestCubit.medCardId = _selectedContact?.id ?? '';
    }
  }

  Future<void> _loadNearestInstitution() async {
    final userLat = BlocProvider.of<DangerousCubit>(context).lat;
    final userLon = BlocProvider.of<DangerousCubit>(context).lon;
    final res = await Api.loadNearestInstitution(
        lat: userLat, lon: userLon, institutionType: 'pol');
    if (res != null) {
      setState(() {
        institutionModel = InstitutionModel.fromJson(res['institution']);
        distance = res['distance'].toString();
        duration = res['duration'].toString();
      });
      _loadFavours(institutionModel!.id);
    }
  }

  Future<void> _loadFavours(String institutionId) async {
    final list = await Api.getRequestFavours(institutionId);
    if (mounted) setState(() => favours = list);
  }

  Future<void> _loadDefaultInstitution(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = 'default_institution_$type';

    final id = prefs.getString('${prefix}_id');
    if (id == null) {
      await _loadNearestInstitution();
      return;
    }

    setState(() {
      institutionModel = InstitutionModel(
        id: id,
        name: prefs.getString('${prefix}_name') ?? '',
        commercial: prefs.getBool('${prefix}_commercial') ?? false,
        type: type,
        address: prefs.getString('${prefix}_address') ?? '',
        location: Location(
          type: "Point",
          coordinates: [
            prefs.getDouble('${prefix}_lon') ?? 0.0,
            prefs.getDouble('${prefix}_lat') ?? 0.0,
          ],
        ),
        favourite: prefs.getBool('${prefix}_favourite') ?? false,
        reviews: prefs.getStringList('${prefix}_reviews') ?? [],
        averageRating: prefs.getDouble('${prefix}_average_rating') ?? 0.0,
        minPrice: prefs.getDouble('${prefix}_min_price') ?? 0.0,
        maxPrice: prefs.getDouble('${prefix}_max_price') ?? 0.0,
      );

      distance = prefs.getString('${prefix}_distance') ?? '--';
      duration = prefs.getString('${prefix}_duration') ?? '--';
    });
    if (institutionModel != null) _loadFavours(institutionModel!.id);
  }

  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotifContact = prefs.getBool('pay_switch_value_notif_tome') ?? false;
    });
  }

  MedcardModel? _selectedContact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.gray100,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          height: getVerticalSize(48),
          leadingWidth: 43,
          leading: AppbarImage(
              height: getVerticalSize(16),
              width: getHorizontalSize(11),
              svgPath: ImageConstant.imgArrowleft,
              margin: getMargin(left: 32, top: 12, bottom: 20),
              onTap: () async {
                final stop = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Остановить процесс?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Нет'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Да'),
                      ),
                    ],
                  ),
                );
                if (stop == true && context.mounted) {
                  Navigator.pushReplacementNamed(context, AppRouter.appContainer);
                }
              }),
          centerTitle: true,
          title: AppbarTitle(text: "Вызов полиции"),
          styleType: Style.bgFillBlue60001),
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
            padding: getPadding(left: 24, top: 17, right: 24),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () async {
                          final selectedContact =
                              await showDialog<MedcardModel>(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return const ContactSelectDialogMed();
                            },
                          );
                          setState(() {
                            _selectedContact = selectedContact;
                          });
                          if (selectedContact != null) {
                            AppBloc.requestCubit.medCardId = selectedContact.id;
                          } else {
                            MedcardRepository.fetchMyCard().then((value) {
                              if (value != null) {
                                AppBloc.requestCubit.medCardId = value.id;
                              }
                            });
                          }
                        },
                        child: ForWhom(
                          name:
                              _selectedContact?.personalInfo.full_name ?? 'Мне',
                        ),
                      )),
                  Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Center(
                            child: Text(
                              'Платная услуга',
                              style: TextStyle(
                                  color: VersionConstant.free
                                      ? const Color(0xFF9E9E9E)
                                      : Colors.green),
                            ),
                          )),
                      Column(
                        children: [
                          PaySwitcher(
                            on: VersionConstant.free,
                            onChanged: (value) {
                              setState(() {
                                VersionConstant.free = value;
                              });
                            },
                          ),
                          Text(''),
                        ],
                      )
                    ],
                  ),
                ])),
        GestureDetector(
          onTap: () {
            if (institutionModel != null && (favours == null || favours!.isEmpty)) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PoliceCallPage(
                  favours: favours,
                  selectedContact: _selectedContact,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(top: 14, bottom: 24),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              color: Color.fromRGBO(178, 218, 255, 100),
            ),
            width: MediaQuery.of(context).size.width - 40,
            height: 80,
            child: Padding(
              padding: getPadding(left: 20, right: 20, top: 20, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      institutionModel != null && (favours == null || favours!.isEmpty)
                          ? 'Учреждение не работает'
                          : (widget.text.isEmpty ? 'Выбрать причину' : widget.text),
                      style: AppStyle.txtMontserratSemiBold19,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: MediaQuery.sizeOf(context).height * 0.3,
          margin: const EdgeInsets.symmetric(horizontal: 33.5),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 0),
                blurRadius: 14.0,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (institutionModel != null && (favours == null || favours!.isEmpty)) {
                          ElegantNotification.error(
                            description: const Text('Учреждение не работает'),
                          ).show(context);
                          return;
                        }
                        if (favours != null && favours!.isNotEmpty && widget.text.isEmpty) {
                          ElegantNotification.error(
                            description: const Text('Выберите причину'),
                          ).show(context);
                          return;
                        }
                        setState(() {
                          on = !on;
                        });
                        if (on) {
                          RequestStatusModel resopnse =
                              await AppBloc.requestCubit.createRequest(
                                  widget.text,
                                  'pol',
                                  false,
                                  institutionModel?.id ?? '');
                          if (resopnse.isSuccess) {
                            if (widget.selectedContact != null) {
                              dynamic res = await Api.fetchCallsData(
                                  'pol', widget.selectedContact!.id);
                              if (res != null) {
                                ElegantNotification.success(
                                        description: const Text(
                                            'Вызов успешно отправлен'))
                                    .show(context);
                                await Future.delayed(
                                    const Duration(seconds: 2));
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainCallPage(
                                      text: 'Вызов полиции',
                                      requestId: res.values.first['id'],
                                      show: isNotifContact,
                                      type: 'pol',
                                      latestCalls: res,
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                            } else {
                              dynamic cardId =
                                  await MedcardRepository.fetchMyCard();
                              if (cardId != null) {
                                dynamic res =
                                    await Api.fetchCallsData('pol', cardId.id);
                                if (res != null) {
                                  ElegantNotification.success(
                                    description:
                                        const Text('Вызов успешно отправлен'),
                                  ).show(context);
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainCallPage(
                                        text: 'Вызов полиции',
                                        requestId: res.values.first['id'],
                                        show: isNotifContact,
                                        type: 'pol',
                                        latestCalls: res,
                                      ),
                                    ),
                                  );
                                }
                              }
                            }
                          } else {
                            ElegantNotification.error(
                                    description:
                                        const Text('Неудалось вызвать полицию'))
                                .show(context);
                            setState(() {
                              on = false;
                            });
                          }
                        }
                      },
                      child: Opacity(
                        opacity: (institutionModel != null && (favours == null || favours!.isEmpty)) ||
                                (favours != null && favours!.isNotEmpty && widget.text.isEmpty)
                            ? 0.5
                            : 1,
                        child: SvgPicture.asset(on
                            ? 'assets/images/p_on.svg'
                            : 'assets/images/p_off.svg'),
                      ))),
              Text(
                'Вызвать полицию',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: (institutionModel != null && (favours == null || favours!.isEmpty)) ||
                            (favours != null && favours!.isNotEmpty && widget.text.isEmpty)
                        ? Colors.grey
                        : const Color.fromRGBO(219, 19, 91, 1)),
              )
            ],
          ),
        ),
        const SizedBox(height: 20),
        institutionModel == null
            ? Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SelectInstituts(type: 'pol')))
                        .then((result) {
                      setState(() {
                        institutionModel = result['institution'];
                        distance = result['distance'] ?? '';
                        duration = result['duration'] ?? '';
                      });
                      if (institutionModel != null) {
                        _loadFavours(institutionModel!.id);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    margin: const EdgeInsets.symmetric(horizontal: 23),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(41, 142, 235, 1),
                          Color.fromRGBO(65, 73, 255, 1),
                        ])),
                    child: const Center(child: SizedBox()),
                  ),
                ))
            : Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () async {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SelectInstituts(type: 'pol')))
                        .then((result) {
                      setState(() {
                        institutionModel = result['institution'];
                        distance = result['distance'] ?? '';
                        duration = result['duration'] ?? '';
                      });
                      if (institutionModel != null) {
                        _loadFavours(institutionModel!.id);
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 16, left: 31, right: 31, bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 5,
                          color: Color.fromRGBO(0, 0, 0, 0.24),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 67,
                              height: 80,
                              decoration: BoxDecoration(
                                color: ColorConstant.indigoA100,
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(30)),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomImageView(
                                    svgPath: ImageConstant.policehat,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    institutionModel?.name ?? '',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(51, 132, 226, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    institutionModel?.address ?? '',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(142, 150, 155, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromRGBO(221, 222, 226, 1),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 14, top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${distance.length > 5 ? distance.substring(0, 6) : distance} км',
                                style: const TextStyle(
                                  color: Color(0xFF2C3E4F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 12),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 18, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    institutionModel!.averageRating
                                        .toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Color(0xFF2C3E4F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Ср. цена: ${((institutionModel!.minPrice + institutionModel!.maxPrice) / 2).round()}',
                                style: const TextStyle(
                                  color: Color(0xFF2C3E4F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 5),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 14, bottom: 14, top: 15),
                          child: Row(
                            children: [],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
      ]),
      floatingActionButton: default_institution
          ? FloatingActionButton(
              backgroundColor: ColorConstant.blue60001,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение'),
                    content: const Text(
                      'Найти ближайшее учреждение?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Отмена'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // փակել dialog-ը
                          await _loadNearestInstitution();
                        },
                        child: const Text('Да'),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.alt_route),
            )
          : null,
    );
  }
}
