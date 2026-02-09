import 'package:careme24/blocs/review/review_cubit.dart';
import 'package:careme24/blocs/review/review_state.dart';
import 'package:careme24/models/reviews_model.dart';
import 'package:careme24/pages/medical_bag/widgets/custom_gradient_button.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/widgets/review_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsScreen extends StatefulWidget {
  final String serviceId;
  final String doctor_name;
  ReviewsScreen({Key? key, required this.serviceId, required this.doctor_name})
      : super(key: key);
  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _rating = 0;
  String _reviewText = '';
  final reviews = <Review>[];

  @override
  void initState() {
    super.initState();

    context.read<ReviewCubit>().getReview(widget.serviceId);
    context.read<ReviewCubit>().getAverage(widget.serviceId);
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
          child: Icon(
            Icons.star,
            size: 40,
            color: index <= _rating ? Colors.amber : Colors.grey,
          )),
    );
  }

  Future<void> _fetchReviews() async {
    await context.read<ReviewCubit>().getReview(widget.serviceId);
    await context.read<ReviewCubit>().getAverage(widget.serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          height: getVerticalSize(48),
          leadingWidth: 43,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          centerTitle: true,
          title: AppbarTitle(text: "Отзывы"),
          styleType: Style.bgFillBlue60001),
      body: BlocBuilder<ReviewCubit, ReviewState>(builder: (context, state) {
        if (state is ReviewLoading) {
          // reviews.clear();
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ReviewLoaded) {
          reviews.clear();
          reviews.addAll(state.reviews);
        }
        return RefreshIndicator(
          onRefresh: _fetchReviews,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 52,
                      width: 62,
                      child: Card(
                        color: Colors.white,
                        child: Stack(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CustomImageView(
                                    svgPath: ImageConstant.imgStarGold,
                                    height: getSize(35),
                                    width: getSize(35),
                                    margin:
                                        getMargin(left: 3, top: 3, bottom: 3)),
                              ),
                            ),
                            if (state is ReviewSuccessAverage) ...[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text(
                                      state.average_rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.4,
                      child: CustomGradientButton(
                        text: 'Оставить отзыв',
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => BlocProvider.value(
                              value: context.read<ReviewCubit>(),
                              child: ReviewDialog(
                                id: widget.serviceId,
                                doctor_name: widget.doctor_name,
                              ),
                            ),
                          );

                          // showDialog(
                          //   context: context,
                          //   builder: (context) => ReviewDialog(id: '',),
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              reviews.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          final review = reviews[index];
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(review.username,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),

                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: List.generate(
                                  //       5, (index) => _buildStar(review["rating"].toInt() + 1)),
                                  // ),

                                  Center(
                                    child: RatingBarIndicator(
                                      itemPadding: const EdgeInsets.only(
                                          right: 15, bottom: 20, top: 10),
                                      rating: review.rating,
                                      itemBuilder: (context, index) =>
                                          CustomImageView(
                                              svgPath:
                                                  ImageConstant.imgStarGold,
                                              height: getSize(44),
                                              width: getSize(44),
                                              margin: getMargin(
                                                left: 3,
                                                top: 3,
                                                bottom: 3,
                                              )),
                                      itemCount: 5,
                                      itemSize: 44.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(review.text,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Container()
            ],
          ),
        );
      }),
    );
  }
}
