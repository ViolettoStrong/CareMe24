import 'dart:developer';
import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/medcard/medcard_cubit.dart';
import 'package:careme24/blocs/medcard/medcard_state.dart';
import 'package:careme24/models/user_model.dart';
import 'package:careme24/pages/med_card/medical_card_page.dart';
import 'package:careme24/pages/medical_bag/ped_card_page.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/med_card_request.dart';
import 'package:careme24/widgets/med_card_widget/medical_card_widget.dart';
import 'package:careme24/widgets/search.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/med_card_widget/add_button.dart';

class MedicalCardListPage extends StatefulWidget {
  const MedicalCardListPage({super.key});

  @override
  State<MedicalCardListPage> createState() => _MedicalCardListPageState();
}

class _MedicalCardListPageState extends State<MedicalCardListPage> {
  @override
  void initState() {
    AppBloc.medCardCubit.fetchData();
    super.initState();
  }

  bool showSearch = false;
  UserModel? selectedUser;
  bool personPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          actions: [
            Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      color: Colors.transparent,
                      height: 20,
                      child: Image.asset(
                        'assets/images/icon-plus.png',
                      )),
                ))
          ],
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
          title: AppbarTitle(
            text: "Профиль",
            margin: getMargin(
              left: 15,
            ),
          ),
          styleType: Style.bgFillBlue60001,
        ),
        body:
            BlocBuilder<MedCardCubit, MedCardState>(builder: (context, state) {
          if (state is MedCardLoaded) {
            return Container(
              margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              height: double.maxFinite,
              width: double.maxFinite,
              child: SingleChildScrollView(
                  child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'МОЙ ПРОФИЛЬ',
                        style: AppStyle.txtInterExtraBold12.copyWith(
                            color: const Color(
                              0xff2C3E4F,
                            ).withOpacity(0.8),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      state.myCard.haveCard
                          ? MediacalCardWidget(
                              displayName: state.myCard.personalInfo.full_name,
                              phoneNumber: '${state.myCard.personalInfo.phone}',
                              imagePath: state.myCard.personalInfo.avatar,
                              birthDay: state.myCard.personalInfo.dob,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MedicalCardPage(
                                              medcardModel: state.myCard,
                                              birthDay:
                                                  state.myCard.personalInfo.dob,
                                            )));
                              })
                          : AddButton(
                              buttonText: 'Добавить карту для меня',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MedicalCardPage(
                                              medcardModel: state.myCard,
                                              createMode: true,
                                              myCard: true,
                                            )));
                              },
                            ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'ПРОФИЛИ В УПРАВЛЕНИИ',
                        style: AppStyle.txtInterExtraBold12.copyWith(
                            color: const Color(
                              0xff2C3E4F,
                            ).withOpacity(0.8),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  setState(() {
                                    personPage = true;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff2C3E4F)
                                            .withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: personPage
                                            ? ColorConstant.blue60001
                                            : Colors.white,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Люди',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff2C3E4F),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  setState(() {
                                    personPage = false;
                                  });
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff2C3E4F)
                                            .withOpacity(0.3)),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: !personPage
                                            ? ColorConstant.blue60001
                                            : Colors.white,
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Питомцы',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff2C3E4F),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (personPage) ...[
                        if (state.otherCards.isNotEmpty)
                          SizedBox(
                            height: 109,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...List.generate(state.otherCards.length,
                                      (index) {
                                    return SizedBox(
                                      width: size.width - 50,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: MediacalCardWidget(
                                          displayName: state.otherCards[index]
                                              .personalInfo.full_name,
                                          phoneNumber:
                                              '${state.otherCards[index].personalInfo.phone}',
                                          imagePath: state.otherCards[index]
                                              .personalInfo.avatar,
                                          birthDay: state.otherCards[index]
                                              .personalInfo.dob,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MedicalCardPage(
                                                  medcardModel:
                                                      state.otherCards[index],
                                                  birthDay: state
                                                      .otherCards[index]
                                                      .personalInfo
                                                      .dob,
                                                  myCard: false,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          )
                      ] else ...[
                        /// 👇 այստեղ միշտ fake питомцы
                        SizedBox(
                          height: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...List.generate(state.animalCards.length,
                                    (index) {
                                  return SizedBox(
                                    width: size.width - 50,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: MediacalCardWidget(
                                        displayName: state.animalCards[index]
                                            .animalMedCard!.animalName,
                                        phoneNumber:
                                            '${state.animalCards[index].animalMedCard!.animalType}',
                                        imagePath: state.animalCards[index]
                                            .animalMedCard!.animalPhoto,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PetCardPage(
                                                animalName: state
                                                    .animalCards[index]
                                                    .animalMedCard!
                                                    .animalName,
                                                animalPhoto: state
                                                    .animalCards[index]
                                                    .animalMedCard!
                                                    .animalPhoto,
                                                animalSize: state
                                                    .animalCards[index]
                                                    .animalMedCard!
                                                    .animalSize,
                                                animalType: state
                                                    .animalCards[index]
                                                    .animalMedCard!
                                                    .animalType,
                                                cardId:
                                                    state.animalCards[index].id,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                }),
                                /*...List.generate(3, (index) {
            final fakePets = [
              {"name": "Барсик", "phone": "Пёс", "avatar": "https://placedog.net/200/200"},
              {"name": "Шарик", "phone": "Пёс", "avatar": "https://placedog.net/200/200"},
              {"name": "Кеша", "phone": "Медведь", "avatar": "https://placebear.com/200/200"},
            ];
            return SizedBox(
              width: size.width - 50,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: MediacalCardWidget(
                  displayName: fakePets[index]["name"]!,
                  phoneNumber: fakePets[index]["phone"]!,
                  imagePath: fakePets[index]["avatar"]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PetCardPage(
                          
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }),*/
                              ],
                            ),
                          ),
                        )
                      ],
                      const SizedBox(
                        height: 8,
                      ),
                      AddButton(
                        buttonText: 'Добавить карту',
                        onTap: () {
                          personPage
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MedicalCardPage(
                                            medcardModel: state.myCard,
                                            createMode: true,
                                            myCard: false,
                                          )),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PetCardPage(),
                                  ),
                                );
                        },
                      ),
                      if (state.unverifiedCards.isNotEmpty)
                        Text(
                          'ПЕРЕДАЧИ ПРОФИЛЯ',
                          style: AppStyle.txtInterExtraBold12.copyWith(
                              color: const Color(
                                0xff2C3E4F,
                              ).withOpacity(0.8),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                      const SizedBox(
                        height: 5,
                      ),
                      state.unverifiedCards.isNotEmpty
                          ? Column(
                              children: [
                                ...List.generate(state.unverifiedCards.length,
                                    (index) {
                                  return MedCardRequest(
                                      medcard: state.unverifiedCards[index]);
                                })
                              ],
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'ЗАПРОСЫ',
                        style: AppStyle.txtInterExtraBold12.copyWith(
                            color: const Color(
                              0xff2C3E4F,
                            ).withOpacity(0.8),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      state.toMeRequests.isNotEmpty
                          ? Column(
                              children: [
                                ...List.generate(state.toMeRequests.length,
                                    (index) {
                                  return MedCardRequest(
                                      shareMode: false,
                                      medcard: state.toMeRequests[index]);
                                })
                              ],
                            )
                          : const SizedBox.shrink(),
                      AddButton(
                        buttonText: 'Добавить запрос',
                        onTap: () {
                          setState(() {
                            showSearch = true;
                          });
                        },
                      ),
                      Container(
                        child: Text(
                          'ДОПОЛНИТЕЛЬНО',
                          style: AppStyle.txtInterExtraBold12.copyWith(
                              color: const Color(
                                0xff2C3E4F,
                              ).withOpacity(0.8),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      AddButton(
                        buttonText: 'Добавить',
                        onTap: () {},
                      ),
                    ],
                  ),
                  if (showSearch)
                    Search(
                        shareProfile: false,
                        onCloseTap: () {
                          setState(() {
                            showSearch = false;
                          });
                        },
                        onUserSelect: (user) {
                          setState(() {
                            selectedUser = user;
                            if (selectedUser!.medCardID != '') {
                              log(selectedUser!.medCardID);
                              AppBloc.medCardCubit
                                  .sendRequest(selectedUser!.id);
                            }
                            showSearch = false;
                          });
                        })
                ],
              )),
            );
          } else {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
        }));
  }
}
