import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/pages/favorite/local_widgets/favorite_houses_page.dart';
import 'package:picco/customer/view/pages/search/search_page.dart';
import 'package:picco/customer/view/widgets/widget_utils.dart';
import 'package:picco/customer/viewmodel/utils.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              WidgetUtils.header('Избранные дома'),
              SizedBox(height: 20.h),
              if (favoriteObject.list.isEmpty)
                Text(
                  'Вы можете собрать свои любимые места здесь.',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.grey,
                  ),
                ),
              for (var folder in favoriteObject.list)
                _folderBox(
                  folder.keys.first,
                  folder.values.first[0]["houseImages"][0],
                  context,
                )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _folderBox(
    String nameFolder,
    String img,
    BuildContext context,
  ) {
    return Container(
      height: 60.h,
      width: 1.sw,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: 15.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: CachedNetworkImage(
              height: 1.sh,
              width: 60.h,
              imageUrl: img,
              placeholder: (context, url) => const ColoredBox(
                color: Color(0x999f9f9f),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 15.w),
          Text(
            nameFolder,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).onTap(
      function: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FavoriteHousesPage(),
            settings: RouteSettings(arguments: nameFolder),
          ),
        );
      },
    );
  }
}
