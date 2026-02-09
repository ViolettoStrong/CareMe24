import 'package:careme24/blocs/review/review_cubit.dart';
import 'package:careme24/blocs/review/review_state.dart';
import 'package:careme24/pages/medical_bag/widgets/custom_gradient_button.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewDialog extends StatefulWidget {
  final String id;
  final String doctor_name;

  const ReviewDialog({required this.id, required this.doctor_name, super.key});

  @override
  _ReviewDialogState createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
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
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            setState(() {
              _rating = index;
            });
          },
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              index <= _rating ? Colors.amber : Colors.grey,
              BlendMode.srcIn,
            ),
            child: CustomImageView(
              svgPath: ImageConstant.imgStarGold,
              height: getSize(44),
              width: getSize(44),
              margin: getMargin(left: 3, top: 3, bottom: 3),
            ),
          )),
    );
  }

  void _submitReview() {
    if (_rating == 0 || _commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Введите комментарий и выберите рейтинг")),
      );
      return;
    }

    context.read<ReviewCubit>().submitReview(
          _commentController.text.trim(),
          _rating,
          widget.id,
        );

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<ReviewCubit>(),
        child: ReviewDialogResult(
          id: _rating,
        ),
      ),
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
                  const Text("Оставьте отзыв",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(widget.doctor_name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              // const SizedBox(height: 5),
              const Text(
                "Если вы уже взаимодействовали со специалистом",
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) => _buildStar(index + 1)),
                ),
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Комментарий:", style: TextStyle(fontSize: 14)),
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
                  onPressed: _submitReview,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewDialogResult extends StatefulWidget {
  final int id;

  const ReviewDialogResult({required this.id, super.key});

  @override
  _ReviewDialogResultState createState() => _ReviewDialogResultState();
}

class _ReviewDialogResultState extends State<ReviewDialogResult> {
  int _rating = 1;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildStar(int index) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        index <= _rating ? Colors.amber : Colors.grey,
        BlendMode.srcIn,
      ),
      child: CustomImageView(
        svgPath: ImageConstant.imgStarGold,
        height: getSize(44),
        width: getSize(44),
        margin: getMargin(left: 3, top: 3, bottom: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ReviewCubit, ReviewState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                if (state is ReviewSuccess) ...[
                  const Text(
                    "Отзыв отправлен",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                ] else if (state is ReviewFailure) ...[
                  const Text(
                    "Отзыв не отправлен",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                ] else ...[
                  const Text(
                    "Отзыв отправлен",
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          index < widget.id ? Colors.amber : Colors.grey,
                          BlendMode.srcIn,
                        ),
                        child: CustomImageView(
                          svgPath: ImageConstant.imgStarGold,
                          height: getSize(44),
                          width: getSize(44),
                          margin: getMargin(left: 3, top: 3, bottom: 3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
