import 'package:cached_network_image/cached_network_image.dart';
import 'package:careme24/blocs/drawer/drawer_cubit.dart';
import 'package:careme24/blocs/drawer/drawer_state.dart';
import 'package:careme24/pages/medical_bag/widgets/custom_gradient_button.dart';
import 'package:careme24/pages/medical_bag/widgets/custom_text_field_dialog.dart';
import 'package:careme24/pages/wallet/change_balance_state.dart';
import 'package:careme24/pages/wallet/wallet_cubit.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:careme24/utils/image_constant.dart';
import 'package:careme24/utils/size_utils.dart';
import 'package:careme24/widgets/app_bar/appbar_image.dart';
import 'package:careme24/widgets/app_bar/appbar_title.dart';
import 'package:careme24/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String sum = '0';
  String imageUrl = '';
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
        title: AppbarTitle(
          text: "Кошелек",
        ),
        styleType: Style.bgFillBlue60001,
        actions: [
          Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AddBalanceDialog();
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 24.0),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset(
                      'assets/images/add_image.png',
                    ),
                  ),
                ),
              )),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DrawerCubit, DrawerState>(builder: (context, state) {
          if (state is DrawerStateLoaded) {
            sum = state.userInfo.balance.toString();
            imageUrl = state.userInfo.personalInfo.avatar;

            return Container(
              height: 92,
              child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {},
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage:
                                  CachedNetworkImageProvider(imageUrl),
                              child: imageUrl == '' || imageUrl.isEmpty
                                  ? const Icon(Icons.person, size: 26)
                                  : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    state.userInfo.personalInfo.full_name,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    sum,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            );
          }
          return Container();
        }),
      )),
    );
  }
}

class AddBalanceDialog extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangeBalanceCubit, ChangeBalanceState>(
      listener: (context, state) {
        if (state is ChangeBalanceSuccess) {
          Navigator.pop(context); // Close the dialog on success
          ElegantNotification.success(
            description: const Text('Баланс успешно пополнен'),
          ).show(context);
        } else if (state is ChangeBalanceError) {
          ElegantNotification.error(
            description: Text(state.error),
          ).show(context);
        }
      },
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: SizedBox(
            height: 250,
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, size: 34),
                          )),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Введите сумму пополнения',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          fontFamily: "Montserrat",
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: CustomTextFieldDialog(
                    hintText: 'Сумма',
                    controller: controller,
                    keyboardType: TextInputType.number, // Allow only numbers
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: CustomGradientButton(
                    text: state is ChangeBalanceLoading
                        ? 'Загрузка...'
                        : 'Пополнить',
                    onPressed: () {
                      final amount = controller.text.trim();
                      if (amount.isEmpty || int.tryParse(amount) == null) {
                        ElegantNotification.error(
                          description: const Text('Введите корректную сумму'),
                        ).show(context);
                        return;
                      }
                      context
                          .read<ChangeBalanceCubit>()
                          .changeBalanceWallet(amount);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
