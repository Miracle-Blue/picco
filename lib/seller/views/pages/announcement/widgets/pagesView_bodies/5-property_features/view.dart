import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/5-property_features/provider.dart';
import 'package:provider/provider.dart';

class PropertyFeatures extends StatelessWidget {
  const PropertyFeatures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          property(context, 'Кровати', [true, false, false, false]),
          property(context, 'Ванны', [false, true, false, false]),
          property(context, 'Комнаты', [false, false, true, false]),
          property(context, 'Площадь', [false, false, false, true]),
        ],
      ),
    );
  }

  Widget property(
      BuildContext context, String property, List<bool> expression) {
    final provider = context.watch<PropertyFeaturesProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          property,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        expression[3] == true
            ? Row(
                children: [
                  GestureDetector(
                    onLongPress: () {
                      provider.longPressCanceled = false;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (!provider.longPressCanceled) {
                          provider.timer = Timer.periodic(
                              const Duration(milliseconds: 150), (timer) {
                            provider.updateHomeArea(provider.homeArea -= 5);
                          });
                        }
                      });
                    },
                    onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
                      provider.cancelUpdatingHomeArea();
                    },
                    onTap: () {
                      provider.updateHomeArea(provider.homeArea -= 5);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        CupertinoIcons.minus_circled,
                        size: 25.sp,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 70,
                    alignment: Alignment.center,
                    child: Text(
                      provider.homeArea.toString(),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  GestureDetector(
                    onLongPress: () {
                      provider.longPressCanceled = false;
                      Future.delayed(const Duration(milliseconds: 300), () {
                        if (!provider.longPressCanceled) {
                          provider.timer = Timer.periodic(
                              const Duration(milliseconds: 150), (timer) {
                            provider.updateHomeArea(provider.homeArea += 5);
                          });
                        }
                      });
                    },
                    onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
                      provider.cancelUpdatingHomeArea();
                    },
                    onTap: () {
                      provider.updateHomeArea(provider.homeArea += 5);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        CupertinoIcons.add_circled,
                        size: 25.sp,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.minus_circled,
                      size: 25.sp,
                    ),
                    onPressed: () {
                      expression[0] == true
                          ? provider.updateBeds(provider.bedsNumber - 1)
                          : expression[1] == true
                              ? provider.updateBath(provider.bathsNumber - 1)
                              : provider.updateRooms(provider.roomsNumber - 1);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    width: 35.w,
                    alignment: Alignment.center,
                    child: Text(
                      expression[0] == true
                          ? provider.bedsNumber.toString()
                          : expression[1] == true
                              ? provider.bathsNumber.toString()
                              : provider.roomsNumber.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.add_circled,
                      size: 25.sp,
                    ),
                    onPressed: () {
                      expression[0] == true
                          ? provider.updateBeds(provider.bedsNumber + 1)
                          : expression[1] == true
                              ? provider.updateBath(provider.bathsNumber + 1)
                              : provider.updateRooms(provider.roomsNumber + 1);
                    },
                  )
                ],
              ),
      ],
    );
  }
}
