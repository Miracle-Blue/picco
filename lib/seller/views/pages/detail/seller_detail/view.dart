import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class SellerDetailPage extends StatelessWidget {
  final HomeModel element;

  const SellerDetailPage({
    Key? key,
    required this.element,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SellerDetailProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.5,
        title: const Text(
          "Статистика",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircularPercentIndicator(
                          animationDuration: 1200,
                          backgroundColor: Colors.grey.shade300,
                          animation: true,
                          radius: 50.0,
                          lineWidth: 10,
                          percent: element.callsCount == element.allViews ||
                                  element.callsCount > element.allViews
                              ? 1.0
                              : (element.callsCount / element.allViews),
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Вызови"),
                              Text(
                                '${element.callsCount}',
                                style: TextStyle(fontSize: 15.sp),
                              ),
                            ],
                          ),
                          progressColor: const Color(0xff7169F9),
                        ),
                        CircularPercentIndicator(
                          animationDuration: 1200,
                          backgroundColor: Colors.grey.shade300,
                          animation: true,
                          radius: 65.0,
                          lineWidth: 10,
                          percent: (1),
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Просмотры",
                                style: TextStyle(fontSize: 13.sp),
                              ),
                              Text(
                                "${element.allViews}",
                                style: TextStyle(fontSize: 17.sp),
                              ),
                            ],
                          ),
                          progressColor: const Color(0xff7169F9),
                        ),
                        CircularPercentIndicator(
                          animationDuration: 1200,
                          backgroundColor: Colors.grey.shade300,
                          animation: true,
                          radius: 50.0,
                          lineWidth: 10,
                          percent: element.smsCount == element.allViews ||
                                  element.smsCount > element.allViews
                              ? 1
                              : ((element.smsCount) / (element.allViews)),
                          center: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Flexible(
                                child: Text("СМС"),
                              ),
                              Text(
                                "${element.smsCount}",
                                style: TextStyle(fontSize: 15.w),
                              ),
                            ],
                          ),
                          progressColor: const Color(0xff7169F9),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: const Divider(height: 1),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: RichText(
                          text: TextSpan(
                            text: "${element.city}, ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.3,
                            ),
                            children: [
                              TextSpan(
                                text: "${element.district}, ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                              TextSpan(
                                text: element.street,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "\$${element.price}",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DetailBodyHomeComponents(
                          image: 'assets/detail_icons/bed.png',
                          text:
                              "${element.bedsCount} ${int.tryParse(element.bedsCount)! > 1 ? 'кровати' : 'кровать'}",
                        ),
                        _DetailBodyHomeComponents(
                          image: 'assets/detail_icons/bath.png',
                          text:
                              "${element.bathCount} ${int.tryParse(element.bathCount)! > 1 ? 'ванны' : 'ванна'}",
                        ),
                        _DetailBodyHomeComponents(
                          image: 'assets/detail_icons/room.png',
                          text:
                              "${element.roomsCount} ${int.tryParse(element.roomsCount)! > 1 ? 'комнаты' : 'комната'}",
                        ),
                        _DetailBodyHomeComponents(
                          image: 'assets/detail_icons/plans.png',
                          text: '${element.houseArea}m',
                          exp: '2',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Обновлено: ${element.pushedDate.substring(0, 16)}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Divider(),
                  SizedBox(height: 10.h),
                  Text(
                    "Все фотографии",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 120.h,
                    width: double.infinity,
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: element.houseImages.length,
                      itemBuilder: (context, index) =>
                          buildListContainer(element.houseImages[index], index),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  const Divider(),
                  SizedBox(height: 10.h),
                  Text(
                    "Описание",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Utils.readMoreText(element.definition),
                  SizedBox(height: 10.h),
                  const Divider(),
                  SizedBox(height: 10.h),
                  Text(
                    "Все удобство",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  const _PlaceOffers(),
                  SizedBox(height: 75.h),
                ],
              ),
            ),
          ),

          ///bottom buttons
          Selector<SellerDetailProvider, bool>(
            selector: (context, provider) => provider.isLoading,
            builder: (context, value, child) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                height: 75.h,
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      color: Colors.white,
                      onPressed: null,
                      minWidth: 0.4.sw,
                      height: 50.h,
                      child: const Text('Изменить'),
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      color: Colors.red,
                      disabledColor: Colors.red,
                      onPressed: value
                          ? null
                          : () async {
                              await Utils.dialogCommon(
                                context,
                                "Удалить",
                                "вы хотите удалить свой дом?",
                                true,
                                () {
                                  context
                                      .read<SellerDetailProvider>()
                                      .deleteHouse(element)
                                      .then(
                                        (value) => Navigator.pop(context),
                                      );
                                },
                                "Удалить",
                              ).then((value) => Navigator.pop(context));
                            },
                      minWidth: 0.4.sw,
                      height: 50.h,
                      child: value
                          ? Lottie.asset(
                              "assets/lottie/loading_into_button.json")
                          : const Text(
                              'Удалить',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ).putElevationOffset(radius: 0.0, elevation: 8.0, y: 5.0, x: 0.0);
            },
          )
        ],
      ),
    );
  }

// List view builder
  Container buildListContainer(String image, int index) => Container(
        margin: EdgeInsets.only(
          left: (index == 0) ? 0 : 5.w,
          right: (index == element.houseImages.length - 1) ? 0 : 5.w,
        ),
        width: 0.3.sw,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image: CachedNetworkImageProvider(image),
            fit: BoxFit.cover,
          ),
        ),
      );

//Grid view builder
  Container buildGridContainer(DetailElements element) => Container(
        margin: EdgeInsets.all(10.w),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          border: Border.all(width: 0.3.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        height: 78.h,
        width: 75.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              element.imageIcon,
              width: 35.w,
              height: 35.h,
            ),
            const Spacer(),
            Text(
              element.rooms,
              style: TextStyle(fontSize: 10.sp),
            )
          ],
        ),
      );
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

//Facilities
class _PlaceOffers extends StatelessWidget {
  const _PlaceOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sellerDetailProvider = context.watch<SellerDetailProvider>();
    final element =
        context.findAncestorWidgetOfExactType<SellerDetailPage>()!.element;

    final getFacilityIndex = [];
    for (int i = 0; i < element.houseFacilities.length; i++) {
      if (element.houseFacilities[i]) {
        getFacilityIndex.add(i);
      }
    }

    return Column(
      children: [
        for (var i
            in getFacilityIndex.take(sellerDetailProvider.showConvenienceCount))
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  sellerDetailProvider.facilityIcons[i],
                  height: 22.w,
                  width: 22.w,
                ),
              ),
              SizedBox(width: 15.w),
              Text(
                sellerDetailProvider.facilityNames[i],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        SizedBox(height: 10.h),
        if (getFacilityIndex.length > sellerDetailProvider.showConvenienceCount)
          InkWell(
            onTap: () {
              sellerDetailProvider
                  .updateShowConvenienceCount(getFacilityIndex.length);
            },
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              height: 40.h,
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              decoration: BoxDecoration(
                border: Border.all(width: 1.w),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Показать все удобства: ${getFacilityIndex.length}',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ),
      ],
    );
  }
}

//grid elements
class DetailElements {
  String rooms;
  String imageIcon;

  DetailElements(this.rooms, this.imageIcon);

  static List<DetailElements> details = [
    DetailElements("Bath", "assets/icons/1.png"),
    DetailElements("Bath", "assets/icons/2.png"),
    DetailElements("Bath", "assets/icons/3.png"),
    DetailElements("Bath", "assets/icons/4.png"),
  ];
}

//list elements
class Detailphotos {
  String photo;

  Detailphotos(this.photo);

  static List<Detailphotos> photos = [
    Detailphotos("assets/images/1.png"),
    Detailphotos("assets/images/2.png"),
    Detailphotos("assets/images/3.png"),
    Detailphotos("assets/images/4.png"),
    Detailphotos("assets/images/5.png"),
    Detailphotos("assets/images/6.png"),
    Detailphotos("assets/images/7.png"),
  ];
}
