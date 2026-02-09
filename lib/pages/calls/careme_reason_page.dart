import 'package:careme24/theme/app_style.dart';
import 'package:flutter/material.dart';

class ReasonSubPage extends StatefulWidget {
  final String title;
  final List<String> options;

  const ReasonSubPage({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  State<ReasonSubPage> createState() => _ReasonSubPageState();
}

class _ReasonSubPageState extends State<ReasonSubPage> {
  int? selectedIndex;
  final TextEditingController _controller = TextEditingController();

  bool get canSave =>
      selectedIndex != null || _controller.text.trim().isNotEmpty;

  void _onSave() {
    if (!canSave) return;

    if (_controller.text.trim().isNotEmpty) {
      Navigator.pop(context, _controller.text.trim());
    } else if (selectedIndex != null) {
      Navigator.pop(context, widget.options[selectedIndex!]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF9B4FA0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ===== TITLE =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Container(
                width: double.infinity,
                height: 80,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(178, 218, 255, 1),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: Text(
                  widget.title,
                  style: AppStyle.txtMontserratSemiBold19,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ),

            /// ===== OPTIONS CARD =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: List.generate(widget.options.length, (i) {
                    final isSelected = selectedIndex == i;

                    return InkWell(
                      borderRadius: BorderRadius.only(
                        topLeft:
                            i == 0 ? const Radius.circular(10) : Radius.zero,
                        topRight:
                            i == 0 ? const Radius.circular(10) : Radius.zero,
                        bottomLeft: i == widget.options.length - 1
                            ? const Radius.circular(10)
                            : Radius.zero,
                        bottomRight: i == widget.options.length - 1
                            ? const Radius.circular(10)
                            : Radius.zero,
                      ),
                      onTap: () {
                        setState(() {
                          selectedIndex = i;
                          _controller.clear();
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromRGBO(254, 246, 225, 1)
                              : Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.options[i],
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Color.fromRGBO(44, 62, 79, 1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (i != widget.options.length - 1)
                              const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFE0E0E0),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            /// ===== ДРУГОЕ =====
            if (widget.title == "Административное правонарушение")
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
                child: TextField(
                  controller: _controller,
                  maxLines: 3,
                  onChanged: (_) {
                    setState(() {
                      selectedIndex = null;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Другое...',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            /// ===== SAVE =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: canSave ? _onSave : null,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: canSave ? Colors.blue : Colors.grey,
                  ),
                  child: const Center(
                    child: Text(
                      'Сохранить',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
