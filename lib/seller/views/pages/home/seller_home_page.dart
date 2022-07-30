import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:picco/customer/viewmodel/providers/user_provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/all_models.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/seller/views/pages/announcement/view.dart';
import 'package:picco/seller/views/pages/detail/seller_detail/view.dart';
import 'package:picco/seller/views/pages/home/home_provider.dart';
import 'package:picco/services/color_service.dart';
import 'package:picco/services/data_service.dart';
import 'package:picco/services/deep_link_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/log_service.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';

class SellerHomePage extends StatefulWidget {
  const SellerHomePage({Key? key}) : super(key: key);

  @override
  State<SellerHomePage> createState() => _SellerHomePageState();
}

class _SellerHomePageState extends State<SellerHomePage> {
  @override
  Widget build(BuildContext context) {
    Log.d("seller page");
    return ChangeNotifierProvider(
      create: (context) => HomeProvider(),
      builder: (context, _) => Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///header
                  Container(
                    padding:
                        EdgeInsets.only(top: AppBar().preferredSize.height),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-1, 0),
                        end: Alignment(2.7, 0),
                        colors: [
                          Color(0xff7842D0),
                          Color(0xffE41547),
                          Color(0xffD82490),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Сегодня",
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  CupertinoIcons.bell,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Привет, Сдесь вы можете продать или\nсдать в аренду свои дома без всяких усилий",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                              padding: EdgeInsets.symmetric(
                                vertical: 8.h,
                                horizontal: 15.w,
                              ),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.r)),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AnnouncementPage()),
                                ).then(
                                  (value) {
                                    if (value == null) {
                                      Utils.dialogCommon(
                                        context,
                                        HiveService.getUser().fullName!,
                                        "Sizning uyingiz 1 kun ichida ko'rib chiqiladi va natijasi SMS shaklida boradi!",
                                        true,
                                        () => Navigator.pop(context),
                                      );
                                    }
                                  },
                                );
                              },
                              child: Text(
                                "Создать обявления",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  ),

                  ///main text
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15),
                    child: Text(
                      "Наши дома",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15.w),
                    width: double.infinity,
                    height: 40.h,
                    child: ListView.builder(
                      itemCount: AppArtList.products.length + 1,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) =>
                          houseNameContainer(index, homeProvider),
                    ),
                  ),

                  Consumer<UserProvider>(
                    builder: (context, provider, child) {
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(FirestoreService.usersFolder)
                            .doc(provider.user.id)
                            .collection(FirestoreService.homesFolder)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Padding(
                              padding: EdgeInsets.only(top: 0.2.sh),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            );
                          }
                          if (snapshot.hasError) {
                            return Utils.fireSnackBar(
                              normalText: snapshot.error.toString(),
                              redText: "",
                              context: context,
                            );
                          }
                          if (snapshot.data!.docs.isEmpty) {
                            return _emptyHomeBody();
                          }
                          return homeProvider.selectCategoryIndex == 0 ||
                                  homeProvider.selectCategoryIndex == 1
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  padding: const EdgeInsets.only(top: 15),
                                  itemBuilder: (context, index) {
                                    HomeModel home = HomeModel.fromJson(
                                        snapshot.data!.docs[index].data()
                                            as Map<String, dynamic>);
                                    return card(home, context);
                                  },
                                )
                              : _emptyHomeBody();
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Container _emptyHomeBody() {
    return Container(
      width: 1.sw,
      margin: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 0.07.sh,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade50,
      ),
      height: 0.35.sh,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/home_page_images/seller_home_page_home_icon.png",
            height: 0.1.sh,
            width: 0.1.sw,
          ),
          Text(
            "Объявления пока нет",
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  /// Text upper site button
  Padding houseNameContainer(int index, HomeProvider provider) => Padding(
        padding: EdgeInsets.only(right: 2.w),
        child: Chip(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          backgroundColor: provider.selectCategoryIndex == index
              ? const Color(0xff7169F9)
              : Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.white,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          label: Text(
            index == 0 ? "Все" : AppArtList.products[index - 1].name,
            style: TextStyle(
              color: provider.selectCategoryIndex == index
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ).onTap(
          function: () {
            provider.updateCategory(index);
            Log.d(provider.selectCategoryIndex.toString());
          },
        ),
      );

  Widget card(HomeModel element, BuildContext context) => Container(
        height: 90.h,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          bottom: 5.h,
        ),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //leading
            Expanded(
              flex: 1,
              child: Container(
                height: 80.h,
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl: element.houseImages.first,
                  placeholder: (context, url) =>
                      const ColoredBox(color: Color(0x999f9f9f)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            element.city,
                            style: TextStyle(
                              fontSize: 17.sp,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Text(
                          "\$${element.price}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    Text(
                      element.district,
                      style: TextStyle(
                        fontSize: 12.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "Улица ${element.street}",
                      style: TextStyle(
                        fontSize: 11.sp,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${element.roomsCount} rooms",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${element.houseArea} m',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            ),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).onTap(
        function: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SellerDetailPage(element: element)),
          );
        },
      );
}
