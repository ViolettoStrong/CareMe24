import 'package:flutter/material.dart';

class AutoExpandBox extends StatefulWidget {
  const AutoExpandBox({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<AutoExpandBox> createState() => _AutoExpandBoxState();
}

class _AutoExpandBoxState extends State<AutoExpandBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _widthAnimation = Tween<double>(begin: 30, end: 300)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startAnimationOnce();
  }

  Future<void> _startAnimationOnce() async {
    await _controller.forward(); // բացվում է ձախ
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: _widthAnimation,
            builder: (context, child) {
              return Container(
                width: _widthAnimation.value,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 5),
                    Icon(Icons.local_phone, color: Colors.white, size: 18),
                    SizedBox(width: 5),
                    _widthAnimation.value > 100
                        ? Text(
                            'Вызов активен',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : SizedBox(),
                  ],
                ));
            },
          ),
        ),
      ),
    );
  }
}
