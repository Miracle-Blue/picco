import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/view/widgets/top_divider_bottom_sheet.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/services/color_service.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => FilterProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.watch<FilterProvider>();
    double statusBarHeight = MediaQueryData.fromWindow(window).padding.top;
    return SizedBox(
      height: MediaQuery.of(context).size.height - statusBarHeight,
      child: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (_, controller) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top
                      Center(child: topDividerBottomSheet()),
                      // * Close button
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 4.0),
                        child: InkWell(
                          child: const Icon(Icons.close, size: 28),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      Expanded(
                        child: ListView(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            /// Price
                            _mainText("Ценовой диапазон"),
                            SizedBox(height: 10.h),
                            // * Display price range
                            Text(
                              "\$ ${provider.minPrice} - \$ ${provider.maxPrice}",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xFF010047),
                              ),
                            ),
                            // * Average Price
                            Text(
                              'Средняя цена: \$${provider.avgPrice}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // * Set price range via Slider
                            SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 0.1,
                                thumbColor: ColorService.main,
                                valueIndicatorColor: ColorService.main,
                                showValueIndicator: ShowValueIndicator.always,
                              ),
                              child: RangeSlider(
                                activeColor: ColorService.main,
                                inactiveColor: CupertinoColors.systemGrey3,
                                min: 1,
                                max: 100,
                                values: provider.sliderValue,
                                labels: RangeLabels(
                                  '\$${provider.minPrice}',
                                  '\$${provider.maxPrice}',
                                ),
                                onChanged: (value) {
                                  provider.sliderValue = value;
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Divider(thickness: 1),
                            ),

                            /// House properties
                            _mainText("Комнаты и кровати"),
                            SizedBox(height: 15.h),
                            for (int i = 0;
                                i < provider.houseProperties.length;
                                i++)
                              HouseProperties(provider: provider, i: i),

                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Divider(thickness: 1),
                            ),

                            /// Home appliances
                            _mainText("Бытовая техника"),
                            SizedBox(height: 15.h),
                            for (int i = 0;
                                i < provider.facilities.length;
                                i++)
                              HomeAppliances(
                                title: provider.facilities[i],
                                provider: provider,
                              ),
                            SizedBox(height: 80.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  height: 75.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: provider.clear,
                        child: const Text(
                          'Очистить все',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => provider.done(context),
                        color: ColorService.main,
                        minWidth: 107,
                        height: 45.h,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: const Text(
                          'Готово',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ).putElevationOffset(
                    radius: 0.0, elevation: 8.0, y: 5.0, x: 0.0),
              ],
            );
          }),
    );
  }

  Text _mainText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class HouseProperties extends StatelessWidget {
  final FilterProvider provider;
  final int i;

  const HouseProperties({Key? key, required this.provider, required this.i})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          provider.houseProperties[i],
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 30.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: provider.propertiesNumber.length,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  provider.updateSelected(index, i);
                },
                child: Container(
                  width: index == 0 ? 100 : 50,
                  alignment: Alignment.center,
                  child: Text(
                    provider.propertiesNumber[index],
                    style: TextStyle(
                      color: provider.checkIfSelected(index, i)
                          ? Colors.white
                          : Colors.black,
                      fontSize: 12.sp,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorService.main),
                    borderRadius: BorderRadius.circular(50),
                    color: provider.checkIfSelected(index, i)
                        ? ColorService.main
                        : null,
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 8);
            },
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class HomeAppliances extends StatelessWidget {
  final FilterProvider provider;
  final String title;

  const HomeAppliances({
    Key? key,
    required this.title,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      value: provider.identifyValue(title),
      activeColor: ColorService.main,
      onChanged: (value) {
        provider.updateValue(title, value ?? false);
      },
    );
  }
}
