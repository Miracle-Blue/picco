import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picco/customer/view/pages/home/local_widgets/home_controller.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/all_models.dart';
import 'package:picco/services/connectivity_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';

class TabBarViewBody extends StatelessWidget {
  final List listBlockedTypes;
  final String typeSale;
  final int houseTypeIndex;

  const TabBarViewBody({
    Key? key,
    required this.listBlockedTypes,
    required this.typeSale,
    required this.houseTypeIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            for (int i = 0; i < 3; i++) box(i, context),
          ],
        ).addExpanded(),
        const SizedBox(height: 10),
        Row(
          children: [
            for (int i = 3; i < 6; i++) box(i, context),
          ],
        ).addExpanded(),
        const SizedBox(height: 10),
      ],
    );
  }

  Expanded box(int i, BuildContext context) {
    final connection = context.watch<ConnectivityResult>();
    final homeProvider = context.read<HomeController>();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: boxDecoration(i, homeProvider),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppArtList.products[i].logo,
            height: 35,
            color: homeProvider.response["typeHouse"]!.isNotEmpty &&
                    i == 0 &&
                    typeSale != "Buy"
                ? Colors.white
                : Colors.black,
          ),
          const SizedBox(height: 6),
          Text(
            AppArtList.products[i].name,
            style: TextStyle(
              fontSize: 12,
              color: homeProvider.response["typeHouse"]!.isNotEmpty &&
                      i == 0 &&
                      typeSale != "Buy"
                  ? Colors.white
                  : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).onTap(function: () {
      Log.d(homeProvider.response.toString());
      ConnectivityService.isConnectInternet(connection, context);
      if ((i != 0 && typeSale == "Rent") || (typeSale == "Buy")) {
        HapticFeedback.heavyImpact();
        if (connection != ConnectivityResult.none) {
          Utils.dialogWithRichTextBody(
            context,
            "Исправляется",
            "Сейчат, Вы можете выбрать только ",
            "Аренда домов - Дома / Квартира",
          );
        }
      }
      if (listBlockedTypes.contains(i)) return;
      homeProvider.callToHouseType(i);
      homeProvider.callToSaleType(typeSale);
    }).addExpanded();
  }

  BoxDecoration boxDecoration(int i, HomeController homeProvider) {
    return BoxDecoration(
      color: listBlockedTypes.contains(i)
          ? const Color.fromRGBO(0, 0, 0, 0.12)
          : homeProvider.response["typeHouse"]!.isNotEmpty &&
                  i == 0 &&
                  typeSale != "Buy"
              ? const Color.fromRGBO(113, 105, 249, 1)
              : Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(172, 172, 172, 0.4),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ],
    );
  }
}
