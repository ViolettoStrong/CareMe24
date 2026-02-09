import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_style.dart';

class PaySwitcher extends StatefulWidget {
  final bool? isVisible;
  final bool on;
  final Function(bool)? onChanged;

  const PaySwitcher({
    this.isVisible = true,
    this.onChanged,
    this.on = false,
    super.key,
  });

  @override
  State<PaySwitcher> createState() => _PaySwitcherState();
}

class _PaySwitcherState extends State<PaySwitcher>
    with TickerProviderStateMixin {
  late ValueNotifier<bool> _controllerOn;
  late AnimationController _animationController;
  // late Animation<Offset> _slideAnimation;
  late Color borderColor;
  late double borderWidth;
  late TextStyle textStyle;

  @override
  void initState() {
    super.initState();
    _controllerOn = ValueNotifier<bool>(widget.on);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.on ? 1.0 : 0.0,
    );
    _initAnimation();
    _loadSavedSwitchValue();
    _updateStyleBasedOnState(widget.on);
  }

  Future<void> _loadSavedSwitchValue() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('pay_switch_value');
    if (saved != null) {
      _controllerOn.value = saved;
      _updateStyleBasedOnState(saved);
      if (saved) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void _updateStyleBasedOnState(bool isActive) {
    setState(() {
      if (isActive) {
        textStyle = AppStyle.txtMontserratSemiBold12GreenA700;
        borderColor = ColorConstant.greenA70002;
        borderWidth = 2;
      } else {
        textStyle = AppStyle.txtMontserratSemiBold12Gray50001;
        borderColor = ColorConstant.gray50001;
        borderWidth = 1.5;
      }
    });
  }

  void _initAnimation() {
    // const offset = 40.0; // Half of the switch width (80 / 2)
    // _slideAnimation = Tween<Offset>(
    //   begin: const Offset(-offset, 0),
    //   end: const Offset(offset, 0),
    // ).animate(CurvedAnimation(
    //   parent: _animationController,
    //   curve: Curves.easeInOut,
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: getMargin(top: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: AdvancedSwitch(
            controller: _controllerOn, // Pass the ValueNotifier
            activeColor: ColorConstant.gray100,
            inactiveColor: ColorConstant.gray100,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            width: 80.0,
            height: 36.0,
            enabled: true,
            disabledOpacity: 0.5,
            callbackF: _onSwitchChanged,
          ),
        ),
      ],
    );
  }

  void _onSwitchChanged() async {
    bool newValue = !_controllerOn.value; // Toggle value
    _updateStyleBasedOnState(newValue);
    widget.onChanged?.call(newValue);
    _controllerOn.value = newValue; // Update internal state

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pay_switch_value', newValue);

    if (newValue) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controllerOn.dispose();
    super.dispose();
  }
}

class AdvancedSwitch extends StatelessWidget {
  final Function()? callbackF;

  const AdvancedSwitch({
    super.key,
    this.controller,
    this.activeColor = const Color(0xFF9E9E9E),
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
    required this.callbackF,
  });

  final bool enabled;
  final ValueNotifier<bool>? controller;
  final Color activeColor;
  final Color inactiveColor;
  final Widget? activeChild;
  final Widget? inactiveChild;
  final ImageProvider? activeImage;
  final ImageProvider? inactiveImage;
  final BorderRadius borderRadius;
  final double width;
  final double height;
  final double disabledOpacity;
  final Widget? thumb;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller!,
      builder: (context, value, child) {
        // final labelSize = width - height;
        // final containerSize = labelSize * 2 + height;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: callbackF,
                child: Opacity(
                  opacity: enabled ? 1 : disabledOpacity,
                  child: ClipRRect(
                    borderRadius: borderRadius,
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      width: width,
                      height: height,
                      color: value ? activeColor : inactiveColor,
                      child: Stack(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: value
                                ? activeChild ?? const SizedBox()
                                : inactiveChild ?? const SizedBox(),
                          ),
                          Align(
                            alignment: value
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: height,
                              height: height,
                              decoration: BoxDecoration(
                                color: value
                                    ? ColorConstant.greenA70002
                                    : ColorConstant.gray500,
                                borderRadius: borderRadius
                                    .subtract(BorderRadius.circular(1)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
