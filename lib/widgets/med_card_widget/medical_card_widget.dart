import 'package:flutter/material.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:intl/intl.dart';

class MediacalCardWidget extends StatelessWidget {
  final String displayName;
  final String phoneNumber;
  final String imagePath;
  final VoidCallback onTap;
  final String birthDay; // «дд.мм.гггг» ֆորմատ

  const MediacalCardWidget({
    required this.displayName,
    required this.phoneNumber,
    required this.imagePath,
    required this.onTap,
    this.birthDay = '',
    super.key,
  });

  int _calculateAge() {
    if (birthDay.isEmpty) return -1;
    try {
      final format = DateFormat('dd.MM.yyyy');
      final birth = format.parseStrict(birthDay);
      final now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month ||
          (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      debugPrint('⚠️ BirthDay parse error: $e');
      return -1;
    }
  }

  /// 🎯 որոշում է՝ որ կատեգորիայի մեջ է տարիքային խումբը
  int _getAgeCategory(int age) {
    if (age <= 7) return 1; // փոքր մարդ
    if (age <= 15) return 2; // միջին մարդ
    return 3; // մեծ մարդ
  }

  @override
  Widget build(BuildContext context) {
    final age = _calculateAge();
    final category = _getAgeCategory(age);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(120, 120, 120, 0.24),
                offset: Offset(0, 0),
                blurRadius: 13,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // 👤 ԱՎԱՏԱՐ
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: imagePath.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            width: 52,
                            height: 52,
                          ),
                        )
                      : const Icon(Icons.person),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff3384E2),
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          phoneNumber,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2C3E4F),
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                age == -1
                    ? SizedBox()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showCategoryInfo(context, category);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildPersonIcon(
                                    size: 20, isActive: category == 1),
                                _buildPersonIcon(
                                    size: 26, isActive: category == 2),
                                _buildPersonIcon(
                                    size: 34, isActive: category == 3),
                              ],
                            ),
                          ),
                        ],
                      ),

                Image.asset('assets/images/arrow_rigth.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🧍‍♂️ icon builder
  Widget _buildPersonIcon({required double size, required bool isActive}) {
    return Icon(Icons.man,
        size: size, color: isActive ? Colors.green : Color(0xFF3384E2));
  }

  void _showCategoryInfo(BuildContext context, int activeCategory) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text(
          'Возрастные категории',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontFamily: 'Montserrat',
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryLine(
              label: '👶 Маленький человек — до 7 лет',
              isActive: activeCategory == 1,
            ),
            const SizedBox(height: 8),
            _buildCategoryLine(
              label: '🧒 Средний человек — 9–15 лет',
              isActive: activeCategory == 2,
            ),
            const SizedBox(height: 8),
            _buildCategoryLine(
              label: '🧑 Большой человек — от 16 лет',
              isActive: activeCategory == 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLine({required String label, required bool isActive}) {
    return Text(
      label,
      style: TextStyle(
        color: isActive ? Colors.green : Colors.black87,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        fontFamily: 'Montserrat',
      ),
    );
  }
}
