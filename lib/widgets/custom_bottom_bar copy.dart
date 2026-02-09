import 'package:careme24/app_container.dart';
import 'package:careme24/theme/theme.dart';
import 'package:careme24/utils/utils.dart';
import 'package:careme24/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key, this.onChanged});

  final Function(BottomBarEnum)? onChanged;

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int selectedIndex = 0;

  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
      icon: ImageConstant.imgFrameBlue600,
      title: "Главная",
      type: BottomBarEnum.tf,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgLocationGray400,
      title: "Мед",
      type: BottomBarEnum.med,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgFrameGray40001,
      title: "Полиция",
      type: BottomBarEnum.police,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgFireGray40001,
      title: "МЧС",
      type: BottomBarEnum.mchs,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.whiteA700,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.black9003f,
            spreadRadius: getHorizontalSize(
              2,
            ),
            blurRadius: getHorizontalSize(
              2,
            ),
            offset: const Offset(
              0,
              -1,
            ),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: List.generate(bottomMenuList.length, (index) {
          return BottomNavigationBarItem(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  svgPath: bottomMenuList[index].icon,
                  height: getVerticalSize(
                    21,
                  ),
                  width: getHorizontalSize(
                    24,
                  ),
                  color: ColorConstant.gray400,
                ),
                Padding(
                  padding: getPadding(
                    top: 5,
                  ),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratSemiBold9Gray400.copyWith(
                      color: ColorConstant.gray400,
                    ),
                  ),
                ),
              ],
            ),
            activeIcon: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  svgPath: bottomMenuList[index].icon,
                  height: getSize(
                    23,
                  ),
                  width: getSize(
                    23,
                  ),
                  color: ColorConstant.blue600,
                ),
                Padding(
                  padding: getPadding(
                    top: 4,
                  ),
                  child: Text(
                    bottomMenuList[index].title ?? "",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtMontserratSemiBold9.copyWith(
                      color: ColorConstant.blue600,
                    ),
                  ),
                ),
              ],
            ),
            label: '',
          );
        }),
        onTap: (index) {
          selectedIndex = index;
          widget.onChanged?.call(bottomMenuList[index].type);
          switch (index) {
            case 0:
              bottomMenuList[index].type = BottomBarEnum.tf;
              break;
            case 1:
              bottomMenuList[index].type = BottomBarEnum.med;
              break;
            case 2:
              bottomMenuList[index].type = BottomBarEnum.police;
              break;
            case 3:
              bottomMenuList[index].type = BottomBarEnum.mchs;
              break;
            default:
              bottomMenuList[index].type = BottomBarEnum.tf;
          }

          if (bottomMenuList[index].type == BottomBarEnum.tf) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AppContainer(0)));
          }
          if (bottomMenuList[index].type == BottomBarEnum.med) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AppContainer(1)));
          }
          if (bottomMenuList[index].type == BottomBarEnum.police) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AppContainer(2)));
          }
          if (bottomMenuList[index].type == BottomBarEnum.mchs) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AppContainer(3)));
          }
          setState(() {});
        },
      ),
    );
  }
}

enum BottomBarEnum { tf, med, police, mchs }

class BottomMenuModel {
  BottomMenuModel({required this.icon, this.title, required this.type});

  String icon;

  String? title;

  BottomBarEnum type;
}

class DefaultWidget extends StatelessWidget {
  const DefaultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: const Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
