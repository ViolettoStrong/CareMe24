import 'package:careme24/constants.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/for_whom.dart';
import 'package:careme24/widgets/paid_service_swither.dart';
import 'package:careme24/widgets/selfhelp_item_widget.dart';
import 'package:flutter/material.dart';
import '../../theme/app_style.dart';
import '../../widgets/app_bar/appbar_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_image_view.dart';

class MESRecomendation extends StatefulWidget {
  const MESRecomendation({super.key});

  @override
  State<MESRecomendation> createState() => _MESRecomendationState();
}

class _MESRecomendationState extends State<MESRecomendation> {
  bool isSelectedSwitch = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.whiteA700,
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
                title: AppbarTitle(text: "Рекомендации МЧС"),
                styleType: Style.bgFillBlue60001),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 20, right: 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: getPadding(left: 2, top: 17, right: 3),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ForWhom(
                                  name: 'Мне',
                                ),
                                Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                      Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => PoliceRecomendationReadPage()));
                            },
                            child: Padding(
                              padding: getPadding(top: 14),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromRGBO(178, 218, 255, 100),
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
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text('12.01. Пожар в лесу',
                                            style: AppStyle
                                                .txtMontserratSemiBold19,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      CustomImageView(
                                        svgPath: ImageConstant
                                            .imgArrowdownLightBlue900,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Expanded(
                          child: Padding(
                              padding: getPadding(top: 20, right: 6),
                              child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                        height: getVerticalSize(14));
                                  },
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return SelfhelpItemWidget(
                                      imagepath: ImageConstant.fireImage,
                                      textproblem:
                                          'Пожарная безопасность в лесу',
                                      wherecall: 'МЧС',
                                    );
                                  })))
                    ]))));
  }

  onTapArrowleft45(BuildContext context) {
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
                                      color: ColorConstant.greenA70002,
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
    print(_controller.value);
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
