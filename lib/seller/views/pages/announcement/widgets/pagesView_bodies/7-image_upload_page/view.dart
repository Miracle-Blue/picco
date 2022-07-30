import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/7-image_upload_page/provider.dart';
import 'package:provider/provider.dart';

class ImageUpload extends StatelessWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ImageUploadProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
      child: provider.showLottie || provider.showCheckLottie
          ? Center(
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: provider.showCheckLottie
                    ? Lottie.asset(
                        "assets/lottie/checkimageLoad.json",
                        repeat: false,
                      )
                    : Lottie.asset('assets/lottie/image_loading.json'),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Всего можно загрузить 5 фотографий",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                const _ListWidget(index: 0),
                const _ListWidget(index: 1),
              ],
            ),
    );
  }
}

class _ListWidget extends StatelessWidget {
  final int index;

  const _ListWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ImageUploadProvider>();
    return Container(
      height: 60.0.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffC4C4C4)),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        onTap: () async {
          index == 0
              ? await provider.getFileImages()
              : await provider.getCameraImage();
        },
        contentPadding: EdgeInsets.only(left: 25.w),
        leading: index == 0
            ? Icon(
                Icons.image_outlined,
                size: 20.sp,
                color: Colors.black,
              )
            : Icon(
                CupertinoIcons.camera,
                size: 20.sp,
                color: Colors.black,
              ),
        title: Text(
          provider.media.values.toList()[index],
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}
