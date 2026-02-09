import 'package:careme24/router/app_router.dart';
import 'package:careme24/main.dart';
import 'package:careme24/blocs/application/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoAuthOverlay extends StatelessWidget {
  final Widget child;

  const NoAuthOverlay({super.key, required this.child});

  void _goToRegister() {
    navigatorKey.currentState?.pushNamed(AppRouter.registerEmailPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationCubit, ApplicationState>(
      builder: (context, state) {
        final isAuthorized =
            state is ApplicationCompleted && state.isAuthorized;

        return Stack(
          children: [
            child,
            if (!isAuthorized)
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: GestureDetector(
                  onTap: _goToRegister,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Не активно",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(221, 29, 162, 228),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
