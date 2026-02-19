import 'dart:async';

import 'package:careme24/api/api.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/models/institution_model.dart';
import 'package:careme24/models/medcard/medcard_model.dart';
import 'package:careme24/pages/calls/dialog_select_contact_med.dart';
import 'package:careme24/pages/calls/main_call_page.dart';
import 'package:careme24/pages/calls/rescue_call_button.dart';
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
import 'package:careme24/widgets/reason_mes.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _controller = ValueNotifier<bool>(false);
bool _checked = false;
bool select_reason = false;
Color select_color = const Color.fromRGBO(254, 246, 225, 100);
bool isCalling = false;
dynamic res;

final List<String> reasonText = <String>[
  "3.13. Пожар в лесу",
  "3.12. Пожар в квартире",
  "3.18. Застряла голова в проеме",
  "3.29. Запах газа в квартире",
  "3.11. Домашнее насилие",
  "3.15. Пожар в здании",
  "3.12. Реагирования в чрезвычайных ситуациях",
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

class RescueCallPage extends StatefulWidget {
  const RescueCallPage({
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
  State<RescueCallPage> createState() => _RescueCallPageState();
}

class _RescueCallPageState extends State<RescueCallPage> {
  bool isSelectedSwitch = false;
  MedcardModel? _selectedContact;
  InstitutionModel? _institutionFromApi;
  List<Map<String, dynamic>>? _favoursFromApi;

  TextEditingController componentfortyController = TextEditingController();

  TextEditingController frame7304Controller = TextEditingController();
  bool isNotifContact = false;
  @override
  void initState() {
    super.initState();
    _selectedContact = widget.selectedContact;
    getMyCalls();
    _loadFavouriteInstitution('mch');
    _controller.addListener(() {
      setState(() {
        if (_controller.value) {
          _checked = true;
        } else {
          _checked = false;
        }
      });
    });
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
      dynamic response = await Api.fetchCallsData('mch', cardId.id);
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
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                  icon:
                      const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context)),
            ),
            centerTitle: true,
            title: AppbarTitle(text: "Вызов МЧС"),
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
        return ReasonMES(
          onTap: () {
            isCalling
                ? ElegantNotification.error(
                    description: const Text('Заявка уже отправлена'),
                  ).show(context)
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RescueCallButton(
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
                builder: (context) => RescueCallButton(
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

  onTapArrowleft19(BuildContext context) {
    Navigator.pop(context);
  }
}

class AdvancedSwitch extends StatefulWidget {
  const AdvancedSwitch({
    super.key,
    this.controller,
    this.activeColor = const Color(0xFF4CAF50),
    this.inactiveColor = const Color(0xFF9E9E9E),
    this.activeChild,
    this.inactiveChild,
    this.activeImage,
    this.inactiveImage,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
    this.width = 50.0,
    this.height = 30.0,
    this.enabled = true,
    this.disabledOpacity = 0.5,
    this.thumb,
  });

  /// Determines if widget is enabled
  final bool enabled;

  /// Determines current state.
  final ValueNotifier<bool>? controller;

  /// Determines background color for the active state.
  final Color activeColor;

  /// Determines background color for the inactive state.
  final Color inactiveColor;

  /// Determines label for the active state.
  final Widget? activeChild;

  /// Determines label for the inactive state.
  final Widget? inactiveChild;

  /// Determines background image for the active state.
  final ImageProvider? activeImage;

  /// Determines background image for the inactive state.
  final ImageProvider? inactiveImage;

  /// Determines border radius.
  final BorderRadius borderRadius;

  /// Determines width.
  final double width;

  /// Determines height.
  final double height;

  /// Determines opacity of disabled control.
  final double disabledOpacity;

  /// Thumb widget.
  final Widget? thumb;

  @override
  _AdvancedSwitchState createState() => _AdvancedSwitchState();
}

class _AdvancedSwitchState extends State<AdvancedSwitch>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 250);
  late ValueNotifier<bool> _controller;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<Color?> _colorAnimation;
  late double _thumbSize;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? ValueNotifier<bool>(false);
    _controller.addListener(_handleControllerValueChanged);

    _animationController = AnimationController(
      vsync: this,
      duration: _duration,
      value: _controller.value ? 1.0 : 0.0,
    );

    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant AdvancedSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    _initAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final labelSize = widget.width - _thumbSize;
    final containerSize = labelSize * 2 + _thumbSize;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _handlePressed,
            child: Opacity(
              opacity: widget.enabled ? 1 : widget.disabledOpacity,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (_, child) {
                  return ClipRRect(
                    borderRadius: widget.borderRadius,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: widget.width,
                      height: widget.height,
                      color: _colorAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Stack(
                  children: [
                    if (widget.activeImage != null ||
                        widget.inactiveImage != null)
                      ValueListenableBuilder<bool>(
                        valueListenable: _controller,
                        builder: (_, __, ___) {
                          return AnimatedCrossFade(
                            crossFadeState: _controller.value
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: _duration,
                            firstChild: Image(
                              width: widget.width,
                              height: widget.height,
                              image:
                                  widget.inactiveImage ?? widget.activeImage!,
                              fit: BoxFit.cover,
                            ),
                            secondChild: Image(
                              width: widget.width,
                              height: widget.height,
                              image:
                                  widget.activeImage ?? widget.inactiveImage!,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _slideAnimation.value,
                          child: child,
                        );
                      },
                      child: OverflowBox(
                        minWidth: containerSize,
                        maxWidth: containerSize,
                        minHeight: widget.height,
                        maxHeight: widget.height,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconTheme(
                              data: const IconThemeData(
                                color: Color(0xFFFFFFFF),
                                size: 20,
                              ),
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                child: Container(
                                  width: labelSize,
                                  height: widget.height,
                                  alignment: Alignment.center,
                                  child: widget.activeChild,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(2),
                              width: _thumbSize - 4,
                              height: _thumbSize - 4,
                              child: widget.thumb ??
                                  Container(
                                    decoration: BoxDecoration(
                                      color: ColorConstant.gray50001,
                                      borderRadius: widget.borderRadius
                                          .subtract(BorderRadius.circular(1)),
                                    ),
                                  ),
                            ),
                            IconTheme(
                              data: const IconThemeData(
                                color: Color(0xFFFFFFFF),
                                size: 20,
                              ),
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                child: Container(
                                  width: labelSize,
                                  height: widget.height,
                                  alignment: Alignment.center,
                                  child: widget.inactiveChild,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _initAnimation() {
    _thumbSize = widget.height;
    final offset = widget.width / 2 - _thumbSize / 2;

    final animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-offset, 0),
      end: Offset(offset, 0),
    ).animate(animation);

    _colorAnimation = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(animation);
  }

  void _handleControllerValueChanged() {
    if (_controller.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _handlePressed() {
    if (widget.controller != null && widget.enabled) {
      _controller.value = !_controller.value;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerValueChanged);

    if (widget.controller == null) {
      _controller.dispose();
    }

    _animationController.dispose();

    super.dispose();
  }
}
