import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DelayedEmergencyButton extends StatefulWidget {
  final VoidCallback onConfirmed; // կանչելու callback-ը
  final String type;
  const DelayedEmergencyButton(
      {super.key, required this.onConfirmed, required this.type});

  @override
  State<DelayedEmergencyButton> createState() => _DelayedEmergencyButtonState();
}

class _DelayedEmergencyButtonState extends State<DelayedEmergencyButton>
    with SingleTickerProviderStateMixin {
  bool _isHolding = false;
  int _counter = 4;
  Timer? _timer;
  double _progress = 0.0;
  OverlayEntry? _overlayEntry;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 1.4).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    ));
  }

  void _showOverlayCountdown(BuildContext context) {
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 80,
        left: 0,
        right: 0,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Container(
              key: ValueKey(_counter),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.black87.withOpacity(0.7),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _startCountdown() {
    if (_isHolding) return;
    setState(() {
      _isHolding = true;
      _counter = 4;
      _progress = 0.0;
    });

    _scaleController.forward(from: 0.0);
    _showOverlayCountdown(context);

    const step = Duration(seconds: 1);
    _timer = Timer.periodic(step, (t) {
      if (!_isHolding) {
        t.cancel();
        _removeOverlay();
        setState(() {
          _progress = 0;
        });
        return;
      }

      setState(() {
        _progress = (4 - _counter + 1) / 4;
      });

      if (_counter == 0) {
        t.cancel();
        _removeOverlay();
        widget.onConfirmed();
        setState(() {
          _isHolding = false;
        });
      } else {
        setState(() {
          _counter--;
        });
        _overlayEntry?.markNeedsBuild();
      }
    });
  }

  void _cancelCountdown() {
    setState(() {
      _isHolding = false;
      _progress = 0;
    });
    _timer?.cancel();
    _removeOverlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _removeOverlay();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _startCountdown(),
      onTapUp: (_) => _cancelCountdown(),
      onTapCancel: () => _cancelCountdown(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: !_isHolding
            ? SvgPicture.asset(
                widget.type == 'med'
                    ? 'assets/images/m_off.svg'
                    : widget.type == 'pol'
                        ? 'assets/images/p_on.svg'
                        : 'assets/images/r_on.svg',
                key: const ValueKey('off'),
                width: 140,
                height: 140,
              )
            : ScaleTransition(
                scale: _scaleAnimation,
                child: Stack(
                  key: const ValueKey('fingerprint'),
                  alignment: Alignment.center,
                  children: [
                    // Մատնահետքի icon
                    Icon(
                      Icons.fingerprint,
                      size: 110,
                      color: widget.type == 'med'
                          ? Colors.pinkAccent.shade400
                          : widget.type == 'pol'
                              ? Colors.blue
                              : Colors.deepOrange,
                    ),

                    // Progress circle
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CircularProgressIndicator(
                        value: _progress,
                        strokeWidth: 6,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          widget.type == 'med'
                              ? Colors.pinkAccent.shade400
                              : widget.type == 'pol'
                                  ? Colors.blue
                                  : Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
