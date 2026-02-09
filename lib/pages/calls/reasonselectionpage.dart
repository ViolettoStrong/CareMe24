import 'package:careme24/pages/calls/careme_reason_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:careme24/utils/image_constant.dart';

class ReasonSelectionPage extends StatefulWidget {
  const ReasonSelectionPage({super.key});

  @override
  State<ReasonSelectionPage> createState() => _ReasonSelectionPageState();
}

class _ReasonSelectionPageState extends State<ReasonSelectionPage> {
  int? selectedIndex;

  final List<Map<String, dynamic>> reasons = [
    {
      "text": "Совершается преступление / террорист",
      "icon": ImageConstant.imgFrameHalf,
    },
    {
      "text": "Стихийное бедствие / пожар",
      "icon": ImageConstant.imgFire,
    },
    {
      "text": "Вызов мед. помощи",
      "icon": 'assets/images/img_group_1.svg',
    },
    {
      "text": "Административное правонарушение",
      "icon": ImageConstant.imgFrameHalf,
      "isSub": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9B4FA0), // Purple background
      appBar: AppBar(
        backgroundColor: const Color(0xFF9B4FA0),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Событие",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // MAIN CONTENT
      body: Column(
        children: [
          const SizedBox(height: 10),

          // CARD CONTAINER
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reasons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) {
                final item = reasons[index];
                final isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () async {
                    if (item["isSub"] == true) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReasonSubPage(
                            title: "Административное правонарушение",
                            options: [
                              "Нарушение порядка",
                              "Сквернословие",
                              "Правила выгула животных",
                              "Автотранспорт"
                            ],
                          ),
                        ),
                      );

                      if (result != null) {
                        Navigator.pop(context, {
                          'index': index,
                          'text': result,
                        });
                      }
                      return;
                    }

                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.greenAccent.shade100
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item["text"],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          item["icon"],
                          width: 28,
                          height: 28,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // SAVE BUTTON
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (selectedIndex != null) {
                  Navigator.pop(context, {
                    'index': selectedIndex,
                    'text': reasons[selectedIndex!]['text'],
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E9BFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Сохранить",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
