import 'package:flutter/material.dart';
import 'package:picco/animations/background_animation_page/provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/seller/views/pages/announcement/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/10-price_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/11-overview_announceme/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/2-sale_types_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/3-property_types/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/4-address_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/5-property_features/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/5-property_features/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/6-property_benefits_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/7-image_upload_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/9-title_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/titles_and_buttons/back_next_button.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/1-Intro_page/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/2-sale_types_page/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/3-property_types/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/4-address_page/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/6-property_benefits_page/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/7-image_upload_page/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/8-image_view_page/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/9-title_page/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/10-price_page/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/11-overview_announceme/view.dart';
import 'package:picco/seller/views/pages/announcement/widgets/titles_and_buttons/titles.dart';
import 'package:picco/seller/views/pages/announcement/widgets/titles_and_buttons/start_button.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Tween<double> tween;
  late Animation<double> opacityAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    tween = Tween(begin: 0.0, end: 1.0);
    opacityAnimation = tween.animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AnnouncementProvider()),
        ChangeNotifierProvider(
            create: (context) => BackgroundAnimationPageProvider()),
        ChangeNotifierProvider(create: (context) => SaleTypesProvider()),
        ChangeNotifierProvider(create: (context) => PropertyTypeProvider()),
        ChangeNotifierProvider(create: (context) => AddressPageProvider()),
        ChangeNotifierProvider(create: (context) => PropertyFeaturesProvider()),
        ChangeNotifierProvider(create: (context) => PropertyBenefitsProvider()),
        ChangeNotifierProvider(create: (context) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (context) => SetTitleProvider()),
        ChangeNotifierProvider(create: (context) => SetPriceProvider()),
        ChangeNotifierProvider(
            create: (context) => OverviewAnnouncementProvider()),
      ],
      builder: (context, child) => _BuildPage(),
    );
  }
}

class _BuildPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final animation =
        context.findAncestorStateOfType<_AnnouncementPageState>()!;
    final provider1 = context.watch<BackgroundAnimationPageProvider>();
    final provider = context.read<AnnouncementProvider>();
    final heights =
        context.select((AnnouncementProvider provider) => provider.heights);
    final currentPageIndex = context
        .select((AnnouncementProvider provider) => provider.currentPageIndex);
    return WillPopScope(
      onWillPop: () async {
        Utils.dialogCommon(
            context,
            "Выйти",
            "Если вы покинете домашнюю страницу, вся введенная вами информация будет потеряна!",
            false, () {
          Navigator.pop(context, true);
        }, "Выйти")
            .then((value) {
          if (value == true) {
            context.read<ImageUploadProvider>().clear();
            Navigator.pop(context,false);
          }
        });
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: provider.currentPageIndex == 10
            ? null
            : AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ).onTap(
                    function: () async {
                      await Utils.dialogCommon(
                              context,
                              "Выйти",
                              "Если вы покинете домашнюю страницу, вся введенная вами информация будет потеряна!",
                              false, () {
                        Navigator.pop(context, true);
                      }, "Выйти")
                          .then((value) {
                        if (value == true) {
                          context.read<ImageUploadProvider>().clear();
                          Navigator.pop(context,false);
                        }
                      });
                    },
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      elevation: 0.0,
                      color: Colors.grey.withOpacity(0.25),
                      onPressed: () {},
                      child: const Text(
                        'Помощь',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        body: AnimatedContainer(
          duration: const Duration(seconds: 2),
          onEnd: () => provider1.onEnd(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: provider1.begin,
              end: provider1.end,
              colors: [provider1.bottomColor, provider1.topColor],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (provider.headers[provider.currentPageIndex].isNotEmpty)
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomLeft,
                    child: FadeTransition(
                      opacity: animation.opacityAnimation,
                      child: const Titles(),
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0.r)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    AnimatedContainer(
                      height: heights[currentPageIndex],
                      width: 1.sw,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutSine,
                      child: PageView(
                        controller: provider.pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          IntroPage(), //0
                          SaleTypes(), //1
                          PropertyType(), //2
                          AddressPage(), //3
                          PropertyFeatures(), //4
                          PropertyBenefits(), //5
                          ImageUpload(), //6
                          ImageView(), //7
                          SetTitle(), //8
                          SetPrice(), //9
                          OverviewAnnouncement(), //10
                        ],
                        onPageChanged: (int index) {
                          provider.updatePageIndex(index);
                        },
                      ),
                    ),
                    if (currentPageIndex == 0)
                      StartButton(controller: animation.controller),
                    if (currentPageIndex > 0 && currentPageIndex < 11)
                      NextBackButtons(controller: animation.controller),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
