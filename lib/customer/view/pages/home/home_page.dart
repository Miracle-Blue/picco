import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picco/customer/view/pages/home/local_widgets/home_controller.dart';
import 'package:picco/customer/viewmodel/providers/auth_provider.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/models/all_models.dart';
import 'package:picco/services/connectivity_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

import 'local_widgets/app_bar.dart';
import 'local_widgets/attractive_place/attraction_places_view.dart';
import 'local_widgets/attractive_place/floating_action_button.dart';
import 'local_widgets/choose_city_view.dart';
import 'local_widgets/header_image.dart';
import 'local_widgets/tab_bar_indicator.dart';
import 'local_widgets/tab_bar_view_body.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  PageController pageController = PageController();
  late Timer _timer;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (pageController.page ==
          double.parse((imagesHeader.length - 1).toString())) {
        pageController.jumpToPage(0);
      } else {
        int nextPage =
            int.parse(pageController.page.toString().substring(0, 1)) + 1;
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
    super.initState();
  }

  @override
  deactivate() {
    _timer.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Log.d("home page");
    final connection = context.watch<ConnectivityResult>();
    return ChangeNotifierProvider(
      create: (BuildContext context) => HomeController(),
      builder: (context, _) {
        final homeProvider = context.watch<HomeController>();
        return Scaffold(
          appBar: homeAppBar(homeProvider),
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              ListView(
                children: [
                  ///header img
                  HeaderImgHomePage(
                    provider: homeProvider,
                    pageController: pageController,
                  ),

                  ///tab bar
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Аренда домов'),
                      Tab(text: 'Купить дома'),
                    ],
                    indicator: const MD2Indicator(
                      indicatorSize: MD2IndicatorSize.normal,
                      indicatorHeight: 3.0,
                      indicatorColor: Color.fromRGBO(113, 105, 249, 1),
                    ),
                    unselectedLabelColor: Colors.black,
                    labelColor: const Color.fromRGBO(113, 105, 249, 2),
                    onTap: (value) {
                      ConnectivityService.isConnectInternet(
                          connection, context);
                      if (value == 1) {
                        HapticFeedback.heavyImpact();
                      }
                    },
                  ),

                  ///tab bar view
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: <Widget>[
                        TabBarViewBody(
                          listBlockedTypes: const [],
                          typeSale: "Rent",
                          houseTypeIndex: homeProvider.houseTypeIndex,
                        ),
                        TabBarViewBody(
                          listBlockedTypes: const [3, 5],
                          typeSale: "Buy",
                          houseTypeIndex: homeProvider.houseTypeIndex,
                        ),
                      ],
                    ),
                  ),

                  ///choosing city
                  categoryTextWithPadding('Выберите город'),

                  ///city list
                  const ChooseCityView(),

                  ///looking attraction places
                  categoryTextWithPadding('Привлекательные места'),

                  const SizedBox(height: 20),

                  ///attraction places list
                  const AttractionPlaceView(),

                  const SizedBox(height: 30),
                ],
              ),
              FloatingActionButtonHomePage(timer: _timer),
            ],
          ),
        );
      },
    );
  }
}
