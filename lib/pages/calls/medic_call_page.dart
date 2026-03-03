import 'dart:async';
import 'package:careme24/api/api.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/models/institution_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/pages/calls/dialog_select_contact_med.dart';
import 'package:careme24/pages/calls/main_call_page.dart';
import 'package:careme24/pages/calls/medical_call_button.dart';
import 'package:careme24/reason_ambulance.dart';
import 'package:careme24/repositories/medcard_repository.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/for_whom.dart';
import 'package:careme24/widgets/paid_service_swither.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicCallPage extends StatefulWidget {
  const MedicCallPage({
    super.key,
    this.favours,
    this.selectedContact,
    this.selectedInstitution,
    this.institutionDistance,
    this.institutionDuration,
  });

  /// Услуги из /api/requests/favours (если передан с call_button при выборе учреждения)
  final List<Map<String, dynamic>>? favours;
  /// Контакт, выбранный на call_button (для отображения «Для кого»)
  final MedcardModel? selectedContact;
  /// Учреждение, выбранное на call_button (чтобы при выборе услуги не перезагружать из prefs/nearest)
  final InstitutionModel? selectedInstitution;
  final String? institutionDistance;
  final String? institutionDuration;

  @override
  State<MedicCallPage> createState() => _MedicCallPageState();
}

MedcardModel? _selectedContact; 
bool isCalling = false;
dynamic res;

final List<String> reasonText = <String>[
  'M1.8B11 Нарушение речи, слабость в конечеостях',
  "M1.BA41 Сильная боль в груди",
  "M1.NE81 Опасная травма, ранение, ДТП",
  "3.29. Цунами",
  "M1.MD11 Асфиксия всех видов, острое нарушение дыхания",
  "M1.5. Кровотечение сильное или внутреннее",
  "M1.6. Схватки, роды (скрыто,  добавить)",
  "C5",
  "C6",
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

class _MedicCallPageState extends State<MedicCallPage> {
  bool isNotifContact = false;
  InstitutionModel? _institutionFromApi;
  List<Map<String, dynamic>>? _favoursFromApi;

  @override
  void initState() {
    super.initState();
    _selectedContact = widget.selectedContact;
    getMyCalls();
    setValue();
    _loadFavouriteInstitution('med');
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
      dynamic response = await Api.fetchCallsData('med', cardId.id);
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
            title: AppbarTitle(text: "Вызов скорой"),
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
                        name:
                            widget.selectedContact?.personalInfo.full_name ??
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
                  ],
                ),
              ),
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
                                Material(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ListReasonSettingPage()));
                                      },
                                      child: CustomImageView(
                                        svgPath: ImageConstant
                                            .imgSettingsLightBlue900,
                                      ),
                                    ))
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
    // Եթե MedicalCallButton-ից փոխանցվել են favours (ընտրված учреждение), ցուցադրել դրանք, ոչ թե _favoursFromApi (սիրելի)
    final favoursList = widget.favours ?? _favoursFromApi;
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
        itemBuilder: (context, index) {
          final f = sortedFavours[index];
          final name = f['name'] as String? ?? '';
          final duration = (f['duration'] as num?)?.toInt() ?? 0;
          final price = (f['price'] as num?)?.toInt() ?? 0;
          final type = f['type'] as String? ?? 'free';
          final isFree = type == 'free';
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
                      builder: (context) => MedicalCallButton(
                        text: name,
                        selectedContact: widget.selectedContact,
                        initialInstitution: widget.selectedInstitution ?? _institutionFromApi,
                        initialDistance: widget.institutionDistance ?? (_institutionFromApi != null ? '--' : null),
                        initialDuration: widget.institutionDuration ?? (_institutionFromApi != null ? '--' : null),
                        initialFavours: widget.favours ?? _favoursFromApi,
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
                                Text(
                                  '$duration мин',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.payments_outlined, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  price == 0 ? '0 ₽' : '$price ₽',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isFree
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFE3F2FD),
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
        },
      );
    }
    return ListView.separated(
      itemCount: reasonText.length,
      itemBuilder: (BuildContext context, int index) {
        return Reason(
          onTap: () {
            isCalling
                ? ElegantNotification.error(
                    description: const Text('Заявка уже отправлена'),
                  ).show(context)
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MedicalCallButton(
                              text: reasonText[index],
                              selectedContact: widget.selectedContact,
                              initialInstitution: widget.selectedInstitution ?? _institutionFromApi,
                              initialDistance: widget.institutionDistance ?? (_institutionFromApi != null ? '--' : null),
                              initialDuration: widget.institutionDuration ?? (_institutionFromApi != null ? '--' : null),
                              initialFavours: widget.favours ?? _favoursFromApi,
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
}
