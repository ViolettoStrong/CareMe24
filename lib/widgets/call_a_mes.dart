import 'package:careme24/constants.dart';
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
import 'package:careme24/widgets/police_mes_info_card.dart';
import 'package:flutter/material.dart';

final _controller = ValueNotifier<bool>(false);

class PlotsMesScreen extends StatefulWidget {
  late String reasonForTheCall;

  PlotsMesScreen(this.reasonForTheCall, {super.key});

  @override
  State<PlotsMesScreen> createState() => _PlotsMesScreenState();
}

class _PlotsMesScreenState extends State<PlotsMesScreen> {
  bool isSelectedSwitch = false;
  String descriptionOfTheReason = "";
  String radioGroup = "";
  String picturePath = ImageConstant.mesCar;

  void change_picture() {
    if (picturePath == ImageConstant.mesCar) {
      picturePath = ImageConstant.mesActiveCar;
    } else {
      picturePath = ImageConstant.mesCar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.gray100,
            appBar: CustomAppBar(
                height: getVerticalSize(48),
                leadingWidth: 43,
                leading: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                centerTitle: true,
                title: AppbarTitle(text: "Вызов МЧС"),
                styleType: Style.bgFillBlue60001),
            body: SingleChildScrollView(
              child: Container(
                  width: double.maxFinite,
                  padding: getPadding(left: 22, top: 17, right: 22, bottom: 17),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: getPadding(left: 1),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ForWhom(
                                    name: 'Мне',
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.34,
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
                        Padding(
                          padding: getPadding(top: 14),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromRGBO(178, 218, 255, 100),
                            ),
                            width: MediaQuery.of(context).size.width - 40,
                            height: 80,
                            child: Padding(
                              padding: getPadding(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.5,
                                    child: Text(
                                      widget.reasonForTheCall,
                                      style: AppStyle.txtMontserratSemiBold19,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  CustomImageView(
                                    svgPath:
                                        ImageConstant.imgArrowdownLightBlue900,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: getPadding(top: 18),
                            child: Material(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onDoubleTap: () {
                                  setState(() {
                                    change_picture();
                                  });
                                },
                                onLongPress: () {
                                  /*   Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          WaitingWindowScreen(whereCall: 'МЧС', whereCallAppBar: 'МЧС',))); */
                                },
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color.fromRGBO(
                                          253, 253, 253, 100),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 40,
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomImageView(
                                          svgPath: picturePath,
                                          height: getSize(144),
                                          width: getSize(144),
                                        ),
                                        Padding(
                                          padding: getPadding(top: 11),
                                          child: Text(
                                            "Вызвать МЧС",
                                            style: AppStyle
                                                .txtMontserratRomanSemiBold18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Padding(
                            padding: getPadding(top: 20),
                            child: PoliceMESInfoCard(
                              policeMESName: "МЧС",
                              addres: "ул. Пречистенка, 22, Москва, 119034",
                              meters: "1200м",
                              minutes: "30 мин",
                              estimation: "4.7",
                              imagePath: ImageConstant.fireSmallIcon,
                              cardColor: ColorConstant.yellow700,
                              whereCall: "MES",
                              reasonText: widget.reasonForTheCall,
                            )),
                      ])),
            )));
  }

  onTapHospitalcard(BuildContext context) {
    //Navigator.pushNamed(context, AppRouter.hospitalsScreen);
  }

  onTapArrowleft17(BuildContext context) {
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
