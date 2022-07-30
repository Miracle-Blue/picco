import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/7-image_upload_page/provider.dart';
import 'package:picco/services/log_service.dart';
import 'package:provider/provider.dart';

class ImageView extends StatelessWidget {
  const ImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ImageUploadProvider>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.imagesDownloadUrls.length != 5
                          ? "Добавьте хотя бы 5 фото"
                          : 'Готово всё в порядке?',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 2.h),
                    const Text("Перетащите фото, чтобы изменить порядок"),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              MaterialButton(
                child: Row(
                  children: [
                    const Icon(
                      CupertinoIcons.arrow_down_to_line_alt,
                      size: 13,
                    ),
                    SizedBox(width: 8.0.w),
                    const Text(
                      'Загрузить',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                onPressed: () {
                  provider.getNeededImage();
                },
              ),
            ],
          ),
          const SizedBox(height: 14.0),
          provider.imagesDownloadUrls.isNotEmpty
              ? Stack(
                  children: [
                    Container(
                      width: 1.sw,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: AspectRatio(
                        aspectRatio: (4 / 2.5),
                        child: CachedNetworkImage(
                          imageUrl: provider.imagesDownloadUrls.first,
                          placeholder: (context, url) => const ColoredBox(
                            color: Color(0x999f9f9f),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ).onTap(function: () {
                      provider.runBottomSheet(
                          context, _bottomSheet(context, provider, -1));
                    }),
                  ],
                )
              : Container(
                  width: 1.sw,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: AspectRatio(
                    aspectRatio: (4 / 2.5),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: provider.changeColorForSelectedImage[-1]!
                          ? ColoredBox(color: Colors.grey.shade300)
                          : const Icon(CupertinoIcons.camera),
                    ),
                  ),
                ).onTap(function: () {
                  provider.getSingleFileImages(-1);
                }),
          SizedBox(height: 10.h),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 4 / 2.5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              Log.d(provider.imagesDownloadUrls.length.toString());
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: provider.imagesDownloadUrls.length < (index + 2)
                    ? GestureDetector(
                        onTap: () {
                          provider.getSingleFileImages(index);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: provider.changeColorForSelectedImage[index]!
                                ? ColoredBox(color: Colors.grey.shade300)
                                : const Icon(CupertinoIcons.camera)),
                      )
                    : Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: provider.imagesDownloadUrls[index + 1],
                            placeholder: (context, url) => const ColoredBox(
                              color: Color(0x999f9f9f),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ).onTap(
                            function: () {
                              // provider.deleteImage(index);
                              provider.runBottomSheet(
                                context,
                                _bottomSheet(context, provider, index),
                              );
                            },
                          ),
                        ],
                      ),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  _bottomSheet(BuildContext context, ImageUploadProvider provider, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.close),
            ),
          ),
          SizedBox(height: 20.h),
          _bottomSheetButtons(
              "Поставить фото на главную", context, provider, index),
          _bottomSheetButtons("Удалить фото", context, provider, index),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  Padding _bottomSheetButtons(
    String text,
    BuildContext context,
    ImageUploadProvider provider,
    int index,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: MaterialButton(
        color: Colors.grey.shade100,
        elevation: 1,
        minWidth: 1.sw,
        height: 50.h,
        textColor: text[0] != "У" ? Colors.black : Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: text[0] != "У" ? const Radius.circular(8) : Radius.zero,
            bottom: text[0] == "У" ? const Radius.circular(8) : Radius.zero,
          ),
        ),
        onPressed: () {
          if (text[0] == "У") {
            provider.deleteImage(index);
            Navigator.pop(context);
          } else if (index == -1){
            null;
          } else {
            provider.changeImageIndexToTop(index);
            Navigator.pop(context);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
            Icon(
              text[0] != "У" ? index == -1 ? CupertinoIcons.star_fill : CupertinoIcons.star : CupertinoIcons.delete,
              size: 16.h,
              color: text[0] != "У" ? index == -1? Colors.yellow : Colors.black : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
