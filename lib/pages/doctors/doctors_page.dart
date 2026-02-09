import 'package:careme24/api/api.dart';
import 'package:careme24/pages/doctors/favorites_cubit.dart';
import 'package:careme24/pages/doctors/favorites_state.dart';
import 'package:careme24/pages/services_call/doctor_call_page_fav.dart';
import 'package:careme24/pages/services_call/select_reason_screen.dart';
import 'package:careme24/theme/app_style.dart';
import 'package:careme24/theme/color_constant.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:careme24/widgets/custom_image_view.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

enum HistoryTab { doctors, institutions, services }

enum SubTab { med, pol, mch, emergency112 }

class DoctorsPage extends StatefulWidget {
  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  String? selectedReason;
  HistoryTab selectedTab = HistoryTab.doctors;
  SubTab selectedSubTab = SubTab.med;

  @override
  void initState() {
    super.initState();
    context.read<FavoriteCubit>().fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: getVerticalSize(48),
        leadingWidth: 43,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: AppbarTitle(text: "История заявок"),
        styleType: Style.bgFillBlue60001,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            /// 🔹 TOP SEGMENTED MENU
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTab(HistoryTab.doctors, 'Врачи'),
                    _buildTab(HistoryTab.institutions, 'Институты'),
                    _buildTab(HistoryTab.services, '  Частные услуги  '),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),
            if (selectedTab == HistoryTab.institutions ||
                selectedTab == HistoryTab.services)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildSubTab(SubTab.med, 'МЕД'),
                      _buildSubTab(SubTab.pol, 'ПОЛ'),
                      _buildSubTab(SubTab.mch, 'МЧС'),
                      selectedTab == HistoryTab.institutions
                          ? _buildSubTab(SubTab.emergency112, 'Я очевидец')
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),

            /// 🔹 CONTENT
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  String get currentType {
    switch (selectedSubTab) {
      case SubTab.med:
        return 'med';
      case SubTab.pol:
        return 'pol';
      case SubTab.mch:
        return 'mch';
      case SubTab.emergency112:
        return '112';
    }
  }

  Widget _buildSubTab(SubTab tab, String title) {
    final isActive = selectedSubTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSubTab = tab;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? ColorConstant.blue60001 : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- TAB BUTTON ----------
  Widget _buildTab(HistoryTab tab, String title) {
    final bool isActive = selectedTab == tab;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = tab;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? ColorConstant.blue60001 : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  /// ---------- CONTENT SWITCH ----------
  Widget _buildContent() {
    switch (selectedTab) {
      case HistoryTab.doctors:
        return _buildDoctorsTab();
      case HistoryTab.institutions:
        return _emptyPlaceholder('История вызовов институтов');
      case HistoryTab.services:
        return _emptyPlaceholder('История частных услуг');
    }
  }

  Widget _buildDoctorsTab() {
    return BlocBuilder<FavoriteCubit, FavoriteState>(
      buildWhen: (previous, current) =>
          current is FavoriteLoadedGet || current is FavoriteLoading,
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is FavoriteLoadedGet) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavoriteCubit>().fetchFavorites();
            },
            child: ListView(
              children: [
                /// PROBLEM SELECT
                GestureDetector(
                  onTap: () async {
                    final reason = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectReasonScreen(type: 'med'),
                      ),
                    );
                    if (reason != null) {
                      setState(() => selectedReason = reason);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(178, 218, 255, 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedReason ?? 'Проблема',
                              style: AppStyle.txtMontserratSemiBold19,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          CustomImageView(
                            svgPath: ImageConstant.imgArrowdownLightBlue900,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// FAVORITE DOCTORS
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: state.serviceList.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final item = state.serviceList[index];

                    return GestureDetector(
                      onTap: () {
                        if (selectedReason == null) {
                          ElegantNotification.error(
                            description: const Text('Выберите причину вызова'),
                          ).show(context);
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorCallScreenFav(
                                reason: selectedReason!,
                                serviceModel: item,
                                cardId: item.serviceId,
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: NetworkImage(item.service.photo),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              item.service.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context
                                  .read<FavoriteCubit>()
                                  .deletFavorites(item.serviceId);
                            },
                            child: CustomImageView(
                              svgPath: ImageConstant.heart_fav,
                              height: 24,
                              width: 24,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  /// ---------- PLACEHOLDER ----------
  Widget _emptyPlaceholder(String text) {
    if (text == 'История частных услуг') {
      return AppointmentListBody(
        type: currentType,
      );
    } else if (text == 'История вызовов институтов') {
      return AppointmentListBodyInstitutions(
        type: currentType,
        page: 'institutions',
      );
    }
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}

class AppointmentListBody extends StatelessWidget {
  final String type;
  final String? page;
  const AppointmentListBody({super.key, required this.type, this.page});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: (type == 'pol' || type == 'mch')
          ? Api.getStatments(type)
          : Api.getAppointments(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(child: Text('Нет записей'));
        }

        data.sort((a, b) {
          try {
            if (type == 'pol' || type == 'mch') {
              final dateA = DateTime.parse(a['created_at']).toLocal();
              final dateB = DateTime.parse(b['created_at']).toLocal();
              return dateB.compareTo(dateA);
            } else {
              final dateA = DateTime.parse(a['appointment_time']).toLocal();
              final dateB = DateTime.parse(b['appointment_time']).toLocal();
              return dateB.compareTo(dateA);
            }
          } catch (_) {
            return 0;
          }
        });

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final service = item['service'];
            final doctorName = service?['name'] ?? 'Без имени';
            final photoUrl = service?['photo'];
            final address = service?['work_place'] ?? 'Адрес не указан';

            String dateInfo = '';

            if (type == 'pol' || type == 'mch') {
              final createdAt = DateTime.parse(item['created_at']).toLocal();
              dateInfo = DateFormat('dd.MM.yyyy HH:mm').format(createdAt);
            } else {
              try {
                final dt = DateTime.parse(item['appointment_time']).toLocal();
                dateInfo = '${DateFormat('dd.MM.yyyy').format(dt)} '
                    '${DateFormat('HH:mm').format(dt)}';
              } catch (_) {}
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          photoUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, size: 50),
                title: Text(
                  type == 'med' ? 'Запись к $doctorName' : doctorName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  type == 'pol' || type == 'mch'
                      ? 'Дата регистрации: $dateInfo\nАдрес: $address'
                      : 'Дата и время: $dateInfo\nАдрес: $address',
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class AppointmentListBodyInstitutions extends StatelessWidget {
  final String type;
  final String? page;
  const AppointmentListBodyInstitutions(
      {super.key, required this.type, this.page});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: type == '112' ? Api.getRequests112Archive() : Future.value([]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        }

        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(child: Text('Нет записей'));
        }

        data.sort((a, b) {
          try {
            if (type == 'pol' || type == 'mch' || type == '112') {
              final dateA = DateTime.parse(a['created_at']).toLocal();
              final dateB = DateTime.parse(b['created_at']).toLocal();
              return dateB.compareTo(dateA);
            } else {
              final dateA = DateTime.parse(a['appointment_time']).toLocal();
              final dateB = DateTime.parse(b['appointment_time']).toLocal();
              return dateB.compareTo(dateA);
            }
          } catch (_) {
            return 0;
          }
        });

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final item = data[index];
            final service = item['service'];
            final doctorName = type == '112'
                ? item['detail'] ?? 'Без имени'
                : service?['name'] ?? 'Без имени';
            final photoUrl = service?['photo'];
            final address = type == '112'
                ? item['address'] ?? 'Адрес не указан'
                : service?['work_place'] ?? 'Адрес не указан';

            String dateInfo = '';

            if (type == 'pol' || type == 'mch' || type == '112') {
              final createdAt = DateTime.parse(item['created_at']).toLocal();
              dateInfo = DateFormat('dd.MM.yyyy HH:mm').format(createdAt);
            } else {
              try {
                final dt = DateTime.parse(item['appointment_time']).toLocal();
                dateInfo = '${DateFormat('dd.MM.yyyy').format(dt)} '
                    '${DateFormat('HH:mm').format(dt)}';
              } catch (_) {}
            }

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          photoUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, size: 50),
                title: Text(
                  type == 'med' ? 'Запись к $doctorName' : doctorName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  type == 'pol' || type == 'mch'
                      ? 'Дата регистрации: $dateInfo\nАдрес: $address'
                      : 'Дата и время: $dateInfo\nАдрес: $address',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
