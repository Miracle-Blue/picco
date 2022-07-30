import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/10-price_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/4-address_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/5-property_features/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/6-property_benefits_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/7-image_upload_page/provider.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class OverviewAnnouncement extends StatelessWidget {
  const OverviewAnnouncement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: (4 / 2.5),
                child: Stack(
                  fit: StackFit.expand,
                  children: const [
                    /// * images
                    _Images(),

                    /// * image tap control
                    _TapControl(),

                    /// * top Indicators
                    _TopWhiteImageIndicators(),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: RichText(
                  text: TextSpan(
                    text: "${addressPageProvider.city}, ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: "${addressPageProvider.region}, ",
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: "улица ${addressPageProvider.street}",
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "\$${context.read<SetPriceProvider>().price}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          const Divider(),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Selector<UserProvider, String>(
                    selector: (context, provider) =>
                        provider.user.fullName ?? "Jasco",
                    builder: (context, value, child) {
                      return Text(
                        "Арендуемое жилье целиком, хозяин:\n$value",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          const Divider(),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                  "${context.read<PropertyFeaturesProvider>().bathsNumber} baths"),
              Text(
                  "${context.read<PropertyFeaturesProvider>().bedsNumber} beds"),
              Text(
                  "${context.read<PropertyFeaturesProvider>().roomsNumber} rooms"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.read<PropertyFeaturesProvider>().homeArea} m',
                  ),
                  Text(
                    '2',
                    style: TextStyle(
                      fontSize: 6.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          const Divider(),
          const SizedBox(height: 10.0),
          const Text(
            'Удобство',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10.0),
          for (int i = 0;
              i <
                  context
                      .read<PropertyBenefitsProvider>()
                      .facilities
                      .length;
              i++)
            if (context.read<PropertyBenefitsProvider>().facilities.values.toList()[i])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  context
                      .read<PropertyBenefitsProvider>()
                      .media
                      .values
                      .toList()[i],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
        ],
      ),
    );
  }
}

class _Images extends StatelessWidget {
  const _Images({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = context.read<ImageUploadProvider>().imagesDownloadUrls;
    final pageController =
        context.read<OverviewAnnouncementProvider>().pageController;
    final provider = context.watch<OverviewAnnouncementProvider>();

    return PageView.builder(
      controller: pageController,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return CachedNetworkImage(
          imageUrl: images[index],
          placeholder: (context, url) => const ColoredBox(
            color: Color(0x999f9f9f),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.cover,
        );
      },
      onPageChanged: provider.changedPage,
    );
  }
}

class _TapControl extends StatelessWidget {
  const _TapControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final length =
        context.read<ImageUploadProvider>().imagesDownloadUrls.length;
    final provider = context.read<OverviewAnnouncementProvider>();

    return SizedBox(
      height: 250.h,
      width: 100.sw,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => provider.moveLeft(length),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => provider.moveRight(length),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => provider.moveRight(length),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopWhiteImageIndicators extends StatelessWidget {
  const _TopWhiteImageIndicators({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<OverviewAnnouncementProvider>();
    final images = context.read<ImageUploadProvider>().imagesDownloadUrls;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        height: 5.h,
        width: 100.sw,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < images.length; i++)
              Expanded(
                child: AnimatedContainer(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: (i == provider.currentPage)
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  duration: const Duration(milliseconds: 200),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
