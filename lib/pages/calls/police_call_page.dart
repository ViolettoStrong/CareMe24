import 'dart:async';

import 'package:careme24/api/api.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/models/institution_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/pages/calls/dialog_select_contact_med.dart';
import 'package:careme24/pages/calls/main_call_page.dart';
import 'package:careme24/pages/calls/police_call_button.dart';
import 'package:careme24/repositories/medcard_repository.dart';
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
import 'package:careme24/widgets/reason_police.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoliceCallPage extends StatefulWidget {
  const PoliceCallPage({
    super.key,
    this.favours,
    this.selectedContact,
    this.selectedInstitution,
    this.institutionDistance,
    this.institutionDuration,
  });

  final List<Map<String, dynamic>>? favours;
  final MedcardModel? selectedContact;
  final InstitutionModel? selectedInstitution;
  final String? institutionDistance;
  final String? institutionDuration;

  @override
  State<PoliceCallPage> createState() => _PoliceCallPageState();
}

class _PoliceCallPageState extends State<PoliceCallPage> {
  bool isSelectedSwitch = false;
  MedcardModel? _selectedContact;
  bool isCalling = false;
  dynamic res;
  InstitutionModel? _institutionFromApi;
  List<Map<String, dynamic>>? _favoursFromApi;

  final List<String> reasonText = <String>[
    "3.13. Мелкое хулиганство",
    "3.11. Проведения демонстрации, митинга,пикетирования, шествия или собрания",
    "3.11. Пропаганда либо публич. демонстрирование нацистской атрибутики",
    "3.29. Возбуждение ненависти либо вражды",
    "3.11. Кража",
    "M1.5. Мешают спать по ночам или вызывают беспорядки в общественном месте",
    "3.12. Повреждения имущества",
    "3.28. Тепловой удар",
    "3.12. Приступ астмы, проблемы с дыханием",
    "C7",
    "C8"
  ];

  final List<bool> reasonDisable = <bool>[
    false,
    false,
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  bool isNotifContact = false;
  @override
  void initState() {
    super.initState();
    _selectedContact = widget.selectedContact;
    getMyCalls();
    _loadFavouriteInstitution('pol');
  }

  Future<void> _loadFavouriteInstitution(String type) async {
    try {
      final result = await Api.getFavouriteInstitutions();
      if (result is! List || result.isEmpty) return;
      for (final item in result) {
        final map = item is Map<String, dynamic> ? item : null;
        if (map == null) continue;
        if ((map['type']?.toString() ?? '') == type) {
          final institution = InstitutionModel.fromJson(map);
          final list = await Api.getRequestFavours(institution.id);
          if (!mounted) return;
          setState(() {
            _institutionFromApi = institution.copyWith(favourite: true);
            _favoursFromApi = list;
          });
          return;
        }
      }
    } catch (_) {}
  }

  void setValue() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isNotifContact = prefs.getBool('pay_switch_value_notif_tome') ?? false;
    });
  }

  Future<void> getMyCalls() async {
    dynamic cardId = await MedcardRepository.fetchMyCard();
    if (cardId != null) {
      dynamic response = await Api.fetchCallsData('pol', cardId.id);
      if (response == null || response.isEmpty) {
        setState(() {
          isCalling = false;
        });
      } else {
        setState(() {
          isCalling = true;
          res = response;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.gray100,
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
            height: getVerticalSize(48),
            leadingWidth: 43,
            leading: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
              child: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context)),
            ),
            centerTitle: true,
            title: AppbarTitle(text: "Вызов полиции"),
            styleType: Style.bgFillBlue60001),
        body: Container(
            width: double.maxFinite,
            padding: getPadding(left: 20, right: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                  padding: getPadding(left: 1, top: 17),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ForWhom(
                            name: widget.selectedContact
                                    ?.personalInfo.full_name ??
                                'Мне',
                          ),
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
              Expanded(
                child: Container(
                  padding: getPadding(top: 14),
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 180,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            color: Color.fromRGBO(178, 218, 255, 100),
                          ),
                          width: MediaQuery.of(context).size.width - 40,
                          height: 80,
                          child: Padding(
                            padding: getPadding(left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Причина вызова",
                                  style: AppStyle.txtMontserratSemiBold19,
                                ),
                                CustomImageView(
                                  svgPath:
                                      ImageConstant.imgSettingsLightBlue900,
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            child: _buildReasonList(),
                        )
                      ]),
                ),
              )
            ])));
  }

  Widget _buildReasonList() {
    final favoursList = _favoursFromApi ?? widget.favours;
    if (favoursList != null) {
      if (favoursList.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Данное учреждение в настоящее время недоступно',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }
      final showPaidMode = VersionConstant.free;
      final sortedFavours = List<Map<String, dynamic>>.from(favoursList)
        ..sort((a, b) {
          final aFree = (a['type'] as String? ?? 'free') == 'free';
          final bFree = (b['type'] as String? ?? 'free') == 'free';
          final aActive = showPaidMode ? !aFree : aFree;
          final bActive = showPaidMode ? !bFree : bFree;
          if (aActive == bActive) return 0;
          return aActive ? -1 : 1;
        });
      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: sortedFavours.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildFavourCard(sortedFavours[index]),
      );
    }
    return ListView.separated(
      itemCount: reasonText.length,
      itemBuilder: (BuildContext context, int index) {
        return ReasonPolice(
          onTap: () {
            isCalling
                ? ElegantNotification.error(
                    description: const Text('Заявка уже отправлена'),
                  ).show(context)
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PoliceCallButton(
                              text: reasonText[index],
                              selectedContact: widget.selectedContact,
                              initialInstitution: _institutionFromApi ?? widget.selectedInstitution,
                              initialDistance: _institutionFromApi != null ? '--' : widget.institutionDistance,
                              initialDuration: _institutionFromApi != null ? '--' : widget.institutionDuration,
                              initialFavours: _favoursFromApi ?? widget.favours,
                            )));
          },
          text: reasonText[index],
          disable: reasonDisable[index],
          backgroundColor: Colors.white,
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(indent: 0, height: 1),
    );
  }

  Widget _buildFavourCard(Map<String, dynamic> f) {
    final name = f['name'] as String? ?? '';
    final duration = (f['duration'] as num?)?.toInt() ?? 0;
    final price = (f['price'] as num?)?.toInt() ?? 0;
    final type = f['type'] as String? ?? 'free';
    final isFree = type == 'free';
    final showPaidMode = VersionConstant.free;
    final isActive = showPaidMode ? !isFree : isFree;
    final bgColor = !isActive
        ? Colors.grey.shade200
        : (showPaidMode ? const Color(0xFFFFE4EC) : Colors.white);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          if (!isActive) return;
          if (isCalling) {
            ElegantNotification.error(
              description: const Text('Заявка уже отправлена'),
            ).show(context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PoliceCallButton(
                  text: name,
                  selectedContact: widget.selectedContact,
                  initialInstitution: _institutionFromApi ?? widget.selectedInstitution,
                  initialDistance: _institutionFromApi != null ? '--' : widget.institutionDistance,
                  initialDuration: _institutionFromApi != null ? '--' : widget.institutionDuration,
                  initialFavours: _favoursFromApi ?? widget.favours,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isActive ? 1 : 0.7,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isActive ? const Color(0xFF1A1A1A) : Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.schedule_outlined, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text('$duration мин', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                          const SizedBox(width: 16),
                          Icon(Icons.payments_outlined, size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(price == 0 ? '0 ₽' : '$price ₽', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isFree ? const Color(0xFFE8F5E9) : const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isFree ? 'Бесплатно' : 'Платно',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isFree ? const Color(0xFF2E7D32) : const Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
