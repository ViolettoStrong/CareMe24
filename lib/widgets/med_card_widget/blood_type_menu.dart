import 'package:flutter/material.dart';

class _BloodTypeSelectorModal extends StatefulWidget {
  final String selectedValue;
  const _BloodTypeSelectorModal({required this.selectedValue});

  @override
  State<_BloodTypeSelectorModal> createState() =>
      _BloodTypeSelectorModalState();
}

class _BloodTypeSelectorModalState extends State<_BloodTypeSelectorModal> {
  int selectedTab = 1;

  final Map<int, List<String>> bloodGroups = {
    1: ['1+', '1-', '2+', '2-'],
    2: ['3+', '3-', '4+', '4-'],
  };

  @override
  Widget build(BuildContext context) {
    final groups = bloodGroups[selectedTab]!;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── ԹԱԲԵՐ ───────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ToggleButtons(
              isSelected: [selectedTab == 1, selectedTab == 2],
              onPressed: (index) => setState(() => selectedTab = index + 1),
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              color: Colors.black87,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('1'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('2'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ─── ԸՆՏՐՈՒԹՅՈՒՆՆԵՐ ─────────────────────
          ...groups.map(
            (val) => ListTile(
              title: Center(
                  child: Text(val, style: const TextStyle(fontSize: 16))),
              onTap: () => Navigator.pop(context, val),
            ),
          ),
        ],
      ),
    );
  }
}
