import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/6-property_benefits_page/provider.dart';
import 'package:picco/services/log_service.dart';

import 'package:provider/provider.dart';

class PropertyBenefits extends StatelessWidget {
  const PropertyBenefits({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PropertyBenefitsProvider>();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 15.0,
      ),
      children: [
         Text(
          'Есть ли у вас особые удобства ?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
         SizedBox(height: 20.h),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 6/4,
          ),
          itemCount: provider.media.length,
          itemBuilder: (BuildContext context, index) {
            Log.i(provider.facilities.values.toList().toString());
            return Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: provider.facilities.values.toList()[index]
                      ? Colors.black
                      : Colors.grey.shade300,
                  width: provider.facilities.values.toList()[index] ? 1.5 : 1.3,
                ),
                color: provider.facilities.values.toList()[index]
                    ? Colors.grey.withOpacity(0.08)
                    : Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.media.values.toList()[index],
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.h),
                    Image.asset(
                      provider.media.keys.toList()[index],
                      width: 0.06.sw,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ).onTap(function: () {
              provider.updateFacilities(index);
            });
          },
        ),
      ],
    );
  }
}
