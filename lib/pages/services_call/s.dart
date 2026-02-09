import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/institution/institution_cubit.dart';
import 'package:careme24/blocs/institution/institution_state.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectInstituts extends StatelessWidget {
  const SelectInstituts({super.key, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    AppBloc.institutionCubit.fetchData(type);
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
          title: AppbarTitle(text: "Выбрать учреждение"),
          styleType: Style.bgFillBlue60001),
      body: BlocBuilder<InstitutionCubit, InstitutionState>(
          builder: (context, state) {
        if (state is InstitutionLoaded) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ...List.generate(state.institutionList.length, (index) {
                  final item = state.institutionList[index];
                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          Navigator.pop(context, state.institutionList[index]);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 16, left: 23, right: 23, bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 5,
                                color: Color.fromRGBO(0, 0, 0, 0.24),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 67,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: getColor(item.type),
                                      borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(30)),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CustomImageView(
                                          svgPath: getImage(item.type),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            color:
                                                Color.fromRGBO(51, 132, 226, 1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          item.address,
                                          style: const TextStyle(
                                            color: Color.fromRGBO(
                                                142, 150, 155, 1),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color.fromRGBO(221, 222, 226, 1),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 14, top: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      '1102м',
                                      style: TextStyle(
                                        color: Color.fromRGBO(44, 62, 79, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '40 мин',
                                      style: TextStyle(
                                        color: Color.fromRGBO(44, 62, 79, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 14, bottom: 14, top: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 3),
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: const Color.fromRGBO(
                                                95, 178, 255, 1)),
                                      ),
                                    ),
                                    const Text(
                                      'Оставить по умолчанию',
                                      style: TextStyle(
                                        color: Color.fromRGBO(95, 178, 255, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  );
                }),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
      }),
    );
  }
}

getImage(String type) {
  switch (type) {
    case 'pol':
      return ImageConstant.policehat;
    case 'mch':
      return 'assets/icons/fire.svg';
    case 'med':
      return 'assets/icons/medInst.svg';
  }
}

getColor(String type) {
  switch (type) {
    case 'pol':
      return ColorConstant.indigoA100;
    case 'mch':
      return const Color.fromRGBO(255, 187, 38, 1);
    case 'med':
      return Colors.white;
  }
}
