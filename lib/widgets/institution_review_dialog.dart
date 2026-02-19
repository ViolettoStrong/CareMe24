import 'package:careme24/pages/medical_bag/widgets/custom_gradient_button.dart';
import 'package:flutter/material.dart';

/// Діалог відгуку про заклад (той самий дизайн як review_dialog).
class InstitutionReviewDialog extends StatefulWidget {
  final String institutionName;
  final String? institutionId;
  final void Function(String text, int rating)? onSubmit;

  const InstitutionReviewDialog({
    super.key,
    this.institutionName = 'Учреждение',
    this.institutionId,
    this.onSubmit,
  });

  @override
  State<InstitutionReviewDialog> createState() => _InstitutionReviewDialogState();
}

class _InstitutionReviewDialogState extends State<InstitutionReviewDialog> {
  int _rating = 1;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Widget _buildStar(int index) {
    return Icon(
      index <= _rating ? Icons.star : Icons.star_border,
      size: 40,
      color: index <= _rating ? Colors.amber : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 25),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Оставьте отзыв",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      widget.institutionName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                "Если вы уже взаимодействовали с учреждением",
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => _rating = index + 1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: _buildStar(index + 1),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Комментарий:",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 100,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: "Напишите ваш комментарий",
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: CustomGradientButton(
                  text: 'Отправить',
                  onPressed: () {
                    if (widget.onSubmit != null &&
                        widget.institutionId != null &&
                        _commentController.text.trim().isNotEmpty) {
                      widget.onSubmit!(
                          _commentController.text.trim(), _rating);
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
