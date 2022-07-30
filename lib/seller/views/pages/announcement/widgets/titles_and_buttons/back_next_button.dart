import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:picco/seller/views/pages/announcement/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/11-overview_announceme/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/4-address_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/7-image_upload_page/provider.dart';
import 'package:picco/services/color_service.dart';
import 'package:provider/provider.dart';

class NextBackButtons extends StatelessWidget {
  final AnimationController controller;

  const NextBackButtons({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AnnouncementProvider>(context);
    final isDisabled = context.watch<AddressPageProvider>().isDisabled;
    final imageUploadProvider = context.watch<ImageUploadProvider>();
    return Column(
      children: [
        Divider(
          height: 3,
          thickness: 3,
          endIndent: (1 - provider.currentPageIndex / 11).sw,
          color: ColorService.main,
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: const Text(
                  'Назад',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () async {
                  if (provider.headers[provider.currentPageIndex].isNotEmpty) {
                    controller
                      ..repeat(reverse: false)
                      ..forward();
                  }
                  provider.pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
              ),
              MaterialButton(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: 50.h,
                color:
                    provider.checkMapSelect(
                                isDisabled,
                                Provider.of<AddressPageProvider>(context)
                                    .street
                                    .isEmpty) ||
                            provider.currentPageIndex == 6 &&
                                !Provider.of<ImageUploadProvider>(context)
                                    .showCheckLottie ||
                            provider.currentPageIndex == 7 &&
                                imageUploadProvider.imagesDownloadUrls.length <
                                    5
                        ? Colors.grey.shade300
                        : ColorService.main,
                textColor: provider.checkMapSelect(
                            isDisabled,
                            Provider.of<AddressPageProvider>(context)
                                .street
                                .isEmpty) ||
                        provider.currentPageIndex == 7 &&
                            imageUploadProvider.imagesDownloadUrls.length < 5
                    ? Colors.black45
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                disabledColor: provider.checkMapSelect(
                            isDisabled,
                            Provider.of<AddressPageProvider>(context)
                                .street
                                .isEmpty) ||
                        provider.checkImageIsNull(
                          Provider.of<ImageUploadProvider>(
                            context,
                            listen: false,
                          ),
                        )
                    ? Colors.grey.shade300
                    : ColorService.main,
                onPressed: provider.isLoading
                    ? null
                    : provider.checkMapSelect(
                            isDisabled,
                            Provider.of<AddressPageProvider>(context)
                                .street
                                .isEmpty)
                        ? null
                        : provider.checkImageIsNull(
                            Provider.of<ImageUploadProvider>(context,
                                listen: false),
                          )
                            ? null
                            : () async {
                                if (provider.currentPageIndex == 10) {
                                  provider.uploadIsLoading();
                                  await Provider.of<
                                      OverviewAnnouncementProvider>(
                                    context,
                                    listen: false,
                                  ).sendHouseToFirebaseFirestore(context).then(
                                    (value) {
                                      provider.uploadIsLoading();
                                      Navigator.pop(context);
                                    },
                                  );
                                }
                                if (provider.currentPageIndex == 7 &&
                                    imageUploadProvider
                                            .imagesDownloadUrls.length <
                                        5) {
                                  null;
                                } else {
                                  if (provider
                                      .headers[provider.currentPageIndex]
                                      .isNotEmpty) {
                                    controller
                                      ..repeat(reverse: false)
                                      ..forward();
                                  }
                                  provider.pageController
                                      .nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  )
                                      .then((value) {
                                    Provider.of<ImageUploadProvider>(context,
                                            listen: false)
                                        .showCheckLottie = false;
                                  });
                                }
                              },
                child: provider.isLoading
                    ? Lottie.asset(
                        "assets/lottie/loading_into_button.json",
                        height: 50.h,
                      )
                    : Text(
                        provider.currentPageIndex == 10 ? 'Сохранить' : 'Далее',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
