import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/2-sale_types_page/provider.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';

class SaleTypes extends StatelessWidget {
  const SaleTypes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SaleTypesProvider>();
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int index = 0; index < provider.data.length; index++)
            Container(
              width: 1.sw,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                  color: provider.selectTypeSaleIndex == index
                      ? Colors.black
                      : Colors.grey.shade300,
                  width: provider.selectTypeSaleIndex == index ? 1.5 : 1.4,
                ),
                color: provider.selectTypeSaleIndex == index
                    ? Colors.grey.withOpacity(0.05)
                    : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.data[index].keys.first,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    provider.data[index].values.first,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ).onTap(
              function: () {
                if (index == 1) {
                  HapticFeedback.heavyImpact();
                  Utils.dialogWithRichTextBody(
                    context,
                    "Исправляется",
                    "Сейчат, Вы можете выбрать только ",
                    provider.data[0].keys.first,
                  );
                  return;
                }
                provider.chooseSaleType(index);
              },
            ),
        ],
      ),
    );
  }
}
