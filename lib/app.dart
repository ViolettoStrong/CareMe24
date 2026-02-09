import 'package:careme24/blocs/blocs.dart';
import 'package:careme24/injection_container.dart';
import 'package:careme24/main.dart';
import 'package:careme24/router/app_router.dart';
import 'package:careme24/theme/app_theme.dart';
import 'package:careme24/widgets/no_internet_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await setupLocator();
    await AppBloc.applicationCubit.onSetup();
  }

  // Initialize Firebase and FCM

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBloc.providers,
      child: BlocBuilder<ApplicationCubit, ApplicationState>(
        builder: (context, state) {
          if (state is ApplicationCompleted) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              supportedLocales: const [Locale('ru')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              theme: AppTheme.theme,
              initialRoute: state.error
                  ? AppRouter.errorScreen
                  : state.isAuthorized
                      ? AppRouter.appContainer
                      : AppRouter.appContainer,
              routes: AppRouter.routes,
              navigatorKey: navigatorKey,
              builder: (context, child) {
                return FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 10)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return child ?? const SizedBox();
                    }
                    return NoInternetOverlay(child: child ?? const SizedBox());
                  },
                );
              },
            );
          } else {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }
        },
      ),
    );
  }
}
