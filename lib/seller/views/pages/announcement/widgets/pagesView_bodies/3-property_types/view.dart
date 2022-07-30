import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picco/customer/viewmodel/utils.dart';
import 'package:picco/seller/views/pages/announcement/widgets/pagesView_bodies/3-property_types/provider.dart';
import 'package:picco/services/utils.dart';
import 'package:provider/provider.dart';

class PropertyType extends StatelessWidget {
  const PropertyType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PropertyTypeProvider>();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 30),
      itemCount: provider.data.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => box(index, provider, context),
    );
  }

  Widget box(int index, PropertyTypeProvider provider, BuildContext context) {
    return Container(
      height: 70,
      width: 1.sw,
      margin: EdgeInsets.only(bottom: 15.h, left: 15.w, right: 15.w),
      padding: EdgeInsets.only(left: 15.w, right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: provider.selectTypeHouseIndex == index
              ? Colors.black
              : Colors.grey.shade300,
          width: provider.selectTypeHouseIndex == index ? 1.5 : 1.3,
        ),
        color: provider.selectTypeHouseIndex == index
            ? Colors.grey.withOpacity(0.08)
            : Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            provider.data.keys.toList()[index],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image(
              image: AssetImage(provider.data.values.toList()[index]),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    ).onTap(function: () {
      if (index != 0) {
        HapticFeedback.heavyImpact();
        Utils.dialogWithRichTextBody(
          context,
          "Исправляется",
          "Сейчат, Вы можете выбрать только ",
          provider.data.keys.toList()[0],
        );
        return;
      }
      provider.chooseHouseType(index);
    });
  }
}
