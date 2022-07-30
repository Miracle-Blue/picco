import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/pages/search/detail_page.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/utils.dart';

class DetailBody extends StatelessWidget {
  const DetailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailModel = DetailPageInherit.read(context)!.detailModel;
    final homeModel =
        context.findAncestorWidgetOfExactType<DetailPage>()!.homeModel;
    // detailModel.updateShowConvenienceCount(4);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: RichText(
                      text: TextSpan(
                          text: homeModel.city + ", ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                          children: [
                            TextSpan(
                              text: homeModel.district + ", ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: homeModel.street,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "\$" + homeModel.price,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              // location
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16.w,
                  ),
                  // TODO: home Model location
                  Text(
                    homeModel.city,
                    style: TextStyle(fontSize: 12.sp),
                  ),
                  GestureDetector(
                    onTap: () =>
                        detailModel.openLocationPage(context, homeModel),
                    child: Text(
                      ' местоположение...',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),

              // components
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TODO: home model
                    _DetailBodyHomeComponents(
                      image: 'assets/detail_icons/bed.png',
                      text:
                          "${homeModel.bedsCount} ${int.tryParse(homeModel.bedsCount)! > 1 ? 'кровати' : 'кровать'}",
                    ),
                    _DetailBodyHomeComponents(
                      image: 'assets/detail_icons/bath.png',
                      text:
                          "${homeModel.bathCount} ${int.tryParse(homeModel.bathCount)! > 1 ? 'ванны' : 'ванна'}",
                    ),
                    _DetailBodyHomeComponents(
                      image: 'assets/detail_icons/room.png',
                      text:
                          "${homeModel.roomsCount} ${int.tryParse(homeModel.roomsCount)! > 1 ? 'комнаты' : 'комната'}",
                    ),
                    _DetailBodyHomeComponents(
                      image: 'assets/detail_icons/plans.png',
                      text: '${homeModel.houseArea}m',
                      exp: '2',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Text("Обновлено: " + homeModel.pushedDate.substring(0, 16)),
              const Divider(),
              SizedBox(height: 10.h),
              // description
              Text(
                "Oписание",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Utils.readMoreText(homeModel.definition),
              SizedBox(height: 10.h),
              const Divider(),
              SizedBox(height: 10.h),

              // offers
              Text(
                "Все удобство",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 15.h),
              const _PlaceOffers(),
              SizedBox(height: 15.h),
              const Divider(),
              SizedBox(height: 10.h),
              if (detailModel.haveSimilar(homeModel))
                Text(
                  "Похожие объявления",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        if (detailModel.haveSimilar(homeModel)) ...[
          SizedBox(
            height: 240.h,
            child: ListView.builder(
              itemCount: detailModel.houses.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 20 : 10,
                    right: index == detailModel.houses.length ? 20 : 10,
                  ),
                  child: _SimilarAdsCard(home: detailModel.houses[index]),
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ],
    );
  }
}

class _PlaceOffers extends StatelessWidget {
  const _PlaceOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailModel = DetailPageInherit.watch(context)!.detailModel;
    final homeModel =
        context.findAncestorWidgetOfExactType<DetailPage>()!.homeModel;

    final getFacilityIndex = [];
    for (int i = 0; i < homeModel.houseFacilities.length; i++) {
      if (homeModel.houseFacilities[i]) {
        getFacilityIndex.add(i);
      }
    }

    return Column(
      children: [
        for (var i in getFacilityIndex.take(detailModel.showConvenienceCount))
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  detailModel.facilityIcons[i],
                  height: 25.w,
                  width: 25.w,
                ),
              ),
              SizedBox(width: 15.w),
              Text(
                detailModel.facilityNames[i],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        SizedBox(height: 10.h),
        if (getFacilityIndex.length > detailModel.showConvenienceCount)
          InkWell(
            onTap: () {
              detailModel.updateShowConvenienceCount(getFacilityIndex.length);
            },
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(width: 1.w),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Показать все удобства: ${getFacilityIndex.length - 4}',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
      ],
    );
  }
}

class _SimilarAdsCard extends StatelessWidget {
  final HomeModel home;

  const _SimilarAdsCard({
    Key? key,
    required this.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailModel = DetailPageInherit.watch(context)!.detailModel;

    return Card(
      elevation: 7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      margin: EdgeInsets.only(left: 0, bottom: 10.w),
      child: SizedBox(
        width: 185.w,
        child: Column(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              width: double.infinity,
              height: 114.h,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10.r),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(home.houseImages.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10.0.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: RichText(
                            text: TextSpan(
                              text: home.city + ", ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: home.district + ", ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                                TextSpan(
                                  text: home.street,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "\$" + home.price,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${home.roomsCount} ${int.tryParse(home.roomsCount)! > 1 ? 'комнаты ' : 'комната '}",
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${home.houseArea} m',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            Text("2", style: TextStyle(fontSize: 10.sp)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailBodyHomeComponents extends StatelessWidget {
  final String image;
  final String text;
  final String? exp;

  const _DetailBodyHomeComponents({
    Key? key,
    required this.image,
    required this.text,
    this.exp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: 70.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 0.001,
            blurRadius: 0.1,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 25.h,
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 10.sp),
              ),
              if (exp != null)
                Text(
                  '2',
                  style: TextStyle(
                    fontSize: 6.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
