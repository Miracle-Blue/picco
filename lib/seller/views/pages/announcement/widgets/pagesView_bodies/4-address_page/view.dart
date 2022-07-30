import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/seller/views/pages/announcement/widgets/map.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/4-address_page/provider.dart';
import 'package:picco/seller/views/pages/announcement/widgets/titles_and_buttons/save_button.dart';
import 'package:picco/services/hive_service.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddressPageProvider>();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
                child: Lottie.asset(
                  "assets/lottie/location.json",
                  width: 0.6.sw,
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await provider.showBottomSheet(context).then(
                            (value) => provider.updateButtonDisability(false),
                          );
                    },
                    color: Colors.white,
                    minWidth: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: const StadiumBorder(),
                    child: Row(
                      children: const [
                        SizedBox(width: 15),
                        Icon(CupertinoIcons.location),
                        SizedBox(width: 10),
                        Text(
                          "Введите адрес",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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

class BottomSheetContentInAddress extends StatefulWidget {
  const BottomSheetContentInAddress({Key? key}) : super(key: key);

  @override
  State<BottomSheetContentInAddress> createState() =>
      _BottomSheetContentInAddressState();
}

class _BottomSheetContentInAddressState
    extends State<BottomSheetContentInAddress> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddressPageProvider(),
      builder: (context, child) {
        final provider = context.watch<AddressPageProvider>();
        dynamic heightStatusBar = HiveService.box.get("height");
        print('$heightStatusBar');
        return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 1,
          maxChildSize: 1,
          builder: (context, controller) {
            return provider.regionAddress.regions.isNotEmpty
                ? Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: heightStatusBar ?? 60),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Введите аддрес',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.0.h),
                        BottomSheetFields(
                          label: "Область",
                          provider: provider,
                          list: provider.regionAddress.regions,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: BottomSheetFields(
                            label: "Район/Город",
                            provider: provider,
                            list: provider.listDistricts,
                          ),
                        ),
                        TextField(
                          controller: provider.streetTextController,
                          decoration: InputDecoration(
                            hintText: "А.Навоий, 12А",
                            helperText: "Название улицы и номер дома",
                            contentPadding: const EdgeInsets.fromLTRB(
                              15.0,
                              14.0,
                              15.0,
                              14.0,
                            ),
                            errorText: provider.isActiveStreetTextField
                                ? TextFieldCheckError.errorText(
                                    provider.streetTextController,
                                    false,
                                    false,
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0.r),
                            ),
                          ),
                          onSubmitted: (_) {
                            provider.onSubmit();
                          },
                          onChanged: (_) => provider.onChange(),
                        ),
                        const SizedBox(height: 20.0),
                        const Divider(),
                        const SizedBox(height: 10.0),
                        Text(
                          'Точное место',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          child: Text(
                            'Вы можете показать, где именно находится жилье. Пожалуйста, внимательно введите местоположение!',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          height: 0.3.sh,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              MapVV(provider),
                              GestureDetector(
                                onTap: () => provider.openMapPage(
                                  context,
                                  provider,
                                ),
                                child: AnimatedContainer(
                                  height: 0.3.sh,
                                  duration: const Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: !provider.hiddenWidget
                                        ? Colors.transparent
                                        : Colors.black.withOpacity(0.5),
                                  ),
                                  child: !provider.hiddenWidget
                                      ? const SizedBox.shrink()
                                      : Center(
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            height: 0.07.sh,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                            child: Image.asset(
                                              "assets/icons/home_page_icons/home_page_search_icon.png",
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const SaveButton(),
                      ],
                    ),
                  )
                : Container(
                    child: const CircularProgressIndicator(),
                    alignment: Alignment.center,
                  );
          },
        );
      },
    );
  }
}

class BottomSheetFields extends StatelessWidget {
  final String label;
  final AddressPageProvider provider;
  final List list;

  const BottomSheetFields({
    Key? key,
    required this.label,
    required this.list,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      child: DropdownButtonFormField<String>(
        icon: const Icon(Icons.keyboard_arrow_down),
        iconEnabledColor: Colors.black54,
        iconDisabledColor: Colors.grey,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(15.0, 14.0, 15.0, 14.0),
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0.r),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
        value: list[0],
        items: list
            .map((e) => DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                )))
            .toList(),
        onChanged: (option) {
          provider.chooseOption(option!, label, context);
        },
      ),
    );
  }
}
