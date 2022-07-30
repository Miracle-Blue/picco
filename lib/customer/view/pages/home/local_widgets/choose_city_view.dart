import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/pages/home/local_widgets/home_controller.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/all_models.dart';
import 'package:picco/services/connectivity_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

class ChooseCityView extends StatelessWidget {
  const ChooseCityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ImageCityList.list.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => chooseCity(index, context),
      ),
    );
  }

  chooseCity(int index, BuildContext context) {
    final connection = context.watch<ConnectivityResult>();
    final homeProvider = context.watch<HomeController>();
    return Container(
      margin: const EdgeInsets.all(5),
      width: 130.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(ImageCityList.list[index].image),
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: homeProvider.cityTypeIndex == index
              ? Colors.transparent
              : const Color.fromRGBO(0, 0, 0, 0.61),
          borderRadius: BorderRadius.circular(10),
        ),
        child: homeProvider.cityTypeIndex == index
            ? const SizedBox.shrink()
            : Text(
                ImageCityList.list[index].name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ).onTap(function: () {
      ConnectivityService.isConnectInternet(connection, context);
      homeProvider.callToCityType(index);
      Log.d(homeProvider.response.toString());
    });
  }
}
