import 'package:careme24/blocs/blocs.dart';
import 'package:careme24/blocs/dangerous/dangerous_cubit.dart';
import 'package:careme24/blocs/drawer/drawer_cubit.dart';
import 'package:careme24/blocs/institution/institution_cubit.dart';
import 'package:careme24/blocs/request/request_cubit.dart';
import 'package:careme24/blocs/review/review_cubit.dart';
import 'package:careme24/blocs/search/cubit/search_cubit.dart';
import 'package:careme24/blocs/service/service_cubit.dart';
import 'package:careme24/pages/doctors/favorites_cubit.dart';
import 'package:careme24/pages/medical_bag/cubit/aid_kit_cubit.dart';
import 'package:careme24/pages/medicines/cubit/intake_cubit.dart';
import 'package:careme24/pages/medicines/cubit/medicines_cubit.dart';
import 'package:careme24/features/notifications/notifications_ctrl.dart';
import 'package:careme24/pages/wallet/wallet_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc {
  static final applicationCubit = ApplicationCubit();
  static final authCubit = AuthCubit();
  static final medCardCubit = MedCardCubit();
  static final contactsCubit = ContactsCubit();
  static final searchCubit = SearchCubit();
  static final dangerousCubit = DangerousCubit();
  static final drawerCubit = DrawerCubit();
  static final balanceCubit = ChangeBalanceCubit();
  static final requestCubit = RequestCubit();
  static final institutionCubit = InstitutionCubit();
  static final serviceCubit = ServiceCubit();
  static final favoritesCubit = FavoriteCubit();
  static final reviewsCubit = ReviewCubit();
  static final aidKitCubit = AidKitCubit();
  static final medicinaCubit = MedicineCubit();
  static final inTakeTimeCubit = InTakeTimeCubit();
  static final notificationCubit = NotificationsCtrl();

  static final List<BlocProvider> providers = [
    BlocProvider<ApplicationCubit>(create: (context) => applicationCubit),
    BlocProvider<AuthCubit>(create: (context) => authCubit),
    BlocProvider<MedCardCubit>(create: (context) => medCardCubit),
    BlocProvider<ContactsCubit>(create: (context) => contactsCubit),
    BlocProvider<SearchCubit>(create: (context) => searchCubit),
    BlocProvider<SearchCubit>(create: (context) => searchCubit),
    BlocProvider<DangerousCubit>(create: (context) => dangerousCubit),
    BlocProvider<DrawerCubit>(create: (context) => drawerCubit),
    BlocProvider<ChangeBalanceCubit>(create: (context) => balanceCubit),
    BlocProvider<RequestCubit>(create: (context) => requestCubit),
    BlocProvider<InstitutionCubit>(create: (context) => institutionCubit),
    BlocProvider<ServiceCubit>(create: (context) => serviceCubit),
    BlocProvider<FavoriteCubit>(create: (context) => favoritesCubit),
    BlocProvider<ReviewCubit>(create: (context) => reviewsCubit),
    BlocProvider<AidKitCubit>(create: (context) => aidKitCubit),
    BlocProvider<MedicineCubit>(create: (context) => medicinaCubit),
    BlocProvider<InTakeTimeCubit>(create: (context) => inTakeTimeCubit),
  ];

  static void dispose() {
    applicationCubit.close();
    authCubit.close();
    medCardCubit.close();
    contactsCubit.close();
    searchCubit.close();
    dangerousCubit.close();
    drawerCubit.close();
    balanceCubit.close();
    requestCubit.close();
    institutionCubit.close();
    searchCubit.close();
    serviceCubit.close();
    favoritesCubit.close();
    reviewsCubit.close();
    aidKitCubit.close();
    medicinaCubit.close();
    inTakeTimeCubit.close();
  }

  ///Singleton factory
  AppBloc._internal();

  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }
}
