import 'package:flutter/material.dart';

class SosPulsingButton extends StatefulWidget {
  final bool isActive;
  final double size;

  const SosPulsingButton({
    super.key,
    required this.isActive,
    this.size = 80,
  });

  @override
  State<SosPulsingButton> createState() => _SosPulsingButtonState();
}

class _SosPulsingButtonState extends State<SosPulsingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SosPulsingButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.isActive ? _scaleAnimation : AlwaysStoppedAnimation(1.0),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: widget.isActive
              ? null
              : Border.all(
                  color: const Color(0xFFFF0004),
                  width: 3,
                ),
          gradient: widget.isActive
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFF0004),
                    Color(0xFF990003),
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFFF44CD),
                    Color(0xFF722A5F),
                    Color(0xFF582149),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: const Center(
          child: Text(
            "SOS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
