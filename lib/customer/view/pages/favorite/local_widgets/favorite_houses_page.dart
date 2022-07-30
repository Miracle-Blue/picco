import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/pages/search/detail_page.dart';
import 'package:picco/customer/viewmodel/providers/favorite_page_provider.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/home_model.dart';
import 'package:provider/provider.dart';

class FavoriteHousesPage extends StatelessWidget {
  const FavoriteHousesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String nameFolder = ModalRoute.of(context)!.settings.arguments as String;
    return ChangeNotifierProvider(
      create: (BuildContext context) => FavoritePageProvider(),
      builder: (context, _) {
        return Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: context
                .read<FavoritePageProvider>()
                .getFavoriteHouses(nameFolder),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List list = snapshot.data!.docs;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 100.0.h,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(left: 40.w, bottom: 13),
                      title: Text(
                        nameFolder,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      list.map((e) => _boxHouse(e, context)).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  GestureDetector _boxHouse(dynamic house, BuildContext context) {
    context.read<FavoritePageProvider>().catchHouse(jsonHome: house);
    HomeModel homeProvider =
        context.select((FavoritePageProvider provider) => provider.home);
    return SizedBox(
      height: 350,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// image
            Container(
              width: 1.sw,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  height: 250,
                  imageUrl: homeProvider.houseImages.first,
                  placeholder: (context, url) => const ColoredBox(
                    color: Color(0x999f9f9f),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ).putElevation(
              elevation: 6.0,
              radius: 10.0,
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  homeProvider.city,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "\$${homeProvider.price}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(homeProvider.street),
            Row(
              children: [
                _textFacilities(homeProvider.bedsCount, 'кровати', 'кровать'),
                _textFacilities(homeProvider.bathCount, 'ванны', 'ванна'),
                _textFacilities(homeProvider.roomsCount, 'комнаты', 'комната'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${homeProvider.houseArea}m',
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
                const Spacer(),
                Text(
                  homeProvider.pushedDate.substring(0, 16),
                  style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    ).onTap(function: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailPage(homeModel: homeProvider)));
    });
  }

  Padding _textFacilities(item, singleText, multiText) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        item + " " + '${int.tryParse(item)! > 1 ? singleText : multiText}',
        style: TextStyle(fontSize: 11.sp),
      ),
    );
  }
}
