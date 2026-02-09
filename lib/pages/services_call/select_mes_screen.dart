import 'package:careme24/blocs/app_bloc.dart';
import 'package:careme24/blocs/service/service_cubit.dart';
import 'package:careme24/blocs/service/service_state.dart';
import 'package:careme24/constants.dart';
import 'package:careme24/pages/services_call/select_reason_screen.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:careme24/widgets/for_whom.dart';
import 'package:careme24/widgets/mes_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/paid_service_swither.dart';

class SelectMesScreen extends StatefulWidget {
  final String appbartitle;
  final bool isStatament;

  const SelectMesScreen(
      {super.key, required this.appbartitle, this.isStatament = false});

  @override
  State<SelectMesScreen> createState() => _SelectMesScreenState();
}

class _SelectMesScreenState extends State<SelectMesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controllertimestart = TextEditingController();
  final TextEditingController _controllertimeend = TextEditingController();
  final TextEditingController _controllerestimationstart =
      TextEditingController();
  final TextEditingController _controllerestimationend =
      TextEditingController();
  final TextEditingController _controllercoststart = TextEditingController();
  final TextEditingController _controllercostend = TextEditingController();
  final TextEditingController _controllerdistancestart =
      TextEditingController();
  final TextEditingController _controllerdistanceend = TextEditingController();

  bool isEmptyFiltres() {
    if (_controllertimestart.text.isNotEmpty &&
        _controllertimeend.text.isNotEmpty) {
      return true;
    } else if (_controllerestimationstart.text.isNotEmpty &&
        _controllerestimationend.text.isNotEmpty) {
      return true;
    } else if (_controllercoststart.text.isNotEmpty &&
        _controllercostend.text.isNotEmpty) {
      return true;
    } else if (_controllerdistancestart.text.isNotEmpty &&
        _controllerdistanceend.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  final bool _wait = true;
  final bool _finish = false;
  final bool _undo = false;

  String? selectedReason;

  @override
  Widget build(BuildContext context) {
    AppBloc.serviceCubit.fetchData('mch');
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ColorConstant.whiteA700,
        endDrawer: Drawer(
          child: ListView(
            children: <Widget>[
              Container(
                height: 100,
                padding: getPadding(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Фильтры',
                      style: AppStyle.txtMontserratBold20Blue600,
                    ),
                    Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: CustomImageView(
                            svgPath: ImageConstant.imgArrowright,
                          ),
                        )),
                  ],
                ),
              ),
              Container(
                padding: getPadding(left: 24, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: getPadding(bottom: 12),
                      child: Text(
                        "Время",
                        style: AppStyle.txtMontserratSemiBold17,
                      ),
                    ),
                    Padding(
                      padding: getPadding(bottom: 12),
                      child: TextField(
                        controller: _controllertimestart,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'От',
                        ),
                      ),
                    ),
                    TextField(
                      controller: _controllertimeend,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'До',
                      ),
                    ),
                    Padding(
                      padding: getPadding(bottom: 12, top: 24),
                      child: Text(
                        "Оценка",
                        style: AppStyle.txtMontserratSemiBold17,
                      ),
                    ),
                    Padding(
                      padding: getPadding(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 90,
                            child: TextField(
                              controller: _controllerestimationstart,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'От',
                              ),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 2,
                            color: ColorConstant.gray500,
                          ),
                          SizedBox(
                            width: 90,
                            child: TextField(
                              controller: _controllerestimationend,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'До',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: getPadding(bottom: 12, top: 24),
                      child: Text(
                        "Стоимость",
                        style: AppStyle.txtMontserratSemiBold17,
                      ),
                    ),
                    Padding(
                      padding: getPadding(bottom: 12),
                      child: TextField(
                        controller: _controllercoststart,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'От',
                        ),
                      ),
                    ),
                    TextField(
                      controller: _controllercostend,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'До',
                      ),
                    ),
                    Padding(
                      padding: getPadding(bottom: 12, top: 24),
                      child: Text(
                        "Расстояние",
                        style: AppStyle.txtMontserratSemiBold17,
                      ),
                    ),
                    Padding(
                      padding: getPadding(bottom: 12),
                      child: TextField(
                        controller: _controllerdistancestart,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          labelText: 'От',
                        ),
                      ),
                    ),
                    TextField(
                      controller: _controllerdistanceend,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: 'До',
                      ),
                    ),
                    Container(
                      margin: getMargin(top: 24, bottom: 24),
                      width: MediaQuery.of(context).size.width - 40,
                      height: 56,
                      decoration: BoxDecoration(
                          gradient: isEmptyFiltres()
                              ? LinearGradient(
                                  colors: [
                                    ColorConstant.indigoA400,
                                    ColorConstant.bluegradient,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                )
                              : LinearGradient(
                                  colors: [
                                    ColorConstant.gray500,
                                    ColorConstant.gray500,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "Отменить",
                        style: AppStyle.txtMontserratSemiBold18WhiteA700,
                      )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        appBar: CustomAppBar(
            height: getVerticalSize(48),
            leadingWidth: 43,
            leading: Padding(
              padding:
                  const EdgeInsets.only(left: 8.0), // 👉 որքան աջ ես ուզում
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            centerTitle: true,
            title: AppbarTitle(text: widget.appbartitle),
            actions: [
              Builder(builder: (context) {
                return AppbarImage(
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    height: getSize(22),
                    width: getSize(22),
                    svgPath: ImageConstant.imgFilter,
                    margin: getMargin(left: 26, top: 9, right: 26, bottom: 17));
              })
            ],
            styleType: Style.bgFillBlue60001),
        body: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoaded) {
              return SizedBox(
                width: size.width,
                child: SingleChildScrollView(
                  padding: getPadding(top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: getPadding(left: 2),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ForWhom(
                                  name: 'Мне',
                                ),
                                Column(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.34,
                                        child: Center(
                                          child: Text(
                                            'Платная услуга',
                                            style: TextStyle(
                                                color: VersionConstant.free
                                                    ? const Color(0xFF9E9E9E)
                                                    : Colors.green),
                                          ),
                                        )),
                                    Column(
                                      children: [
                                        PaySwitcher(
                                          on: VersionConstant.free,
                                          onChanged: (value) {
                                            setState(() {
                                              VersionConstant.free = value;
                                            });
                                          },
                                        ),
                                        Text(''),
                                      ],
                                    )
                                  ],
                                ),
                              ])),
                      Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SelectReasonScreen(type: 'mes')))
                                  .then((reason) {
                                setState(() {
                                  selectedReason = reason;
                                });
                              });
                            },
                            child: Padding(
                              padding: getPadding(top: 14),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromRGBO(178, 218, 255, 100),
                                ),
                                width: MediaQuery.of(context).size.width - 40,
                                height: 80,
                                child: Padding(
                                  padding: getPadding(left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                            selectedReason ?? 'Проблема',
                                            style: AppStyle
                                                .txtMontserratSemiBold19,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      CustomImageView(
                                        svgPath: ImageConstant
                                            .imgArrowdownLightBlue900,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                      Padding(
                        padding: getPadding(top: 18),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {},
                                      child: Container(
                                          width: getHorizontalSize(109),
                                          padding: getPadding(
                                              left: 9,
                                              top: 10,
                                              right: 9,
                                              bottom: 10),
                                          decoration: _wait
                                              ? AppDecoration.txtFillBlue30001
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .txtCustomBorderTL10)
                                              : BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: ColorConstant
                                                            .gray50002,
                                                        width: 1),
                                                  ),
                                                ),
                                          child: Text("Путь",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: _wait
                                                  ? AppStyle
                                                      .txtMontserratSemiBold15
                                                  : TextStyle(
                                                      color: ColorConstant
                                                          .black900,
                                                      fontSize: getFontSize(
                                                        15,
                                                      ),
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ))))),
                              Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {},
                                      child: Container(
                                          width: getHorizontalSize(109),
                                          padding: getPadding(
                                              left: 9,
                                              top: 10,
                                              right: 9,
                                              bottom: 10),
                                          // decoration:  AppDecoration.outlineGray50001,
                                          decoration: _finish
                                              ? AppDecoration.txtFillBlue30001
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .txtCustomBorderTL10)
                                              : BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: ColorConstant
                                                            .gray50002,
                                                        width: 1),
                                                  ),
                                                ),
                                          child: Text("Оценка",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: _finish
                                                  ? AppStyle
                                                      .txtMontserratSemiBold15
                                                  : TextStyle(
                                                      color: ColorConstant
                                                          .black900,
                                                      fontSize: getFontSize(
                                                        15,
                                                      ),
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ))))),
                              Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                          decoration: _undo
                                              ? AppDecoration.txtFillBlue30001
                                                  .copyWith(
                                                      borderRadius:
                                                          BorderRadiusStyle
                                                              .txtCustomBorderTL10)
                                              : BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: ColorConstant
                                                            .gray50002,
                                                        width: 1),
                                                  ),
                                                ),
                                          width: getHorizontalSize(109),
                                          padding: getPadding(
                                              left: 9,
                                              top: 10,
                                              right: 9,
                                              bottom: 10),
                                          child: Text("Стоимость",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: _undo
                                                  ? AppStyle
                                                      .txtMontserratSemiBold15
                                                  : TextStyle(
                                                      color: ColorConstant
                                                          .black900,
                                                      fontSize: getFontSize(
                                                        15,
                                                      ),
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ))))),
                            ]),
                      ),
                      Padding(
                        padding: getPadding(left: 2, top: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...List.generate(state.serviceList.length, (index) {
                              final item = state.serviceList[index];

                              // գույնի ստուգում
                              final Color bgColor = item.price == 0
                                  ? Colors.white
                                  : VersionConstant.free
                                      ? Colors.pink.shade100
                                      : Colors.grey.shade300;
                              final bool canWork = VersionConstant.free
                                  ? item.price > 0
                                  : item.price == 0;

                              return MESCard(
                                medCardId: state.medCardId,
                                mes_image: '',
                                mes_name: item.institutionName,
                                mes_qualification: item.specialization,
                                cost: '${item.price} ₽',
                                meters: 'fwfwe',
                                minute: 'weffw',
                                estimation: '',
                                where_call: 'wef',
                                call_scree: widget.appbartitle,
                                reason: selectedReason ?? '',
                                serviceModel: item,
                                statement: widget.isStatament,
                                work: canWork,
                                backgroundColor: bgColor,
                              );
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
          },
        ),
      ),
    );
  }
}
