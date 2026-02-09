import 'package:careme24/api/api.dart';
import 'package:careme24/models/request_model.dart';
import 'package:careme24/pages/tracking_screen/tracking_screen.dart';
import 'package:careme24/service/url_service.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';

class ContactHelpInfo extends StatefulWidget {
  const ContactHelpInfo({super.key, required this.request});

  final RequestModel request;

  @override
  State<ContactHelpInfo> createState() => _ContactHelpInfoState();
}

class _ContactHelpInfoState extends State<ContactHelpInfo> {
  Future<String> _getAddress(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      String city = placemarks.first.locality ?? '';
      String street = placemarks.first.street ?? '';
      return '$city $street';
    } catch (e) {
      return 'Адрес не найден';
    }
  }

  @override
  void initState() {
    super.initState();
    getcall();
  }

  Future<void> getcall() async {
    final res =
        await Api.getLatestRequestsPerPersonByCard(widget.request.cardId);
    print(res);
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
          title: AppbarTitle(text: "Оповещение"),
          styleType: Style.bgFillBlue60001),
      body: FutureBuilder<String>(
        future: _getAddress(widget.request.lat, widget.request.lon),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ошибка при получении адреса'));
          } else {
            String address = snapshot.data ?? 'Неизвестный адрес';

            return Column(
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset('assets/icons/w.svg'),
                const Text(
                  'Вашему родственнику\nпонадобилась помощь',
                  style: TextStyle(
                      color: Color.fromRGBO(44, 62, 79, 1),
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 17),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        const BoxShadow(
                            color: Color.fromRGBO(120, 120, 120, 0.23),
                            blurRadius: 13)
                      ]),
                  child: Column(
                    children: [
                      Text(widget.request.fullName,
                          style: const TextStyle(
                              color: Color.fromRGBO(44, 62, 79, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      const Divider(
                        color: Color.fromRGBO(221, 222, 226, 1),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Причина\nвызова:',
                            style: TextStyle(
                                color: Color.fromRGBO(44, 62, 79, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          const Spacer(),
                          Expanded(
                              child: Text(
                            widget.request.detail,
                            style: const TextStyle(
                                color: Color.fromRGBO(51, 132, 226, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                      const Divider(
                        color: Color.fromRGBO(221, 222, 226, 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Место\nвызова:',
                            style: TextStyle(
                                color: Color.fromRGBO(44, 62, 79, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          const Spacer(),
                          Expanded(
                              child: Text(
                            address,
                            style: const TextStyle(
                                color: Color.fromRGBO(51, 132, 226, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                      const Divider(
                        color: Color.fromRGBO(221, 222, 226, 1),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Место куда\nповезут:',
                            style: TextStyle(
                                color: Color.fromRGBO(44, 62, 79, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Нет данных',
                            style: TextStyle(
                                color: Color.fromRGBO(51, 132, 226, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50, top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              UrlService.launchPhoneDialer(
                                  widget.request.phone.toString());
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/call1.svg',
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Телефон',
                                  style: TextStyle(
                                      color: Color.fromRGBO(142, 150, 155, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          )),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackingScreenContact(
                                        lat: widget.request.lat,
                                        lng: widget.request.lon)),
                              );
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/map.svg',
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Отследить',
                            style: TextStyle(
                                color: Color.fromRGBO(142, 150, 155, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
