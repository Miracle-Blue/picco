import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:picco/customer/view/pages/search/detail_page.dart';
import 'package:picco/customer/view/widgets/top_divider_bottom_sheet.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/models/home_model.dart';
import 'package:picco/services/color_service.dart';
import 'package:picco/services/connectivity_service.dart';
import 'package:picco/services/hive_service.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'search_page_provider.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({Key? key}) : super(key: key);

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  final scrollController = ScrollController();
  bool fullyState = false;
  List list = [0.5, 0.5];
  bool notAddedFirst = true;

  @override
  Widget build(BuildContext context) {
    final provider = SearchPageInherit.read(context)!;
    return SnappingSheet(
      onSheetMoved: (move) {
        if (move.relativeToSnappingPositions == 1) {
          setState(() {
            fullyState = true;
          });
        } else {
          setState(() {
            fullyState = false;
          });
        }

        if (notAddedFirst) {
          list[0] = list[1];
          notAddedFirst = false;
        } else {
          list[1] = move.relativeToSnappingPositions;
        }

        if (list[0] - list[1] == 0.5 && list[0] * list[1] == 0) {
          if (!list.contains(1.0)) {
            provider.zoomIn();
          }
          notAddedFirst = true;
        }
        if (list.first == 1 && list.last == 0) {
          list[0] = 0;
        }
        if (list.first == 0 && list.last == 1) {
          list[1] = 0;
        }

        if (list[0] - list[1] == -0.5 && list[0] * list[1] == 0) {
          if (!list.contains(1.0)) {
            provider.zoomOut();
          }
          notAddedFirst = true;
        }
      },
      initialSnappingPosition: const SnappingPosition.factor(
        positionFactor: 0.5,
        snappingDuration: Duration(milliseconds: 300),
        grabbingContentOffset: GrabbingContentOffset.top,
      ),
      lockOverflowDrag: true,
      snappingPositions: const [
        SnappingPosition.factor(
          positionFactor: 0.0,
          snappingDuration: Duration(milliseconds: 300),
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
        SnappingPosition.factor(
          positionFactor: 0.5,
          snappingDuration: Duration(milliseconds: 300),
        ),
        SnappingPosition.factor(
          positionFactor: 1,
          snappingDuration: Duration(milliseconds: 300),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
      ],
      // #Above the Bottom Navigation Bar
      grabbing: Container(
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: fullyState ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 25,
              color: Colors.black.withOpacity(0.2),
            ),
          ],
        ),
        child: fullyState ? const SizedBox.shrink() : topDividerBottomSheet(),
      ),

      grabbingHeight: 35,
      controller: provider.snappingSheetController,
      sheetAbove: null,
      sheetBelow: SnappingSheetContent(
        draggable: true,
        childScrollController: scrollController,
        child: BottomSheetContent(scrollController: scrollController),
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  final ScrollController scrollController;

  const BottomSheetContent({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SearchPageInherit.watch(context)!;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        controller: scrollController,
        itemCount:
            filteredHomes.isNotEmpty ? filteredHomes.length : homes.length,
        itemBuilder: (context, index) => SheetHomeElement(
          home: filteredHomes.isNotEmpty
              ? filteredHomes.values.toList()[index]
              : homes[index],
        ),
      ),
    );
  }
}

class SheetHomeElement extends StatelessWidget {
  final HomeModel home;

  const SheetHomeElement({Key? key, required this.home}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = SearchPageInherit.watch(context)!;
    final connection = context.watch<ConnectivityResult>();
    return SizedBox(
      height: 380,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CachedNetworkImage(
                      height: 250,
                      width: 1.sw,
                      imageUrl: home.houseImages.first,
                      placeholder: (context, url) => const ColoredBox(
                        color: Color(0x999f9f9f),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image_outlined),
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      onPressed: HiveService.getUser().role == "anonymous"
                          ? () async {
                              await ConnectivityService.isConnectInternet(
                                connection,
                                context,
                              ).then((value) {
                                Utils.dialogCommon(
                                  context,
                                  "Регистрация",
                                  "Bы должны зарегистрироваться",
                                  true,
                                  () {
                                    Navigator.pop(context);
                                  },
                                );
                              });
                            }
                          : () async {
                              await ConnectivityService.isConnectInternet(
                                connection,
                                context,
                              );
                              if (provider.favoriteHouseIsLike(home.id!)) {
                                provider.removeHouseFromFavorite(home.id!);
                                return;
                              }
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.r),
                                  ),
                                ),
                                builder: (context) => FavoriteListBottomSheet(
                                  home: home,
                                  provider: provider,
                                ),
                              ).then(
                                (value) {
                                  if (value != false) {
                                    provider.disposeFavoriteHouses();
                                  }
                                },
                              );
                            },
                      icon: Icon(
                        provider.favoriteHouseIsLike(home.id!)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: provider.favoriteHouseIsLike(home.id!)
                            ? Colors.red
                            : Colors.white,
                        size: 25.sp,
                      ),
                      padding: EdgeInsets.all(15.w),
                    ),
                  ],
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
                  home.city,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "\$${home.price}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(home.street),
            Row(
              children: [
                _textFacilities(home.bedsCount, 'кровати', 'кровать'),
                _textFacilities(home.bathCount, 'ванны', 'ванна'),
                _textFacilities(home.roomsCount, 'комнаты', 'комната'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${home.houseArea}m',
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
              ],
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Text(
                  "Опубликовано: ",
                  style: TextStyle(fontSize: 11.sp),
                ),
                Text(
                  home.pushedDate.substring(0, 16),
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    ).onTap(function: () async {
      provider.snappingSheetController.snapToPosition(
        const SnappingPosition.factor(
          positionFactor: 0.0,
          snappingDuration: Duration(milliseconds: 10),
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
      );

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(homeModel: home),
        ),
      );

      if (result is Geo) {
        final mapController = await provider.completer.future;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                result.latitude,
                result.longitude,
              ),
              zoom: 18.4,
            ),
          ),
        );
      }
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

class FavoriteListBottomSheet extends StatelessWidget {
  final HomeModel home;
  final SearchProvider provider;

  const FavoriteListBottomSheet(
      {Key? key, required this.home, required this.provider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return SizedBox(
      height: 1.sh - HiveService.box.get("height"),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: topDividerBottomSheet()),
            SizedBox(height: 10.h),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  icon: const Icon(CupertinoIcons.clear),
                ),
                Text(
                  "Список любимых домов",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10.w),
              child: Column(
                children: [
                  _createdNewFolderBox().onTap(
                    function: () async {
                      await createNewFavoriteList(context, isKeyboard)
                          .then((value) => Navigator.pop(context));
                    },
                  ),
                  for (var folder in provider.favoriteHouses)
                    _folderBox(
                      folder.keys.first,
                      folder.values.first[0]["houseImages"][0],
                      home,
                      context,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _createdNewFolderBox() {
    return Container(
      height: 60.h,
      width: 1.sw,
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 60.h,
            height: 1.sh,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: Colors.grey.shade300,
              ),
            ),
            child: const Icon(CupertinoIcons.add),
          ),
          SizedBox(width: 15.w),
          Text(
            "Создать новый лист",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createNewFavoriteList(BuildContext context, bool isKeyboard) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            setState(() =>
                isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: TextField(
                      controller: provider.favoriteHouseFolderNameController,
                      decoration: InputDecoration(
                        hintText: "Введите название списка",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (!isKeyboard)
                    MaterialButton(
                      onPressed: () async {
                        provider.createNewFavoriteHouseProvider(home);
                        Navigator.pop(context);
                      },
                      color: ColorService.main,
                      textColor: Colors.white,
                      height: 45.h,
                      minWidth: 0.5.sw,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: const Text("Сохранить"),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  GestureDetector _folderBox(
    String nameFolder,
    String img,
    HomeModel home,
    BuildContext context,
  ) {
    final connection = context.watch<ConnectivityResult>();
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
    ).onTap(function: () async {
      await ConnectivityService.isConnectInternet(
        connection,
        context,
      );
      provider.addNewFavoriteHouseToFolder(nameFolder, home);
      Navigator.pop(context);
    });
  }
}
